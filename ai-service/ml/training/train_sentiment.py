import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
# for model are working and accurecy checking
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.svm import LinearSVC
import joblib

#load sentiment dataset
df = pd.read_csv("ml/data/sentiment_train.csv")

print("Dataset shape:", df.shape)
print(df.head())

# Input and target
X = df["ticket"]  #give a text to model
y = df["label"]   #model trains for correct answer

print("X samples:", len(X))
print("y samples:", len(y))

X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,    # testing data size
    random_state=42,  #so results, reproducible
    stratify=y   #maintain propation between train and test data 
)



print("Training samples:", len(X_train))
print("Testing samples:", len(X_test))



vectorizer = TfidfVectorizer(
    max_features=10000,
    ngram_range=(1, 2),
    sublinear_tf=True
)

# Yahan vectorizer training data se vocabulary/IDF learn karta hai.
X_train_tfidf = vectorizer.fit_transform(X_train)

# avoid data leakage
X_test_tfidf = vectorizer.transform(X_test)

print("Training TF-IDF shape:", X_train_tfidf.shape)
print("Testing TF-IDF shape:", X_test_tfidf.shape)


# Train with logisticRegression
model = LogisticRegression(
    max_iter=1000,
    random_state=42
)


model.fit(X_train_tfidf, y_train)
y_pred = model.predict(X_test_tfidf)

# evaluation
print("Accuracy:", accuracy_score(y_test, y_pred))
print(classification_report(y_test, y_pred))
print(confusion_matrix(y_test, y_pred))

#Save model in pkl 

joblib.dump(model, "ml/models/sentiment_model.pkl")
joblib.dump(vectorizer, "ml/models/sentiment_vectorizer.pkl")

print("Sentiment model saved successfully!")

# Predict on test data
y_pred = model.predict(X_test_tfidf)

# Accuracy
accuracy = accuracy_score(y_test, y_pred)

print("Accuracy:", accuracy)

# Detailed evaluation
print("\nClassification Report:")
print(
    classification_report(
        y_test,
        y_pred,
        target_names=[
            "Strong Negative",
            "Mild Negative",
            "Neutral",
            "Mild Positive",
            "Strong Positive"
        ]
    )
)

# Show misclassified test examples
results = pd.DataFrame({
    "ticket": X_test.values,
    "actual": y_test.values,
    "predicted": y_pred
})

label_names = {
    0: "Strong Negative",
    1: "Mild Negative",
    2: "Neutral",
    3: "Mild Positive",
    4: "Strong Positive"
}

misclassified = results[results["actual"] != results["predicted"]].copy()

misclassified["actual"] = misclassified["actual"].map(label_names)
misclassified["predicted"] = misclassified["predicted"].map(label_names)

print("\nMisclassified examples:")
print(misclassified.to_string(index=False))

# Confusion Matrix
print("\nConfusion Matrix:")
print(confusion_matrix(y_test, y_pred))