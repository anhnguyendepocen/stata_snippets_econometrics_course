******************
* Nikhil Kumar
* This code demonstrate an alternative the well-known Chow test for structural change
*****************
clear all

set obs 50 
// We create 50 observations to demonstate 
// an equivalence to the Chow test

// Here, in this model, we have 3 RHS variables plus a constant

gen x1 = rnormal(5,1)
gen x2 = rnormal(10,2)
gen x3 = rnormal(15,3)
gen c  = rnormal(20,4)
gen y  = c+ 2*x1 + 3*x2 + 4*x3 
// this gives the observation for LHS variable

// We create a structural change in the last two observations
replace y= 3*x1 + 4*x2 + 5*x3 in 49/50

// We have regime 1: observations 1-48 
// and regime 2: observations 49-50

// First we perform the Chow Test

reg y x1 x2 x3 // the restricted regression
scalar rss_rc=e(rss)

reg y x1 x2 x3 in 1/48 // the unrestricted regression
scalar rss_u=e(rss)

// numerator degrees of freedom = n2 = 2
// denominator degree of freedom = n1-k = 48-4 =44

scalar fc = ((rss_rc - rss_u)/2)/(rss_u/44)
// this creates the f-statistic for the Chow test

// Now we use the new method in Q. 2a

// we generate the yhat for the LHS variable of second regime
// using the coefficients from the regression on first regime
gen yhat = _b[_cons] + x1*_b[x1]+x2*_b[x2]+x3*_b[x3] in 49/50

gen d = y-yhat
// generates the difference of y and yhat for second regime

mkmat c x1 x2 x3 in 1/48, mat(X1) 
// matrix for the 1st regime observations of RHS variables

mkmat c x1 x2 x3 in 49/50, mat(X2)
// matrix for the 2nd regime observations of RHS variables

mkmat d in 49/50, mat(d)
// matrix for the d values for second regime

mat v = I(2) + X2*inv(X1'*X1 )* X2' 
// this gives the variance-covariance matrix 
// of the difference divided by sigma 

mat num = d'*inv(v)*d // stores the numerator of the f-statistic

// numerator degrees of freedom = n2 = 2
// denominator degree of freedom = n1-k = 48-4 =44

scalar fn = (num[1,1]/2)/(rss_u/44)
// this creates the f-statistic for the alternative test

di "Chow Test: F = ", fc, " and p value is ", Ftail(2,44,fc)
di "Alternate Test: F = ", fn, " and p value is ", Ftail(2,44,fn) 
// we can see that the two f-stats are the approximately the same
