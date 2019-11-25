# Biostat-615-Statistical-Computing
Code for class on algorithm design in R, with example runs

### Project 1: Constrained Polynomial Regression
[constrainedPolynomialRegression.R](./constrainedPolynomialRegression.R)

Wrote an R script to fit a polynomial regression model with *Y<sub>i</sub>=B<sub>0</sub>+B<sub>j</sub>X<sub>i</sub><sup>j</sup>+e<sub>i</sub>*. User inputs a number of parameters *p* and y values. Outputs beta coefficients.

```console
R --slave --args 3 0.5 1.0 1.5 < constrainedPolynomialRegression.R
0.10686514 1.20573206 0.60286603 0.20095534
```

### Project 2: Fast Ridge Regression
[fastRidgeRegression.R](./fastRidgeRegression.R)

For regularized linear regression, fit a ridge-penalized multiple linear regression, with a user-inputted lambda value and datasets X and Y. Outputs non-zero rounded beta coefficients.

```console
R --slave --args ./datasets/test1.X ./datasets/test1.Y 0.1 < fastRidgeRegression.R
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

```console
R --slave --args ./datasets/test1.csv 3 1.0 3 < kernelRidgeRegression.R
8.029
```

### Project 4: Nonlinear Logistic Regression
[nonlinearLogisticRegression.R](./nonlinearLogisticRegression.R)

Runs a nonlinear logistic regression with parameter *alpha*, which is in (-5,5) on a user-inputted dataset of 2 predictors (X and Z) and Y. Uses secant method to find the root of the score equation. Outputs estimated alpha.

```console
R --slave --args ./datasets/logit_test1.csv < nonlinearLogisticRegression.R
-1.7175
```

### Project 5: Neural Network Model
[neuralNetwork.R](./neuralNetwork.R)

Uses the Nelder-Mead algorithim to fit a one-layer neural network model on a user-inputted dataset of X & Y, with a user-inputted number of nodes *p*. Outputs minimum value of the objective function and the number of completed function evaluations.

```console
R --slave --args ./datasets/nn_test1.csv 10 < neuralNetwork.R
0.0089142
1865
```

### Project 6: Boostrap Confidence Interval Coverage Probability
[bootstrapCoverageProbability.R](./bootstrapCoverageProbability.R)

Evaluates the probability that a bootstrap estimate of a 1-alpha confidence interval will cover the true parameter in 1000 repeated simulations, using data from a rayleigh distribution. Input arguments are the true value of sigma, the data sample size, the confidence level alpha, and the bootstrap sample size B.

```R
R --slave --args 1.0 10 0.8 10 < bootstrapCoverageProbability.R
0.6
```
