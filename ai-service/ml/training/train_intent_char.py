import pandas as pd
from pathlib import Path

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix


BASE_DIR = Path(__file__).resolve().parents[2]

TRAIN_FILE = BASE_DIR / "ml" / "data" / "train.csv"
TEST_FILE = BASE_DIR / "ml" / "data" / "test.csv"

def train_model():
    print("Loading data...")

    train_df = pd.read_csv(TRAIN_FILE)
    test_df = pd.read_csv(TEST_FILE)

    X_train = train_df["instruction"]
    y_train = train_df["intent"]

    X_test = test_df["instruction"]
    y_test = test_df["intent"]

    print("Training rows:", len(X_train))
    print("Testing rows:", len(X_test))

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


    print("\nTraining model...")
    model.fit(X_train, y_train)
    print("training complete.")

    predictions = model.predict(X_test)

    accuracy = accuracy_score(y_test, predictions)

    print("\naccuracy:", accuracy)

    # Find misclassified examples
    results = test_df.copy()
    results["predicted_intent"] = predictions

    wrong_predictions = results[
        results["intent"] != results["predicted_intent"]
    ]

    print("\nMisclassified examples:", len(wrong_predictions))

    print("\nWrong Predictions:")
    wrong_pairs = (
        wrong_predictions
        .groupby(["intent", "predicted_intent"])
        .size()
        .sort_values(ascending=False)
    )

    for (actual, predicted), count in wrong_pairs.items():
        print(f"{actual} -> {predicted}: {count}")  

    print("\nClassification report:")
    print(classification_report(y_test, predictions))

    return model


def manual_test(model):
    manual_file = BASE_DIR / "ml" / "data" / "manual_test.csv"
    print("\nLoading Manual testing set...")
    manual_df = pd.read_csv(manual_file)

    X_manual = manual_df["instruction"]
    y_manual = manual_df["intent"]

    predictions = model.predict(X_manual)

    manual_df["predicted_intent"] = predictions

    accuracy = accuracy_score(y_manual, predictions)
    print(f"\nManual Test Accuracy: {accuracy}")

    print("\nManual Test Results:")

    for _, row in manual_df.iterrows():
        print(f"Instruction: {row['instruction']}")
        print(f"Actual Intent: {row['intent']}")
        print(f"Predicted Intent: {row['predicted_intent']}")

    print("\nClassification report:")
    print(classification_report(y_manual, predictions))


if __name__ == "__main__":
    model = train_model()
    manual_test(model)