******************
* Nikhil Kumar
* EC 508
* Mid-term Exam
* Question 3
*****************

/* In a seminal paper Nelson and Plosser (JME, 1982) argued that if a time-series
variable x is generated by the following so-called difference-stationary process:
then, regressing x on its lagged value and a constant and then performing a t-test 
at a 5% level to test whether the slope coefficient is one, will give us utterly 
misleading results. You will verify this claim.
*/

clear all
set seed 547698321

capture program drop myprog
program define myprog, rclass
syntax [, obs(integer 1)]

set obs `obs' 
// set number of observations as entered by user 

// generate temporary variables within the program
tempvar e
tempvar x
tempvar xl
tempvar obsnum

gen `e' = rnormal(0,1) // generate standard normal errors
gen `xl' = 0 // set the first lagged value to be zero
gen `x' =  `e' in 1 // set the first x-values to the  error term
forvalues i = 2/100{
    // generate the x values by difference stationary process
    replace `x' = `x'[`i'-1] + `e' in `i'
}

gen `obsnum' = _n
tsset `obsnum'
replace `xl' = l.`x' in 2/l
list `x' `xl'

reg `x' `xl'
scalar p = invttail(100,0.025) 
return scalar s= _b[`xl'] // return the coefficient on the lagged x

return scalar t= (_b[`xl']-1)/(r(table)[2,1]) 
// return the t-statistic for the test if slope-coeff. is 1

return scalar d= abs(return(t))>p // return the dummy variable

end

myprog, obs(100) // to check if the simulation works

// now run the simulation for 500 replications, each with 100 observations
simulate slope_coeff =r(s) t_stat=r(t) dummy=r(d), reps(500): myprog, obs(100)

sum // summarize all the variables generated

// The actual probability of rejection is close to 0.27 i.e. 27%,
// which is far from 5%