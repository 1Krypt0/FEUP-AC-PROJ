import pandas as pd
from math import ceil
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
from sklearn.model_selection import (
    GridSearchCV,
    TimeSeriesSplit,
    train_test_split,
)
from sklearn.ensemble import GradientBoostingClassifier, RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from imblearn.over_sampling import SMOTE


def evaluate_model(
    model, testing_inputs, testing_classes, output_cols, sample_weight=None
):
    """
    This helper function prints the report and evaluation metrics for the model.
    """
    predictions = model.predict(testing_inputs)

    print("=" * 70)
    print(f"Evaluation metrics for {model.__class__.__name__}")
    print("=" * 70)

    score = model.score(testing_inputs, testing_classes)
    print(f"{model.__class__.__name__}'s default score metric: {score}")

    print("Classification report")
    print(
        classification_report(
            testing_classes,
            predictions,
            target_names=output_cols,
            sample_weight=sample_weight,
            digits=4,
            zero_division=1,
        )
    )

    accuracy = accuracy_score(testing_classes, predictions, sample_weight=sample_weight)
    print(f"Accuracy: {accuracy:.4f}")

    cms = confusion_matrix(testing_classes, predictions, sample_weight=sample_weight)
    target_names = ["not accepted", "accepted"]
    annot = cms.flatten().reshape(2, 2)
    sns.heatmap(
        cms,
        annot=annot,
        fmt="",
        cmap="Blues",
        xticklabels=target_names,
        yticklabels=target_names,
    )
    plt.show()

    print("=" * 70)


# Read the dataset and split into label and others
x = pd.read_csv("data/dataframe.csv")
# Sort the entries by time
x.sort_values(by="loan_date", inplace=True)
y = x["status"]
x = x.drop(["status", "frequency", "loan_date"], axis=1)
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state=0)

# Apply SMOTE so that the classes get balanced
smote = SMOTE(random_state=2)
x_train_bal, y_train_bal = smote.fit_resample(x_train, y_train)

# Apply GridSearch to find out the best values for the model.
# For now the model will be a Decision Tree
SPLITTER = TimeSeriesSplit()


def apply(model, params):
    validator = GridSearchCV(
        estimator=model, param_grid=params, n_jobs=-1, cv=SPLITTER, verbose=2
    )

    # Fit the model into the training data
    validator.fit(x_train_bal, y_train_bal)

    # Now test and evaluate it with the testing data
    print(f"The best params for this validator are {validator.best_params_}")

    evaluate_model(validator, x_test, y_test, ["not accepted", "accepted"], None)


model = GradientBoostingClassifier()
# For the Decision Tree
# params = {
#     "criterion": ["gini", "entropy"],
#     "splitter": ["best", "random"],
#     "max_depth": range(1, 50),
#     "min_samples_split": range(2, 15),
#     "min_samples_leaf": range(1, 7),
# }

# For the Random Forest
# params = {
#     "n_estimators": range(5, 30),
#     "max_features": range(1, 8),
#     "max_depth": range(1, 15),
#     "criterion": ["gini", "entropy"],
# }
#
# For the Gradient Boost
params = {
    "max_features": range(7, 20, 2),
    "min_samples_split": range(1000, 2100, 200),
    "min_samples_leaf": range(30, 71, 10),
    "max_depth": range(5, 16, 2),
    "min_samples_split": range(200, 1001, 200),
}


apply(model, params)
