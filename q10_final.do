****************
* Nikhil Kumar
* EC 508
* Problem Set 4
* Question 10
****************
clear all

/* Following the footsteps of Nerlove, Christensen and Greene (1976) estimated a
generalized Cobb-Douglas cost function for electricity supply using data from the 70's. 
They estimated the following cost function:
ln(C/Pf ) = alpha + beta * lnQ+ gamma/2 * (lnQ)^2 + delta_k * ln(Pk/Pf ) + delta_l * ln(Pl/Pf ) + u

Construct an estimate for the efficient scale of output from analysis of the data. 
Use the first 123 firms only to replicate the authors' original estimates.

Construct a 95% confidence interval of the efficient scale. What percentage of firms
in the data lie in this interval?
 */

use "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Problem Sets\PS4\TableF4-4.dta"

* B
// generate the transformed variables
gen lc_pf = ln(cost/pf)
gen lq = ln(q)
gen lq_2 = 0.5*lq^2
gen lpk_pf = ln(pk/pf)
gen lpl_pf = ln(pl/pf)

reg lc_pf lq lq_2 lpk_pf lpl_pf
scalar q = exp((1-_b[lq])/(_b[lq_2]))
scalar di q // Efficient output

scalar rss_r = e(rss) // restricted RSS

reg lc_pf lq lq_2 lpk_pf lpl_pf in 1/123
scalar rss_u = e(rss)

reg lc_pf lq lq_2 lpk_pf lpl_pf in 124/l
scalar rss_u = rss_u + e(rss) // unrestricted RSS from sum of RSS for the two independent regressions

// We generate a f-statistic and find its p value
// df of numerator = q = 10-5 = 5
// df of denominator = n-k = 158 - 10 = 148

scalar f = ((rss_r - rss_u)/5)/(rss_u/148) // f-statistic
di f 

di Ftail(5,148,f) // p-value of the f-statistic

// The p value is very high, 
// hence we cannot reject the null hypothesis Ho that,
// the same model applies to both the initial 123 firms 
// as the last 35 firms, 
// cannot be rejected both at 5% or 10% level

// So, it is advisable to replicate the author's estimates using just the first 123 firms. 
// Since there is no evidence of a structural change, it should not affect our estimates.

* c
qui reg lc_pf lq lq_2 lpk_pf lpl_pf
mat var=e(V)[1..2,1..2] // save the variance covariance matrix for beta and gama
scalar a = exp((1-_b[lq])/_b[lq_2])
scalar b = -1/_b[lq_2]
scalar c = -1*(1-_b[lq])/(_b[lq_2])^2
mat A = a*(b,c) // the jacobian matrix for delta method
mat var1 = A*var*A' // variance-covariance matrix for the efficient scale

scalar ll = a-1.96*(var1[1,1])^0.5 // lower limit
scalar ul = a+1.96*(var1[1,1])^0.5 // upper limit

di "The 95% confidence interval of the efficient ouput level is", ll, "to", ul