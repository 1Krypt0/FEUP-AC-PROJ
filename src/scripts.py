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
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import GradientBoostingClassifier, RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from imblearn.over_sampling import SMOTE


def evaluate_model(
    model, testing_inputs, testing_classes, output_cols, sample_weight=None
):
    """
    This helper function prints the report and evaluation metrics for the model.
    """
    predictions = model.predict_proba(testing_inputs)

    print("INPUTS", testing_inputs)
    print("PREDICTIONS", predictions)

    probabilities = [0 if x[0] < 0.000001 else x[0] for x in predictions]
    probabilities = ["{:f}".format(x) for x in probabilities]

    submit = pd.DataFrame()
    submit["Id"] = testing_inputs["loan_id"]
    submit["Predicted"] = probabilities

    submit.to_csv(
        f"{model.estimator.__class__.__name__}_result.csv", sep=",", index=False
    )

    print("=" * 70)
    print(f"Evaluation metrics for {model.__class__.__name__}")
    print("=" * 70)

    score = model.score(testing_inputs, testing_classes)
    print(f"{model.__class__.__name__}'s default score metric: {score}")

    print("Classification report")
    print(predictions)
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
    print(predictions)
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
test_x = pd.read_csv("dataframe.csv")
train_x = pd.read_csv("dataframe2.csv")

test_x.sort_values(by="loan_date", inplace=True)
train_x.sort_values(by="loan_date", inplace=True)

correlated_features = set()
correlation_matrix = train_x.corr()
for i in range(len(correlation_matrix.columns)):
    for j in range(i):
        if abs(correlation_matrix.iloc[i, j]) > 0.98:
            colname = correlation_matrix.columns[i]
            correlated_features.add(colname)
            
train_x.drop(columns=correlated_features, axis=1, inplace=True)
test_x.drop(columns=correlated_features, axis=1, inplace=True)

unwanted_features = ["status", "loan_date", "frequency"]

features = [x for x in list(train_x) if x not in unwanted_features]
target = "status"

X = train_x[features]
y = train_x[target]

X_test = test_x[features]
y_test = test_x[target]



X, X_test, y, y_test = train_test_split(X, y, test_size=0.2, random_state=0)

# Apply SMOTE so that the classes get balanced
smote = SMOTE(random_state=2)
x_train_bal, y_train_bal = smote.fit_resample(X, y)

# Apply GridSearch to find out the best values for the model.
# For now the model will be a Decision Tree

def test_export(model, test_df, file):
    test = test_df[features]

    confidences = model.predict_proba(test)[:,-1]

    confidences = [0 if x < 0.000001 else x for x in confidences]
    confidences = ["{:f}".format(x) for x in confidences]

    submit = pd.DataFrame()

    submit["Id"] = test_df["loan_id"]
    submit["Predicted"] = confidences

    submit.to_csv(file + ".csv", sep=",", index=False)
    
    return "Done exporting to: " + file + ".csv"
    
def evaluate(model, X_test, y_test):
    y_pred = model.predict_proba(X_test)
    
    # Area Under the Curve, the higher the better
    auc = metrics.roc_auc_score(y_test, y_pred[:,-1])
    print("AUC Score: ", auc)

    y_pred_normalized = np.argmax(model.predict_proba(X_test), axis=1)

    cm = metrics.confusion_matrix(y_test, y_pred_normalized)
    ax= plt.subplot()
    sns.heatmap(cm, annot=True, fmt='g', ax=ax);  #annot=True to annotate cells, ftm='g' to disable scientific notation

    # labels, title and ticks
    ax.set_xlabel('Predicted labels');ax.set_ylabel('True labels'); 
    ax.set_title('Confusion Matrix'); 
    ax.xaxis.set_ticklabels(['yes', 'no']); ax.yaxis.set_ticklabels(['yes', 'no']);
    
    return y_pred[:,-1]


def apply(X, y, model, params, cv=5):
    validator = GridSearchCV(
        estimator=model, param_grid=params, n_jobs=-1, cv=cv, verbose=1, refit=True
    )

    # Fit the model into the training data
    validator.fit(x_train_bal, y_train_bal)

    # Now test and evaluate it with the testing data
    print(f"The best params for this validator are {validator.best_params_}")

    evaluate_model(validator, X_test, y_test, ["not accepted", "accepted"], None)


SPLITTER = TimeSeriesSplit()
MODEL = GradientBoostingClassifier()
# For the Decision Tree

dtc = DecisionTreeClassifier()
params = {
    'criterion': ['gini', 'entropy'],
    'max_depth': range(1,20),
    'min_samples_split': range(2,10),
    'min_samples_leaf': range(1,6)
}

# For the Random Forest
# params = {
#     "n_estimators": range(5, 30),
#     "max_features": range(1, 8),
#     "max_depth": range(1, 15),
#     "criterion": ["gini", "entropy"],
# }
#
# For the Gradient Boost
# params = {
#     "max_features": range(7, 20, 2),
#     "min_samples_split": range(1000, 2100, 200),
#     "min_samples_leaf": range(30, 71, 10),
#     "max_depth": range(5, 16, 2),
#     "min_samples_split": range(200, 1001, 200),
# }
# For the KNN


apply(X, y, dtc, params, 5)
