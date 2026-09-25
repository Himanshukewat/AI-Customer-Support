import pandas as pd
from pathlib import Path
import joblib

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score
from sklearn.pipeline import FeatureUnion

BASE_DIR = Path(__file__).resolve().parents[2]

TRAIN_FILE = BASE_DIR / "ml" / "data" / "train_augmented.csv"
TEST_FILE = BASE_DIR / "ml" / "data" / "test.csv"
MANUAL_FILE = BASE_DIR / "ml" / "data" / "manual_test.csv"


def create_model():
    model = Pipeline([
        (
            "features",
            FeatureUnion([
                (
                    "word_tfidf",
                    TfidfVectorizer(
                        lowercase=True,
                        analyzer="word",
                        ngram_range=(1, 2),
                        min_df=2
                    )
                ),
                (
                    "char_tfidf",
                    TfidfVectorizer(
                        lowercase=True,
                        analyzer="char",
                        ngram_range=(3, 5),
                        min_df=2
                    )
                )
            ])
        ),
        (
            "classifier",
            LogisticRegression(
                max_iter=1000
            )
        )
    ])

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
    y_category = test_df["category"]
    y_intent = test_df["intent"]


    #first, predict the category
    predicted_categories = category_model.predict(X_test)

    category_accuracy = accuracy_score(y_category, predicted_categories)

    print(
        "\nCategory Accuracy:",
        round(category_accuracy, 4)
    )

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

    intent_accuracy = accuracy_score(y_intent, predictions)
    print("\nHierarchical Intent Accuracy:", round(intent_accuracy, 4))

    print("\nClassification report:")
    print(classification_report(y_intent, predictions))


# def manual_test(category_model, intent_model, train_df):
#     print("\nLoading Manual testing set...")

#     manual_df = pd.read_csv(MANUAL_FILE)

#     X_manual = manual_df["instruction"]
#     y_intent = manual_df["intent"]

#     # Create intent -> category mapping from training data
#     intent_to_category = (
#         train_df
#         .drop_duplicates("intent")
#         .set_index("intent")["category"]
#         .to_dict()
#     )

#     y_category = y_intent.map(intent_to_category)

#     # First, predict the category
#     predicted_categories = category_model.predict(X_manual)

#     category_accuracy = accuracy_score(
#         y_category,
#         predicted_categories
#     )

#     print(
#         "\nManual Category Accuracy:",
#         round(category_accuracy, 4)
#     )

#     # Then, predict intent based on predicted category
#     predictions = []

#     for instruction, category in zip(
#         X_manual,
#         predicted_categories
#     ):
#         model = intent_model[category]

#         if isinstance(model, str):
#             predicted_intent = model
#         else:
#             predicted_intent = model.predict(
#                 [instruction]
#             )[0]

#         predictions.append(predicted_intent)

#     intent_accuracy = accuracy_score(
#         y_intent,
#         predictions
#     )

#     print(
#         "Manual Hierarchical Intent Accuracy:",
#         round(intent_accuracy, 4)
#     )

#     print("\nWrong Predictions:")

#     wrong_count = 0

#     for instruction, actual_category, predicted_category, actual_intent, predicted_intent in zip(
#         X_manual,
#         y_category,
#         predicted_categories,
#         y_intent,
#         predictions
#     ):

#         if actual_intent != predicted_intent:

#             wrong_count += 1

#             print(f"\nInstruction: {instruction}")
#             print(f"Actual Category: {actual_category}")
#             print(f"Predicted Category: {predicted_category}")
#             print(f"Actual Intent: {actual_intent}")
#             print(f"Predicted Intent: {predicted_intent}")

#     print(f"\nTotal Wrong Predictions: {wrong_count}")


