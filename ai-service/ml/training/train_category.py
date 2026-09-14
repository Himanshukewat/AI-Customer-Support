import pandas as pd
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression


input_file = "ml/data/cleaned_customer_support_data.csv"

def load_data():
    # Load the cleaned data
    df = pd.read_csv(input_file)

    df = df.dropna(subset=["Customer Remarks", "Sub-category"]) #remove rows with missing values in the required columns

    df["Customer Remarks"] = df["Customer Remarks"].str.strip() #remove leading/trailing spaces

    X = df["Customer Remarks"]
    y = df["category"]  

    return X,y

def split_data(X, y):
    # Split the data into training and testing sets
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

    vectorizer = TfidfVectorizer(
    lowercase=True,  #lower case the text
    ngram_range=(1, 2),  #model both unigrams and bigrams of words
    min_df=2  # those words that appear in less than 2 documents will be ignored
    )

    X_train_tfidf = vectorizer.fit_transform(X_train)   # fit the vectorizer on the training data and transform it
    X_test_tfidf = vectorizer.transform(X_test)   # transform the test data using the fitted vectorizer

    print("Training TF-IDF shape:", X_train_tfidf.shape)
    print("Testing TF-IDF shape:", X_test_tfidf.shape)


    # Create the Logistic Regression model or classification model
    model = LogisticRegression(
        max_iter=1000 , # allow the model to iterate up to 1000 times to converge
        class_weight='balanced'  # handle class imbalance by adjusting weights inversely proportional to class frequencies 
    )

    # Train the model
    model.fit(X_train_tfidf, y_train)  # learning the X training data and the corresponding y training labels

    print("\nModel training completed!")

    # Make predictions on test data
    y_pred = model.predict(X_test_tfidf)

    # Evaluate the model
    accuracy = accuracy_score(y_test, y_pred)

    print("\nAccuracy:", accuracy)

    print("\nClassification Report:")
    print(classification_report(y_test, y_pred, zero_division=0))
