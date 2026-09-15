import pandas as pd
from pathlib import Path

from sklearn.compose import ColumnTransformer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder


# Define the base directory and input file path
BASE_DIR = Path(__file__).resolve().parents[2]
input_file = BASE_DIR / "ml" / "data" / "cleaned_customer_support_data.csv"


# def load_data():
#     df = pd.read_csv(input_file)

#     # remove rows with missing values in "Customer Remarks" or "category"
#     df = df.dropna(subset=["Customer Remarks", "category"])

#     df["Customer Remarks"] = (
#         df["Customer Remarks"]
#         .astype(str)
#         .str.strip()
#     )

#     df = df[df["Customer Remarks"] != ""]

#     X = df[["Customer Remarks", "channel_name"]]
#     y = df["category"]

#     return X, y

def load_data():
    df = pd.read_csv(input_file)

    df = df.dropna(subset=["Customer Remarks", "category"])

    df["Customer Remarks"] = (
        df["Customer Remarks"]
        .astype(str)
        .str.strip()
    )

    df = df[df["Customer Remarks"] != ""]

    # Find remarks that appear in 5 or more categories
    remark_category_count = (
        df.groupby("Customer Remarks")["category"]
        .nunique()
    )

    highly_ambiguous_remarks = remark_category_count[
        remark_category_count >= 5
    ].index

    print("Original rows:", len(df))
    print("Highly ambiguous remarks:", len(highly_ambiguous_remarks))

    # Temporary diagnostic filtering
    df = df[
        ~df["Customer Remarks"].isin(highly_ambiguous_remarks)
    ]

    print("Rows after removing highly ambiguous remarks:", len(df))

    X = df[["Customer Remarks", "channel_name"]]
    y = df["category"]

    return X, y


def split_data(X, y):
    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.2,
        random_state=42,
        stratify=y
    )

    return X_train, X_test, y_train, y_test


if __name__ == "__main__":
    X, y = load_data()
    X_train, X_test, y_train, y_test = split_data(X, y)
    preprocessor = ColumnTransformer(
        # transformers is a list of tuples, 
        # where each tuple contains the name of the transformer,
        # the transformer itself, and the columns to which it should be applied
        transformers=[
            (
                "text",
                TfidfVectorizer(
                    lowercase=True,
                    ngram_range=(1, 2),
                    min_df=2
                ),
                "Customer Remarks"
            ),
            (
                # one-hot encode the "channel_name" column
                "channel",
                OneHotEncoder(handle_unknown="ignore"),
                ["channel_name"]
            )
        ]
    )

# Create a pipeline that first applies the preprocessor and then fits a logistic regression model
    model = Pipeline(
        steps=[
            ("preprocessor", preprocessor),
            (
                "classifier",
                LogisticRegression(max_iter=1000)
            )
        ]
    )

    model.fit(X_train, y_train)
    print("Model training completed!")
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    print("\nAccuracy:", accuracy)
    print("\nClassification Report:")
    print(
        classification_report(
            y_test,
            y_pred,
            zero_division=0
        )
    )
    print("\nConfusion Matrix:")
    print(
        confusion_matrix(
            y_test,
            y_pred
        )
    )