def manual_test(category_model, intent_model, train_df):
    print("\nLoading Manual testing set...")

    manual_df = pd.read_csv(MANUAL_FILE)

    X_manual = manual_df["instruction"]
    y_intent = manual_df["intent"]

    # Actual category from training dataset
    intent_to_category = (
        train_df
        .drop_duplicates("intent")
        .set_index("intent")["category"]
        .to_dict()
    )

    y_category = y_intent.map(intent_to_category)

    # --------------------------------------------------
    # 1. Predict category + confidence
    # --------------------------------------------------

    predicted_categories = category_model.predict(X_manual)

    category_probabilities = category_model.predict_proba(X_manual)
    category_classes = category_model.classes_

    category_accuracy = accuracy_score(
        y_category,
        predicted_categories
    )

    print(
        "\nManual Category Accuracy:",
        round(category_accuracy, 4)
    )

    # --------------------------------------------------
    # 2. Normal hierarchical prediction
    # --------------------------------------------------

    normal_predictions = []
    normal_confidences = []
    normal_top3 = []

    for instruction, category in zip(
        X_manual,
        predicted_categories
    ):

        model = intent_model[category]

        if isinstance(model, str):

            predicted_intent = model
            confidence = 1.0
            top3 = [(model, 1.0)]

        else:

            predicted_intent = model.predict(
                [instruction]
            )[0]

            probabilities = model.predict_proba(
                [instruction]
            )[0]

            classes = model.classes_

            sorted_indices = probabilities.argsort()[::-1]

            top3 = [
                (
                    classes[i],
                    round(probabilities[i], 3)
                )
                for i in sorted_indices[:3]
            ]

            confidence = probabilities[
                list(classes).index(predicted_intent)
            ]

        normal_predictions.append(predicted_intent)
        normal_confidences.append(confidence)
        normal_top3.append(top3)

    normal_accuracy = accuracy_score(
        y_intent,
        normal_predictions
    )

    print(
        "Normal Hierarchical Intent Accuracy:",
        round(normal_accuracy, 4)
    )

    # --------------------------------------------------
    # 3. Oracle category prediction
    # --------------------------------------------------

    oracle_predictions = []

    for instruction, category in zip(
        X_manual,
        y_category
    ):

        model = intent_model[category]

        if isinstance(model, str):

            predicted_intent = model

        else:

            predicted_intent = model.predict(
                [instruction]
            )[0]

        oracle_predictions.append(predicted_intent)

    oracle_accuracy = accuracy_score(
        y_intent,
        oracle_predictions
    )

    print(
        "Oracle Category Intent Accuracy:",
        round(oracle_accuracy, 4)
    )

    # --------------------------------------------------
    # 4. Show wrong predictions + confidence
    # --------------------------------------------------

    print("\nWrong Predictions:")

    for instruction, actual_category, predicted_category, actual_intent, normal_intent, oracle_intent, confidence, top3 in zip(
        X_manual,
        y_category,
        predicted_categories,
        y_intent,
        normal_predictions,
        oracle_predictions,
        normal_confidences,
        normal_top3
    ):

        if normal_intent != actual_intent:

            print(f"\nInstruction: {instruction}")
            print(f"Actual Category: {actual_category}")
            print(f"Predicted Category: {predicted_category}")
            print(f"Actual Intent: {actual_intent}")
            print(f"Normal Intent: {normal_intent}")
            print(f"Oracle Intent: {oracle_intent}")
            print(f"Intent Confidence: {confidence:.3f}")

            print("Top 3 Intent Predictions:")

            for intent, probability in top3:
                print(
                    f"  {intent}: {probability:.3f}"
                )



def train_model():
    print("\nLoading data...")

    train_df = pd.read_csv(TRAIN_FILE)
    test_df = pd.read_csv(TEST_FILE)

    print("\nTraining Rows:", len(train_df))
    print("Test Rows:", len(test_df))

    category_model = train_category_model(train_df)
    intent_model = train_intent_model(train_df)
    evaluate_model(category_model, intent_model, test_df)
    manual_test(category_model, intent_model, train_df)

    MODEL_DIR = BASE_DIR / "ml" / "models"
    MODEL_DIR.mkdir(parents=True, exist_ok=True)

    joblib.dump(category_model, MODEL_DIR / "category_model.pkl")
    joblib.dump(intent_model, MODEL_DIR / "intent_model.pkl")

    print("\nModels saved successfully.")

if __name__ == "__main__":
    train_model()