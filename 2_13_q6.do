***************************
* Nikhil Kumar
* EC 508
* Problem Set 2
* Q6
*******************
clear all
cd "C:\Users\nikhi\Documents\BU_Sem_2\EC 508\Problem Sets\PS2"
use "cork.dta"

* a
* generate a matrix from the dataset
mkmat North East South West, matrix(X)
mat list X

* find the means of the four variables using 'i' vector
mat idash=J(1,28,1)
mat list idash
mat mean=(1/28)*idash*X
mat list mean

sum North
sum East
sum South 
sum West

* We can see that the means are same as calculated

* b
* generate a deviation matrix D to find the variance-covariance matrix of the dataset
mat D=I(28)-(1/28)*J(28,28,1)
mat v=(1/27)*X'*D*X
mat list v

corr North East South West, covariance

* We can see that the variance are same as calculated

* c
* Check whether the four variables are jointly normally distributed
* perform Doornik-Hansen Test for joint normality of the 4 variables
mvtest norm North East South West 

* perform test for individual normality of variables
sktest North
sktest East
sktest South  
sktest West

* create qqplots to visually check normality of individual variables
qnorm North

qnorm East

qnorm South

qnorm West

* d
* Using the first 25 observations recompute the mean vector and the variance-covariance matrix of the 4 variables. 
* Now use the north and east values of the last three observations to predict the south and west values of the last 3 observations

* create a matrix of first 25 observations
mkmat North East South West in 1/25, matrix(X1)

* find its means for this truncated matrix
mat i=J(25,25,1)
mat mu=(1/25)*X1'*J(25,1,1)
mat list mu

* find its variance-covariance matrix for this truncated matrix
mat D1=I(25)-(1/25)*J(25,25,1)
mat v=(1/24)*X1'*D1*X1
mat list v

* generate the partitioned matrices of size 2 X 2 from the variance covariance matrix
mat v11=v[1..2,1..2]
mat list v11

mat v22=v[3..4,3..4]
mat list v22

mat v12=v[1..2,3..4]
mat list v12

mat v21=v[3..4,1..2]
mat list v21

* generate a matrix for the last 3 observation for the North and East variables
mkmat North East in 26/28, matrix(X1)
mat list X1
mat i=J(25,25,1)

* generate a 2 X 3 matrix containing the sample means for North and East respectively in different rows
mat mu2=(mu[1,1], mu[1,1], mu[1,1]\ mu[2,1], mu[2,1],mu[2,1])
mat list mu2

* generate a 2 X 3 matrix containing the sample means for South and West respectively in different rows
mat mu1=(mu[3,1], mu[3,1], mu[3,1]\ mu[4,1], mu[4,1],mu[4,1])
mat list mu1

* find the conditional expectation of x2 given x1
mat cond_x2=mu2+v21*(inv(v11))*(X1'-mu1)
mat list cond_x2 

* find the conditional covariance of x2 given x1
mat cond_cov=v22-v21*(inv(v11))*v12 
mat list cond_cov

* generate the t-statistic for 24 degrees of freedom at 95% confidence interval
scalar t= invt(24,0.95)

* now we need to find the standard deviation of the variables South and West using variances from v22
mat sd=(v22[1,1]^0.5, v22[2,2]^0.5)

* generate a 2 X 3 matrix containing the sample standard deviation of South and West in its rows respectively
mat vmat=(sd[1,1],sd[1,1],sd[1,1]\sd[1,2], sd[1,2], sd[1,2])

* generate the upper limit of 95% confidence interval
mat ci_upper=1/5*invt(24,0.95)*vmat+cond_x2
mat list ci_upper

* generate the lower limit of 95% confidence interval
mat ci_lower=-1/5*invt(24,0.95)*vmat+cond_x2
mat list ci_lower

mat CI_matrix=(cond_x2[1,1],ci_lower[1,1],ci_upper[1,1]\cond_x2[1,2],ci_lower[1,2],ci_upper[1,2]\cond_x2[1,3],ci_lower[1,3],ci_upper[1,3]\cond_x2[2,1],ci_lower[2,1],ci_upper[2,1]\cond_x2[2,2],ci_lower[2,2],ci_upper[2,2]\cond_x2[2,3],ci_lower[2,3],ci_upper[2,3])

mat rownames CI_matrix= South South South West West West
mat colnames CI_matrix= Expected CI_95_Lower CI_95_Upper
mat list CI_matrix
