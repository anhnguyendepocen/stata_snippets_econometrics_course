****************
* Nikhil Kumar
* EC 508
* Problem Set 3
* Question 10
****************

/* Write a program that given a user-chosen square, symmetric, positive definite matrix
A will extract its square root and place it in a user-named matrix (say B) such that
BB = A). Your program should check whether the matrix is square and symmetric and
positive definite and will warn the user if the given matrix fails these criteria. */

clear all

capture program drop MatSqrt
program define MatSqrt
args A B

tempname X
tempname Y
tempname L
tempname lambda 
tempname D

mat `X'=`A'

local sq = rowsof(`X') == colsof(`X') //1 if square, 0 otherwise 
local sym = issymmetric(`X') // 1 if symmetric, 0 otherwise
local l = rowsof(`X')
local flag=1 // becomes 0 if not positive semi-definite

if(`sq'==0){
	mat `B' = `A'
	di "Matrix is not a square matrix"
	}
	else{
		
		// matrix is a square matrix
		if(`sym'==0){
			
			mat `B' = `A'
			di "Matrix is a square matrix but not a symmetric matrix"
			}
		}
if(`sym'==1){			
	// matrix is a symmetric matrix
		mat symeigen `Y' `L' = `A'
		mat `lambda' = `L'
		local i = 1
		while(`flag'==1 & `i'<=`l'){

			if `L'[1,`i']<=0{
				// if any eigenvalue is negative
				local flag =  0 
				mat `B' = `A'
				di "Matrix is square and symmetric but not positive definite"
				}
				else{
					
					mat `lambda'[1,`i'] = sqrt(`L'[1,`i'])
				}
					local i = `i' + 1
			}
				if(`flag'==1){
					di "Matrix is square and symmetric and positive definite"
					mat `D' = diag(`lambda')
					mat `B' = `Y' * `D' * `Y''
					matlist `B', title("B matrix")
				}
			}
end

* sample matrices for verification
mat A = (1,2,3)
MatSqrt A B

mat A = (1,2\2,1)
MatSqrt A B

mat A = (2,-1,0\-1,2,-1\0,-1,2)
MatSqrt A B
