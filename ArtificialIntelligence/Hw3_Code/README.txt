Here is the code submission for the 'Decision Tree Assignment'

1. The two main scripts are crossValidScript.m and randomForestScript.m

2. crossValidScript.m performs 10-fold cross validation on a single decision tree learned. The number of branches per node can be changed by altering the value of k in line number 5. randomForestScripts.m performs 10-fold cross validation on a random forest with numOfTrees number of decision trees. 

The values of numOfTrees can be altered at line number 4 and k can be changed at line number 8. 

3. In order to test the above with missing features, remove the commented out (messUpDataScript) lines on line number 4 in crossValidScript.m and line number 7 in randomForestScripts.m

