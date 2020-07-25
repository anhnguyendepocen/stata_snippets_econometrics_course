***************************
* Nikhil Kumar
* EC 508
* Problem Set 2
* Q8
*******************

clear all
cd "C:\Users\nikhi\Desktop\BU_Sem_2\EC 508\PS2"
use "prices_stock_q8.dta"

* uses monthly stock price data for last 12 months on stocks of facebook, tesla and google
* minimum variance protfolio distribution on an investment of 10000

* set a time variable
gen obnum=_n
tsset obnum

* generate monthly returns on stocks
gen ret_f=d.p_f/p_f
gen ret_t=d.p_t/p_t 
gen ret_g=d.p_g/p_g

* R is a column matrix which will contain average returns
mat R=[0\ 0\0]

* i is an iota matrix of 1's
mat i=[1\1\1]

sum ret_t  
mat R[1,1]=r(mean)

sum ret_g 
mat R[2,1]=r(mean)

sum ret_f
mat R[3,1]=r(mean)

mat list R

corr ret_f ret_t ret_g, covariance

* sig is the variance-covariance matrix of the returns on stocks
mat sig=r(C)
mat list sig

* W_bar is the total investment to be made
scalar W_bar=10000
scalar di W_bar

* R_bar contains the average return on the three assets
matrix R_bar=1/3*W_bar*i'*R
mat list R_bar

* matrices a, b and d have the terms which are used to get the Lagrangian multiplier
mat a=i'*inv(sig)*i
mat b=i'*inv(sig)*R
mat d=R'*inv(sig)*R

mat P=(a, b\b,d)
mat list P
mat P_inv=inv(P)
mat list P_inv

* matrix const is a matrix that yields the Langrangian multipliers
mat const=(-2)*P_inv*(W_bar\ R_bar[1,1])
mat list const

* matrix w contains the minimum variance protfolio distribution of the investment of 10000
mat w=-0.5*inv(sig)*(i*const[1,1]+R*const[2,1])
mat list w
