import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

INPUT_FILE = BASE_DIR / "ml" / "data" / "augmented_examples_v2.csv"
OUTPUT_FILE = BASE_DIR / "ml" / "data" / "augmented_examples_v3.csv"


TARGETED_EXAMPLES = [

    # ==========================================================
    # CHECK INVOICE
    # ==========================================================

    ("I want to review my bill", "INVOICE", "check_invoice"),
    ("I want to review the details of my invoice", "INVOICE", "check_invoice"),
    ("can I review my invoice", "INVOICE", "check_invoice"),
    ("I need to review my bill", "INVOICE", "check_invoice"),
    ("let me review my invoice", "INVOICE", "check_invoice"),
    ("I would like to see my invoice", "INVOICE", "check_invoice"),

    # ==========================================================
    # GET INVOICE
    # ==========================================================

    ("I need a copy of my bill", "INVOICE", "get_invoice"),
    ("please send me a copy of my bill", "INVOICE", "get_invoice"),
    ("I want you to send my invoice", "INVOICE", "get_invoice"),
    ("can you provide me with a copy of my bill", "INVOICE", "get_invoice"),
    ("please send my bill to me", "INVOICE", "get_invoice"),
    ("I need my invoice sent to me", "INVOICE", "get_invoice"),

    # ==========================================================
    # CREATE ACCOUNT
    # ==========================================================

    ("I want to sign up for an account", "ACCOUNT", "create_account"),
    ("I would like to sign up", "ACCOUNT", "create_account"),
    ("I need to sign up for an account", "ACCOUNT", "create_account"),
    ("can I sign up for an account", "ACCOUNT", "create_account"),
    ("I want to register for an account", "ACCOUNT", "create_account"),
    ("please help me register for an account", "ACCOUNT", "create_account"),
    ("I would like to create an account", "ACCOUNT", "create_account"),
    ("how can I register for an account", "ACCOUNT", "create_account"),

    # ==========================================================
    # REGISTRATION PROBLEMS
    # ==========================================================

    ("I can't sign up for an account", "ACCOUNT", "registration_problems"),
    ("I'm unable to sign up for an account", "ACCOUNT", "registration_problems"),
    ("I have a problem signing up", "ACCOUNT", "registration_problems"),
    ("something is wrong with my sign up", "ACCOUNT", "registration_problems"),
    ("I'm having trouble registering", "ACCOUNT", "registration_problems"),
    ("my sign up is not working", "ACCOUNT", "registration_problems"),
    ("I get an error when I try to sign up", "ACCOUNT", "registration_problems"),
    ("I cannot complete my registration", "ACCOUNT", "registration_problems"),

    # ==========================================================
    # DELETE ACCOUNT
    # ==========================================================

    ("I want to get rid of my account", "ACCOUNT", "delete_account"),
    ("I want to remove my account", "ACCOUNT", "delete_account"),
    ("I need to get rid of this account", "ACCOUNT", "delete_account"),
    ("please get rid of my account", "ACCOUNT", "delete_account"),
    ("I no longer want this account", "ACCOUNT", "delete_account"),
    ("I don't want to keep my account", "ACCOUNT", "delete_account"),
    ("I want my account removed", "ACCOUNT", "delete_account"),
    ("how can I get rid of my account", "ACCOUNT", "delete_account"),

    # ==========================================================
    # RECOVER PASSWORD
    # ==========================================================

    ("I need to get back into my account", "ACCOUNT", "recover_password"),
    ("I can't get back into my account", "ACCOUNT", "recover_password"),
    ("I can't access my account", "ACCOUNT", "recover_password"),
    ("I am unable to access my account", "ACCOUNT", "recover_password"),
    ("how can I regain access to my account", "ACCOUNT", "recover_password"),
    ("I need help getting back into my account", "ACCOUNT", "recover_password"),
    ("I lost access to my account", "ACCOUNT", "recover_password"),
    ("how do I regain access to my account", "ACCOUNT", "recover_password"),
]


def create_final_augmentation():

    print("Loading existing augmented examples...")

    existing_df = pd.read_csv(INPUT_FILE)

    print("Existing rows:", len(existing_df))

    targeted_df = pd.DataFrame(
        TARGETED_EXAMPLES,
        columns=["instruction", "category", "intent"]
    )

    print("New targeted rows:", len(targeted_df))

    combined_df = pd.concat(
        [existing_df, targeted_df],
        ignore_index=True
    )

    combined_df = combined_df.drop_duplicates(
        subset=["instruction"]
    ).reset_index(drop=True)

    print("Final rows:", len(combined_df))

    print("\nNew intent counts:")
    print(targeted_df["intent"].value_counts())

    combined_df.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print("\nSaved to:")
    print(OUTPUT_FILE)


if __name__ == "__main__":
    create_final_augmentation()