import pandas as pd
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parents[2]

INPUT_FILE = BASE_DIR / "ml" / "data" / "bitext_customer_support.csv"
OUTPUT_FILE = BASE_DIR / "ml" / "data" / "cleaned_customer_support.csv"


def prepare_data():
    print("Loading dataset...")
    df = pd.read_csv(INPUT_FILE)    

    print("Original rows:", len(df))

    # Keep only columns needed for our ML pipeline
    df = df[["instruction", "category", "intent", "response"]]

    # Remove missing values
    df = df.dropna(subset=["instruction", "category", "intent"])

    # clean text whitespace
    df["instruction"] = (
        df["instruction"]
        .astype(str)
        .str.strip()
    )

    # Remove exact duplicate rows
    df = df.drop_duplicates()

    # Save cleaned dataset
    df.to_csv(OUTPUT_FILE, index=False)

    print("Cleaned rows:", len(df))
    print("Categories:", df["category"].nunique())
    print("Intents:", df["intent"].nunique())
    print("Saved to:", OUTPUT_FILE)

if __name__ == "__main__":
    prepare_data()