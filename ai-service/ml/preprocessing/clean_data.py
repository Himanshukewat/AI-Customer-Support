import pandas as pd

input_file = "ml/data/Customer_support_data.csv"
output_file = "ml/data/cleaned_customer_support_data.csv"

min_samples = 50


def clean_data():
    # Load the data
    df = pd.read_csv(input_file)

    print("Original row count:", len(df))

    # Remove rows missing required fields
    df = df.dropna(subset=["Customer Remarks", "Sub-category"])

    # Remove leading/trailing spaces
    df["Customer Remarks"] = df["Customer Remarks"].str.strip()

    # Count samples for each sub-category
    subcategory_counts = df["Sub-category"].value_counts()

    # Keep only sub-categories with at least 50 samples
    valid_subcategories = subcategory_counts[
        subcategory_counts >= min_samples
    ].index

    # Filter DataFrame
    df = df[df["Sub-category"].isin(valid_subcategories)]

    # Remove exact duplicate rows
    df = df.drop_duplicates()

    # Save cleaned dataset
    df.to_csv(output_file, index=False)

    print("Cleaned rows:", len(df))
    print("Sub-categories:", df["Sub-category"].nunique())

    print("\nSub-category distribution:")
    print(df["Sub-category"].value_counts())


if __name__ == "__main__":
    clean_data()