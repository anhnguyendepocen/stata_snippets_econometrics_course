****************
* Nikhil Kumar
* EC 508
* Problem Set 4
* Question 8
****************
clear all

/* illustrate the weak law of large numbers. Show that as sample
size increases, the sample mean tends to the population mean by drawing a graph of the
former against sample size. This exercise is not like illustrating the CLT where
we fixed a sample size and drew many samples of that size. Here, while we progressively
increase sample size, we do not discard the previous draws. In other words the 100
observations that are used to create the sample mean for 100 observations are still the
first 100 observations for the sample of size 500 that is used to create the sample mean
for 500 observations. 

Experiment with draws from three distributions: uniform, exponential and cauchy .*/

set seed 123456
set obs 10000

gen u = . // draw uniformly distributed random variables between 0 and 1

gen s_mean1=. // stores sample mean for each value of sample size
gen count=. // counts 

forvalues i=1/500 {
	// create 500 sample means
	replace u = uniform() in `i'/l // keep old observations while adding new ones in each iteration
	qui sum u in 1/`i' 
	replace s_mean1 = r(mean) in `i' //add the sample means for each sample size
	replace count = `i' in `i' // saves sample size for each sample mean
	}

gen true_meanu = 0.5
twoway line s_mean1 true_meanu count

gen e = .
gen s_mean2=. // stores sample mean for each value of sample size
forvalues i=1/500 {
	// create 500 sample means
	replace e = exp(-1*`i') in `i'/l // keep old observations while adding new ones in each iteration
	qui sum e in 1/`i' 
	replace s_mean2 = r(mean) in `i' //add the sample means for each sample size
	replace count = `i' in `i' // saves sample size for each sample mean
	}

gen true_meane = 0
twoway line s_mean2 true_meane count

gen c = .
gen s_mean3=. // stores sample mean for each value of sample size
forvalues i=1/500 {
	// create 500 sample means
	replace c =  rt(1) in `i'/l // keep old observations while adding new ones in each iteration
	qui sum c in 1/`i' 
	replace s_mean3 = r(mean) in `i' //add the sample means for each sample size
	replace count = `i' in `i' // saves sample size for each sample mean
	}

twoway line s_mean3 count

// We can see that the sample mean converges to population mean 
// in case of uniform as well exponential distribution. 
// However, we do not see this convergence for cauchy distribution.
