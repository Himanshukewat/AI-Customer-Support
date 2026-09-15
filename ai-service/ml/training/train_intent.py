import pandas as pd
from pathlib import Path

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import classification_report, accuracy_score


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


    print("\nTraining model...")
    model.fit(X_train, y_train)
    print("training complete.")

    predictions = model.predict(X_test)

    accuracy = accuracy_score(y_test, predictions)

    print("\naccuracy:", accuracy)

    print("\nClassification report:")
    print(classification_report(y_test, predictions))

if __name__ == "__main__":
    train_model()