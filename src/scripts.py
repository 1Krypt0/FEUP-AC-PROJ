import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, classification_report
from sklearn.model_selection import TimeSeriesSplit
from imblearn.over_sampling import SMOTE


# Read the dataset and split into label and others
x = pd.read_csv("dataframe2.csv")
y = x["status"]
print(x.info())
x = x.drop(["status", "frequency"], axis=1)

# Apply SMOTE so that the -1 class gets balanced
smote = SMOTE(random_state=2)
x_train_bal, y_train_bal = smote.fit_resample(x, y.ravel())

# Sort the entries by time

tscv = TimeSeriesSplit()
for train_index, test_index in tscv.split(x_train_bal):
    pass

# Highlighted with shaders must have checkboxes to disable it

# x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state=0)
# print("Number of transactions X__train dataset: ", X__train.shape)
# print("Number of transactions y__train dataset: ", y__train.shape)
# print("Number of transactions X__test dataset: ", X__test.shape)
# print("Number of transactions y__test dataset: ", y__test.shape)
#
#
# # logistic regression object
# lrr = LogisticRegression()
# # train the model on train set
# lrr.fit(X__train, y__train.ravel())
# predictions = lrr.predict(X__test)
# # print classification report
# print(classification_report(y__test, predictions))
#
#
# print("Before Over Sampling, count of the label '1': {}".format(sum(y__train == 1)))
# print("Before Over Sampling, count of the label '0': {} \n".format(sum(y__train == 0)))
X__train_res, y__train_res = sm1.fit_resample(X__train, y__train.ravel())
print("After Over Sampling, the shape of the train_X: {}".format(X__train_res.shape))
print("After Over Sampling, the shape of the train_y: {} \n".format(y__train_res.shape))
print("After Over Sampling, count of the label '1': {}".format(sum(y__train_res == 1)))
print("After Over Sampling, count of the label '0': {}".format(sum(y__train_res == 0)))

from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score


clf = DecisionTreeClassifier(
    max_depth=4, criterion="entropy", max_features=0.6, splitter="best"
)
clf.fit(X__train_res, y__train_res)
predictions = clf.predict(X__test)

print(accuracy_score(y__test, predictions))
