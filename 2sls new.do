******************
* Nikhil Kumar
* EC 508
* Mid-term Exam
* Question 4
*****************

clear all

cd "C:\Users\nikhi\Documents\BU_Sem_2\EC 508\Mid Term 2"

use mroz.dta

reg educ age exper kidslt6 kidsge6 motheduc fatheduc if inlf==1
// regress bad regressor on good regressors and new instruments

predict educhat // store the predicted value of the coeff. on educ

predict educresid, resid
// store the predicted errors

reg lwage age exper kidsge6 kidslt6 educhat // 2SLS specification
est store b_2sls

reg lwage age exper kidsge6 kidslt6 educ educresid // New specification
est store b_new

est table b_2sls b_new
// the coefficients on age, exper, kidslt6, kidsge6, educ(or educhat) 
// in the new method are exactly the same as in the 2SLS estimates.

