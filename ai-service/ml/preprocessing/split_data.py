import pandas as pd 
from pathlib import Path
from sklearn.model_selection import train_test_split

BASE_DIR = Path(__file__).resolve().parents[2]

INPUT_FILE = BASE_DIR / "ml" / "data" / "cleaned_customer_support.csv"
TRAIN_FILE = BASE_DIR / "ml" / "data" / "train.csv"
TEST_FILE = BASE_DIR / "ml" / "data" / "test.csv"

def split_data():
    print("Loading cleaned dataset...")

    df = pd.read_csv(INPUT_FILE)

    print("Total rows:", len(df))

    #keep only unique instructions to avoid data leakage
    unique_df = df.drop_duplicates(subset = ["instruction"]).copy()

    print("Unique instructions:", len(unique_df))

    # Split the dataset into training and testing sets
    train_df, test_df = train_test_split(
        unique_df,
        test_size=0.2, 
        random_state=42,
        stratify=unique_df["intent"]
    )
    train_df.to_csv(TRAIN_FILE, index=False)
    test_df.to_csv(TEST_FILE, index=False)

    print("Training rows:", len(train_df))
    print("Testing rows:", len(test_df))
    print("Train percentage:", round(len(train_df) / len(unique_df) * 100, 2))
    print("Test percentage:", round(len(test_df) / len(unique_df) * 100, 2))

if __name__ == "__main__":
    split_data()