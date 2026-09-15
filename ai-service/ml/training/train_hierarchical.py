import pandas as pd
from pathlib import Path

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score

BASE_DIR = Path(__file__).resolve().parents[2]

TRAIN_FILE = BASE_DIR / "ml" / "data" / "train.csv"
TEST_FILE = BASE_DIR / "ml" / "data" / "test.csv"
MANUAL_FILE = BASE_DIR / "ml" / "data" / "manual_test.csv"


def create_model():
    model = Pipeline([
        (
            "tfidf", TfidfVectorizer(
            lowercase=True,
            ngram_range=(1, 2),
            min_df=2,
            )
        ),
        (
            "classifier", LogisticRegression(
                max_iter=1000,
        )
    )])
    return model

def train_category_model(train_df):
    print("\nLoading data...")

    X_train = train_df["instruction"]
    y_train = train_df["category"]

    model = create_model()
    print("\nTraining model...")

    model.fit(X_train, y_train)
    print("training complete.")

    return model


def train_intent_model(train_df):

    print("\nTraining intent models...")

    intent_model = {}

    categories = train_df["category"].unique()

    for category in categories:

        category_df = train_df[
            train_df["category"] == category
        ]

        intents = category_df["intent"].unique()

        # If category has only one intent,
        # no ML model is needed.
        if len(intents) == 1:

            intent_model[category] = intents[0]

            print(
                f"{category}: "
                f"1 intent -> {intents[0]}"
            )

            continue

        X_train = category_df["instruction"]
        y_train = category_df["intent"]

        model = create_model()

        model.fit(X_train, y_train)

        intent_model[category] = model

        print(
            f"{category}: "
            f"{len(intents)} intents"
        )

    print("Intent model training complete.")

    return intent_model


def evaluate_model(category_model, intent_model, test_df):
    print("\nEvaluating hierarchical model...")

    X_test = test_df["instruction"]
    y_test = test_df["intent"]

    #first, predict the category
    predicted_categories = category_model.predict(X_test)

    #then, predict the intent based on the predicted category
    predictions = []

    for instruction, category in zip(
        X_test, predicted_categories
        ):

        model = intent_model[category]

        if isinstance(model, str):
            predicted_intent = model
        else:
            predicted_intent = model.predict(
                [instruction]
            )[0]

        predictions.append(predicted_intent)

    accuracy = accuracy_score(y_test, predictions)
    print("\nHierarchical Intent Accuracy:", accuracy)

    print("\nClassification report:")
    print(classification_report(y_test, predictions))


def manual_test(category_model, intent_model):
    print("\nLoading Manual testing set...")
    manual_df = pd.read_csv(MANUAL_FILE)

    X_manual = manual_df["instruction"]
    y_manual = manual_df["intent"]

    #first, predict the category
    predicted_categories = category_model.predict(X_manual)

    #then, predict the intent based on the predicted category
    predictions = []

    for instruction, category in zip(
        X_manual, predicted_categories
    ):

        model = intent_model[category]

        if isinstance(model, str):
            predicted_intent = model
        else:
            predicted_intent = model.predict(
                [instruction]
            )[0]

        predictions.append(predicted_intent)

    accuracy = accuracy_score(y_manual, predictions)
    print(f"\nManual Test Accuracy: {accuracy}")

    print("\nManual Test Results:")

    for instruction, actual_intent, predicted_intent in zip(
        X_manual, y_manual, predictions
    ):
        print(f"Instruction: {instruction}")
        print(f"Actual Intent: {actual_intent}")
        print(f"Predicted Intent: {predicted_intent}")
        print()



def train_model():
    print("\nLoading data...")

    train_df = pd.read_csv(TRAIN_FILE)
    test_df = pd.read_csv(TEST_FILE)

    print("\nTraining Rows:", len(train_df))
    print("Test Rows:", len(test_df))

    category_model = train_category_model(train_df)
    intent_model = train_intent_model(train_df)
    evaluate_model(category_model, intent_model, test_df)
    manual_test(category_model, intent_model)

if __name__ == "__main__":
    train_model()