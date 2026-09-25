import pandas as pd

from sklearn.model_selection import train_test_split

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