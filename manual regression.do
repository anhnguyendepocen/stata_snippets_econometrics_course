*************************
* Nikhil Kumar
* EC 508
* Problem Set 3
* Question 11
*************************

/* Create a mock dataset containing three variables y; x2; x3 with 100 observations (it does
not really matter what DGP you use to create the data). Create a do-file that will
prepare and exhibit a matrix that contains exactly the same output as in the bottom
table Stata displays if you issue the command \reg y x2 x3". (this is the table that gives
you the coeffcient values, p-values, confidence intervals etc.). Present evidence to show
that indeed both outputs are same. */

clear all
set obs 100
gen y = rnormal(5,1)

gen x1=1
gen x2 = rnormal(4,2)
gen x3 = rnormal(3,3)
reg y x2 x3

mkmat x2 x3 x1, mat(X)
mkmat y, mat(Y)
mat beta=inv(X'*X)*X'*Y
mat list beta

mat res=(I(100)-X*inv(X'*X)*X')*Y
mat list res

svmat res
qui sum res1
scalar var=r(sd)
mat var_b=var*inv(X'*X)
mat list var_b
mat sd_b=(sqrt(var_b[1,1])\sqrt(var_b[2,2])\ sqrt(var_b[3,3]))
mat list sd_b

mat t = (beta[1,1]/sd_b[1,1]\beta[2,1]/sd_b[2,1]\beta[3,1]/sd_b[3,1])
mat list t
scalar p1= 2*ttail(99,abs(t[1,1]))
scalar p2= 2*ttail(99,abs(t[2,1]))
scalar p3= 2*ttail(99,abs(t[3,1]))
mat p=(p1\p2\p3)
mat list p

scalar ts=invt(98,0.025)
mat ci= (beta+ts*sd_b,beta-ts*sd_b)
mat list ci 

mat reg_table=(beta, sd_b, t, p, ci)
mat rownames reg_table= x2 x3 _cons
mat colnames reg_table= Coef Std_Err t P>|t| 95%_Conf Interval
matlist reg_table, rowtitle(y)  cspec(o4& %12s | %8.0g & %8.0g & %8.0g & %8.0g & %8.0g & %8.0g o2&) rspec(--&&-)
reg y x2 x3
