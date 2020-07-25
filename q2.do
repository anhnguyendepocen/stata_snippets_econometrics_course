***********************
* Nikhil Kumar
* EC 508
* Problem Set 4
* Question 2
***********************

* (Solow's 1957 study)

clear all

use "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Problem Sets\PS4\TableF6-4.dta"

/* Solow claimed that a 'structural break' took place on 1943, making the 1943-49
observations fundamentally diifferent from previous years. Examine the residuals as
well as perform formal tests on each of the four models to verify this claim. */

// Generate transformed variables
gen q_a = q/a
gen lnk = ln(k)
gen rk = 1/k
gen nrk = -1/k 
gen lnq_a = ln(q_a)

// Model 1
// q/A = alpha + beta.ln(k)
reg q_a lnk
scalar alpha1 = _b[_cons]
scalar beta1 = _b[lnk]
scalar rss_r1 = e(rss)

// Model 2
// q/A = alpha - beta/k
reg q_a nrk
scalar alpha2 = _b[_cons]
scalar beta2 = _b[nrk]
scalar rss_r2 = e(rss)

// Model 3
// ln(q/A) = alpha + beta.ln(k)
reg lnq_a lnk
scalar alpha3 = _b[_cons]
scalar beta3 = _b[lnk]
scalar rss_r3 = e(rss)

// Model 4
// ln(q/A) = alpha + beta/k
reg lnq_a rk
scalar alpha4 = _b[_cons]
scalar beta4 = _b[rk]
scalar rss_r4 = e(rss)

forvalues i = 1/4{
	di "Model `i': alpha = ", alpha`i', ", beta = ", beta`i'
}

// Part (a)

// Solow claimed that a 'structural break' took place on 1943, making the 1943-49
// and that observations fundamentally different from previous years.

// To test this, I run two regressions
// one for observations from 1909 to 1942
// another for observations from 1943-1949
// and collect the unrestricted RSS 
// by summing the RSS for individual regressions

// Model 1
// q/A = alpha + beta.ln(k)
reg q_a lnk in 1/34
scalar rss_u1 = e(rss)
reg q_a lnk in 35/l
scalar rss_u1 = rss_u1 + e(rss)

// Model 2
// q/A = alpha - beta/k
reg q_a nrk in 1/34
scalar rss_u2 = e(rss)
reg q_a nrk in 35/l
scalar rss_u2 = rss_u2 + e(rss)

// Model 3
// ln(q/A) = alpha + beta.ln(k)
reg lnq_a lnk in 1/34
scalar rss_u3 = e(rss)
reg lnq_a lnk in 35/l
scalar rss_u3 = rss_u3 + e(rss)

// Model 4
// ln(q/A) = alpha + beta/k
reg lnq_a rk in 1/34
scalar rss_u4 = e(rss)
reg lnq_a rk in 35/l
scalar rss_u4 = rss_u3 + e(rss)

// Now we construct a f-statistic for each model
// And find its p-value

// df of numerator is q = 4-2 = 2
// df of denominator is n-k = 41-4
forvalues i = 1/4{
	scalar f = ((rss_r`i' - rss_u`i')/2)/(rss_u`i'/37)
	di "Model `i': F = ", f, " and p value is ", Ftail(2,37,f) 
}

// We can observe that for all four models,
// the p value is close to 0
// Hence, the null hypothesis that the same model applies to both periods 1909-42 and 1943-49 
// Ho can be rejected at the 95% confidence level.

// Part (b)

/* Suppose you wanted to find if only 1943 was an unusual year. Test this hypothesis
for each of the four models. */

// Test if only 1943 was an unusual year.
// We have n2(=1) < k(=2)
// So, we perform the chow test

gen dummy = (year==1943) 
// the coefficient on this dummy will be the gamma from Chow Test

// Model 1
// q/A = alpha + beta.ln(k)
reg q_a lnk dummy
scalar rss_u1 = e(rss)

// Model 2
// q/A = alpha - beta/k
reg q_a nrk dummy 
scalar rss_u2 = e(rss)

// Model 3
// ln(q/A) = alpha + beta.ln(k)
reg lnq_a lnk dummy
scalar rss_u3 = e(rss)

// Model 4
// ln(q/A) = alpha + beta/k
reg lnq_a rk dummy 
scalar rss_u4 = e(rss)

// Now we construct a f-statistic for each model
// And find its p-value

// df of numerator is n2 = 1
// df of denominator is n1-k = 40-2 = 38

forvalues i = 1/4{
	scalar f = ((rss_r`i' - rss_u`i')/1)/(rss_u`i'/38)
	di "Model `i': F = ", f, " and p value is ", Ftail(1,38,f) 
}

// We can observe that for all four models,
// the p value is less than 0.05 
// Hence, the null hypothesis that the same model applies to both periods 1943 as to the rest of years 1909-49 
// Ho can be rejected at the 5% level.