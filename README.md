# Biostat-615-Statistical-Computing
Code for class on algorithm design in R

### Project 1: Constrained Polynomial Regression
[constrainedPolynomialRegression.R](./constrainedPolynomialRegression.R)

Wrote an R script to fit a polynomial regression model with *Y<sub>i</sub>=B<sub>0</sub>+B<sub>j</sub>X<sub>i</sub><sup>j</sup>+e<sub>i</sub>*. User inputs a number of parameters *p* and y values. Outputs beta coefficients.

### Project 2: Fast Ridge Regression
[fastRidgeRegression.R](./fastRidgeRegression.R)

For regularized linear regression, fit a ridge-penalized multiple linear regression, with a user-inputted lambda value and datasets X and Y. Outputs non-zero beta coefficients.

### Project 3: Kernel Ridge Regression
[kernelRidgeRegression.R](./kernelRidgeRegression.R)

Runs kernel ridge regression on user-specified X & Y training datasets, and evaluates choice of lambda using user-specified X & Y testing datasets. Outputs predictive mean squared errors.

### Project 4: Nonlinear Logistic Regression
[nonlinearLogisticRegression.R](./nonlinearLogisticRegression.R)

Runs a nonlinear logistic regression with parameter *alpha*, which is in (-5,5) on a user-inputted dataset of 2 predictors (X and Z) and Y. Uses secant method to find the root of the score equation. Outputs estimated alpha.

### Project 5: Neural Network Model

