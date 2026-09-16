import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

TRAIN_FILE = BASE_DIR / "ml" / "data" / "train.csv"
AUGMENTED_FILE = BASE_DIR / "ml" / "data" / "augmented_examples_v3.csv"
OUTPUT_FILE = BASE_DIR / "ml" / "data" / "train_augmented.csv"


def create_augmented_train():

    print("\nLoading original training data...")
    train_df = pd.read_csv(TRAIN_FILE)

    print("\nLoading augmented training data...")
    augmented_df = pd.read_csv(AUGMENTED_FILE)

    print("Augmented rows:", len(augmented_df))
    combined_df = pd.concat(
        [train_df,augmented_df],
        ignore_index=True
    )

    combined_df = combined_df.drop_duplicates(
        subset=["instruction"]
    )

    print("Final training rows:", len(combined_df))

    combined_df.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print("Saved to:", OUTPUT_FILE)

if __name__ == "__main__":
    create_augmented_train()