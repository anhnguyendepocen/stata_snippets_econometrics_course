******************
* Nikhil Kumar
* EC 508
* Mid-term Exam
* Question 1
*****************
/* for 500 iid observations on a lognormal-distributed random variable, create consistent estimates
of the sigma and mu parameters of the lognormal population from where the sample was
generated.Now create a 95% confidence interval for the mode of the generating distribution*/

clear all

cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\Mid Term 2\"
use Takehome.dta

* b
gen lx = ln(x)
hist lx, width(1)
qnorm lx 
// We see a normal distribution from both the histogram and the Q-Q plot

gen mu_n=.
gen sigma_n=.
forvalues i=1/500{
	qui sum lx in 1/`i'
	replace mu_n=r(mean) in `i' // stores sample mean for sample size i
	replace sigma_n = r(sd) in `i' // stores sample standard deviation for sample size i
}

sum mu_n 
scalar mu_hat = r(mean) // consistent estimate for mu

sum sigma_n
scalar sigma_hat = r(mean) // consistent estimate for sigma

di "consistent estimate of mu of the lognormal population from where the sample was generated is ", mu_hat

di "consistent estimate of sigma of the lognormal population from where the sample was generated is ", sigma_hat

* c

corr mu_n sigma_n, covariance // find the variance-covariance matrix for mu and sigma
mat A = (1, -2*sigma_hat) // the jacobian matrix for delta method
mat var1 = A*r(C)*A' // variance of the log(mode)

scalar m = mu_hat - sigma_hat^2 // log(mode)
scalar t = invttail(499,0.025) // t-statistic

scalar logll = m-t*(var1[1,1])^0.5 // lower limit of log(mode)
scalar logul = m+t*(var1[1,1])^0.5 // upper limit of mode

scalar ll = exp(logll) // lower limit of mode
scalar ul = exp(logul) // upper limit of mode

di "The 95% confidence interval of the mode of the generating distribution is", ll, "to", ul