import pandas as pd


INPUT_FILE = "ml/data/cleaned_customer_support_data.csv"
OUTPUT_FILE = "ml/data/unambiguous_customer_support_data.csv"


def create_unambiguous_data():
    df = pd.read_csv(INPUT_FILE)

    # Normalize customer remarks
    df["Customer Remarks"] = (
        df["Customer Remarks"]
        .astype(str)
        .str.strip()
        .str.lower()
    )

    # Find how many sub-categories each remark belongs to
    subcategory_counts = (
        df.groupby("Customer Remarks")["Sub-category"]
        .nunique()
    )

    # Keep only remarks that belong to exactly one sub-category
    df = df[
        df["Customer Remarks"].map(subcategory_counts) == 1
    ]

    # Remove exact duplicate rows
    df = df.drop_duplicates()

    # Save experimental dataset
    df.to_csv(OUTPUT_FILE, index=False)

    print("Original cleaned rows:", 28236)
    print("Unambiguous rows:", len(df))
    print("Removed rows:", 28236 - len(df))
    print(
        "Remaining percentage:",
        round(len(df) / 28236 * 100, 2),
        "%"
    )
    print("Sub-categories:", df["Sub-category"].nunique())


if __name__ == "__main__":
    create_unambiguous_data()