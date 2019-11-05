# Biostat-615-Statistical-Computing
Code for class on algorithm design in R, with example runs

### Project 1: Constrained Polynomial Regression
[constrainedPolynomialRegression.R](./constrainedPolynomialRegression.R)

Wrote an R script to fit a polynomial regression model with *Y<sub>i</sub>=B<sub>0</sub>+B<sub>j</sub>X<sub>i</sub><sup>j</sup>+e<sub>i</sub>*. User inputs a number of parameters *p* and y values. Outputs beta coefficients.

```console
Rscript --slave --args 3 0.5 1.0 1.5 < constrainedPolynomialRegression.R
0.10686514 1.20573206 0.60286603 0.20095534
```

### Project 2: Fast Ridge Regression
[fastRidgeRegression.R](./fastRidgeRegression.R)

For regularized linear regression, fit a ridge-penalized multiple linear regression, with a user-inputted lambda value and datasets X and Y. Outputs non-zero beta coefficients.

```console
Rscript --slave --args test1.X test1.Y 0.1 < fastRidgeRegression.R
1 14
2 -10
3 2
4 -3
5 17
6 -2
7 -1
8 5
9 22
10 8
```

### Project 3: Kernel Ridge Regression
[kernelRidgeRegression.R](./kernelRidgeRegression.R)

Runs kernel ridge regression on user-specified X & Y training datasets, and evaluates choice of lambda using user-specified X & Y testing datasets. Outputs predictive mean squared errors.

### Project 4: Nonlinear Logistic Regression
[nonlinearLogisticRegression.R](./nonlinearLogisticRegression.R)

Runs a nonlinear logistic regression with parameter *alpha*, which is in (-5,5) on a user-inputted dataset of 2 predictors (X and Z) and Y. Uses secant method to find the root of the score equation. Outputs estimated alpha.

### Project 5: Neural Network Model
[neuralNetwork.R](./neuralNetwork.R)

Uses the Nelder-Mead algorithim to fit a one-layer neural network model on a user-inputted dataset of X & Y, with a user-inputted number of nodes *p*.
