import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

INPUT_FILE = BASE_DIR / "ml" / "data" / "augmented_examples.csv"
OUTPUT_FILE = BASE_DIR / "ml" / "data" / "augmented_examples_v2.csv"


TARGETED_EXAMPLES = [

    # ==========================================================
    # TRACK ORDER
    # ==========================================================

    ("where is my order", "ORDER", "track_order"),
    ("what is the status of my order", "ORDER", "track_order"),
    ("where is my package", "ORDER", "track_order"),
    ("can you track my package", "ORDER", "track_order"),
    ("where is my delivery", "ORDER", "track_order"),
    ("when will my order arrive", "ORDER", "track_order"),
    ("what is happening with my order", "ORDER", "track_order"),
    ("can you tell me where my order is", "ORDER", "track_order"),
    ("I want to track my package", "ORDER", "track_order"),
    ("what is the current status of my delivery", "ORDER", "track_order"),

    # ==========================================================
    # TRACK REFUND
    # ==========================================================

    ("where is my refund", "REFUND", "track_refund"),
    ("what is the status of my refund", "REFUND", "track_refund"),
    ("when will I receive my refund", "REFUND", "track_refund"),
    ("can you track my refund", "REFUND", "track_refund"),
    ("has my refund been processed", "REFUND", "track_refund"),
    ("I want to check my refund status", "REFUND", "track_refund"),
    ("where is my reimbursement", "REFUND", "track_refund"),
    ("what is happening with my refund", "REFUND", "track_refund"),
    ("when will my refund arrive", "REFUND", "track_refund"),
    ("can you tell me the status of my refund", "REFUND", "track_refund"),

    # ==========================================================
    # GET INVOICE
    # ==========================================================

    ("I need to download my invoice", "INVOICE", "get_invoice"),
    ("please send me my invoice", "INVOICE", "get_invoice"),
    ("can you send me a copy of my invoice", "INVOICE", "get_invoice"),
    ("I want to receive my bill", "INVOICE", "get_invoice"),
    ("please provide me with my invoice", "INVOICE", "get_invoice"),
    ("can you get me my invoice", "INVOICE", "get_invoice"),
    ("I need my invoice sent to me", "INVOICE", "get_invoice"),
    ("how can I download my bill", "INVOICE", "get_invoice"),
    ("please give me a copy of my bill", "INVOICE", "get_invoice"),
    ("I want to retrieve my invoice", "INVOICE", "get_invoice"),

    # ==========================================================
    # CHECK INVOICE
    # ==========================================================

    ("I want to see my invoice", "INVOICE", "check_invoice"),
    ("can I view my invoice", "INVOICE", "check_invoice"),
    ("I need to check my bill", "INVOICE", "check_invoice"),
    ("can I look at my invoice", "INVOICE", "check_invoice"),
    ("where can I see my bill", "INVOICE", "check_invoice"),
    ("I want to check my invoice", "INVOICE", "check_invoice"),
    ("can I view the details of my bill", "INVOICE", "check_invoice"),
    ("I need to look at my invoice", "INVOICE", "check_invoice"),
    ("show me my invoice", "INVOICE", "check_invoice"),
    ("where can I find my invoice", "INVOICE", "check_invoice"),

    # ==========================================================
    # CREATE ACCOUNT
    # ==========================================================

    ("I want to create an account", "ACCOUNT", "create_account"),
    ("how do I sign up", "ACCOUNT", "create_account"),
    ("I want to sign up", "ACCOUNT", "create_account"),
    ("how can I register", "ACCOUNT", "create_account"),
    ("help me create an account", "ACCOUNT", "create_account"),
    ("I need to open an account", "ACCOUNT", "create_account"),
    ("can I create a new account", "ACCOUNT", "create_account"),
    ("I want to register for an account", "ACCOUNT", "create_account"),
    ("how can I open an account", "ACCOUNT", "create_account"),
    ("please help me sign up", "ACCOUNT", "create_account"),

    # ==========================================================
    # REGISTRATION PROBLEMS
    # ==========================================================

    ("I can't sign up", "ACCOUNT", "registration_problems"),
    ("I'm having trouble signing up", "ACCOUNT", "registration_problems"),
    ("my registration isn't working", "ACCOUNT", "registration_problems"),
    ("I cannot register", "ACCOUNT", "registration_problems"),
    ("I'm having a problem with registration", "ACCOUNT", "registration_problems"),
    ("sign up is not working", "ACCOUNT", "registration_problems"),
    ("I can't create my account", "ACCOUNT", "registration_problems"),
    ("there is an error during registration", "ACCOUNT", "registration_problems"),
    ("I'm unable to sign up", "ACCOUNT", "registration_problems"),
    ("I'm having issues registering", "ACCOUNT", "registration_problems"),

    # ==========================================================
    # DELETE ACCOUNT
    # ==========================================================

    ("I want to delete my account", "ACCOUNT", "delete_account"),
    ("please close my account", "ACCOUNT", "delete_account"),
    ("I want to deactivate my account", "ACCOUNT", "delete_account"),
    ("how can I remove my account", "ACCOUNT", "delete_account"),
    ("I don't want my account anymore", "ACCOUNT", "delete_account"),
    ("please delete my account", "ACCOUNT", "delete_account"),
    ("I want to close my account", "ACCOUNT", "delete_account"),
    ("how do I deactivate my account", "ACCOUNT", "delete_account"),
    ("help me remove my account", "ACCOUNT", "delete_account"),
    ("I need to terminate my account", "ACCOUNT", "delete_account"),

    # ==========================================================
    # RECOVER PASSWORD
    # ==========================================================

    ("I forgot my password", "ACCOUNT", "recover_password"),
    ("I need to reset my password", "ACCOUNT", "recover_password"),
    ("I can't remember my password", "ACCOUNT", "recover_password"),
    ("how can I recover my password", "ACCOUNT", "recover_password"),
    ("I forgot my account PIN", "ACCOUNT", "recover_password"),
    ("help me reset my PIN", "ACCOUNT", "recover_password"),
    ("I lost my password", "ACCOUNT", "recover_password"),
    ("how do I change my password", "ACCOUNT", "recover_password"),
    ("I need to recover my account password", "ACCOUNT", "recover_password"),
    ("please help me restore my PIN", "ACCOUNT", "recover_password"),
]


def create_targeted_augmentation():

    print("Loading existing augmented examples...")

    df_existing = pd.read_csv(INPUT_FILE)

    print("Existing rows:", len(df_existing))

    df_targeted = pd.DataFrame(
        TARGETED_EXAMPLES,
        columns=["instruction", "category", "intent"]
    )

    print("Targeted rows:", len(df_targeted))

    combined_df = pd.concat(
        [df_existing, df_targeted],
        ignore_index=True
    )

    combined_df = combined_df.drop_duplicates(
        subset=["instruction"]
    ).reset_index(drop=True)

    print("Final rows:", len(combined_df))

    print("\nIntent counts:")
    print(combined_df["intent"].value_counts())

    combined_df.to_csv(
        OUTPUT_FILE,
        index=False
    )

    print("\nSaved to:")
    print(OUTPUT_FILE)


if __name__ == "__main__":
    create_targeted_augmentation()