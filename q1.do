***********************
* Nikhil Kumar
* EC 508
* Problem Set 4
* Question 1
***********************
clear all

* replicating empirical analysis of Nerlove (1963)
use "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Problem Sets\PS4\Nerlove_data.dta"

* a
gen lc  = log( COSTS) //C
gen ly  = log( KWH) //Y
gen lp1 = log( PL) //P1
gen lp2 = log( PK) //P2
gen lp3 = log( PF) //P3

// Model A
// C-P3 = K + (1/r)* Y + (a1/r)*(P1-P3) + (a2/r)*(P2-P3) + V

gen c_p3  = lc-lp3
gen p1_p3 = lp1-lp3
gen p2_p3 = lp2-lp3

reg c_p3 ly p1_p3 p2_p3 //Reg I

di "elasticity of output with capital is " _b[p2_p3]/_b[ly]

// we can see that the elasticity of output
// with respect to capital is negative. This is unexpected
// That's what made Nerlove unhappy.

* b
mat m = e(b)
predict e, resid
scatter e ly || qfitci e ly, yline(0) // plot of residuals
// We can see that the pattern is similar to figure 1 in Nerlove paper

* c
scalar rss_r = e(rss)
scalar rss_u = 0

forvalues i = 0/4{
	
	local a = 1+29*`i'
	local b = 29*(`i'+1)
	
	qui reg c_p3 ly p1_p3 p2_p3 in `a'/`b' //Reg III series 
	// 5 separate regressions for each group
	scalar rss_u = rss_u + e(rss) // Unrestricted RSS
}


// we have 16 unique restrictions (q=16) and
// n = 145, k = 20, so n-k = 125
scalar f = ((rss_r-rss_u)/16)/(rss_u/125)
scalar di f
di Ftail(16,125,f)
// Since p-value is so small, we reject the null hypothesis 
// that all coefficients are same for all 5 subsamples

* d
// Generate new variables for log(kwh) for restricted regression
// where we coefficient on log(Y) is kept the same 
forvalues i = 1/5{
	
	local a = 1+29*(`i'-1)
	local b = 29*`i'
	
	gen newp1_p3`i' = 0
	replace newp1_p3`i'= p1_p3 in `a'/`b' 
	
	gen newp2_p3`i' = 0
	replace newp2_p3`i'= p2_p3 in `a'/`b'
	
	gen cons`i'= 0
	replace cons`i' = 1 in `a'/`b'
}

// Restricted regression
reg c_p3 ly newp1_p31 newp1_p32 newp1_p33 newp1_p34 newp1_p35 /// 
newp2_p31 newp2_p32 newp2_p33 newp2_p34 newp2_p35 ///
cons1 cons2 cons3 cons4, noc // Reg IV series
scalar rss_r1 = e(rss)

// we have 4 unique restrictions (q=4) and
// n = 145, k = 12, so n-k = 133 
scalar f1 = ((rss_r1-rss_u)/4)/(rss_u/133)
scalar di f1
di Ftail(4,133,f1)
// Since p-value is so small, we reject the null hypothesis 
// that coefficients on Y (reciprocal of returns to scale) 
// is same for all 5 subsamples. 

* e
gen ly2=ly^2

// Model C
// C-P3 = K + alpha*Y + beta*Y^2 + (a1/r)*(P1-P3) + (a2/r)*(P2-P3) + V
reg c_p3 ly ly2 p1_p3 p2_p3 // Reg VII

sum ly, detail
scalar median = r(p50) // use median to calculate r
scalar r= 1/(_b[ly]+median*_b[ly2])
di "The returns to scale for the firm producing the median output is ", r