****************************
* Nikhil Kumar
****************************

/* Obtain historical data on the two variables of interest (there are many sources for this
data; one example being the FRED database at St. Louis FED https://research.
stlouisfed.org) going as far back as possible. Assuming that a simple bivariate
regression model applies (which of course, for more than one reason is not a great
assumption to make), test whether MPC  is less than 1 (against the alternative
that it is not) at 5% significance level. */

clear all
// change directory here
cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\PS3"
use q5_keynes_consumption.dta

* a
reg consumption disp_income
predict e, resid

test _b[disp_income]=1, df(59) // performs the Wald test for null hypothesis
scalar s = sign(_b[disp_income]-1)
/*
 This is an F test with 1 numerator df and 59 denominator df
 . We know that t dist. is related to the F dist. in that the square of t dist with d df is equivalent to F dist with 1 numerator df and d denominator df
 If F test has 1 numerator df, the square root of the F statistic is the absolute value of the t statistic for the one-sided test
*/

// Ho: beta < 1
di ttail(r(df_r),s*sqrt(r(F)))
// We can see that the p-value of Ho is very high. Hence, we cannot reject the null hypothesis that MPC is less than 1

di 1-ttail(r(df_r), s*sqrt(r(F)))
// There is no level at which the above conclusion can be reversed

* b
// Ho: alpha > 0
test _b[_cons]=0, df(59)
scalar s = sign(_b[_cons])
di 1-ttail(r(df_r),s*sqrt(r(F)))
// We can see that the p-value of Ho is very small. Hence, we can reject the null hypothesis that the intercept is positive

*c
qui sum e, detail
di "Standard deviation of error term is ", r(sd)
di "95% Confidence Interval is of error term is "  r(mean)-1.96*r(sd), "to " r(mean)+1.96*r(sd)

* d
/* The OLS model is linear not because it is linear in the regressors 
but because it is linear in the parameters and the disturbance terms. 
The answers may still be valid because even if disposable incomes are not iid 
but the shocks are normal and iid, 
the residuals are independent of incomes. 
*/
