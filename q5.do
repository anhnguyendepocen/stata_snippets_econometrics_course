****************
* Nikhil Kumar
* EC 508
* Problem Set 4
* Question 5
****************
clear all 

/* write a program that lets you choose a random element from
{1; 2; : : : ; n} where n is a positive integer. The program will take n as an input
argument and will store the output as a scalar in another argument. */

capture program drop rand_el
program define rand_el
args n s
	// program to chose a random integer between 0 and n
	
	// choose any decimal number between 0 and n
    local x = runiform(0,`n')
	// round the chosen number to the nearest integer
	scalar `s' = round(`x')
end

/* write a program that will select m integer entities out of n integer ones. It will
use n and m as arguments and will have as an output a variable with m observations
each one between 1 and n and without repetition, ensuring that each of the n integers
is equiprobably chosen. For example, if my program is called `chooseasample', upon
issuing the command `chooseasample 10 4', I might see the variable x listed with
observations 2, 5, 8 and 10. */

capture program drop choosesample
program define choosesample
args n m x
	// program to choose m random integers between 0 and n
	
	set obs `m' // to take m observations
	gen `x' = 0
	local i = 1
	while (`i' <= `m'){
		// The loop runs until i = m, after which it stops
		
		rand_el `n' s // returns a random integer between 0 and n
		local flag = 0 // takes 1 if repeated selection of integer, 0 otherwise
		forvalues j = 1/`i'{
			// loop to check if this integer has already been chosen previously
		    if(s == `x'[`j']){
			    local flag = 1 
				// changes to 1 if s was found in the previusly chosen integer list
			}
		}
		if(`flag' == 0 ){
			// if s is new, it is appended to the list of integers
			replace `x' = s in `i'
			// and value of i is increased by one
			local i = `i' + 1
		}
	}
end

// Examples
rand_el 10 x
di x

choosesample 100 8 y
list y