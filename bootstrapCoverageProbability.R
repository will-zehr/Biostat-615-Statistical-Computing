args<-as.numeric(commandArgs(trailingOnly = T))
reps<-10000
sigma=args[1]
n=args[2]
alpha=1-args[3]
B=args[4]
c=sqrt(2/pi)

#simulate rayleigh distribution using uniform & inverse CDF approach
inv_cdf=function(x,scale) sqrt(-2*scale^2*log(1-x))
rayleigh_sim<-function(n, scale){
  data=runif(n,0,1)
  return(inv_cdf(data))
}

#Generate boostrap estimates
sigma_bootstrap=function(x) {
  data=rayleigh_sim(n=n,scale=sigma)
  sigma_est<-rep(NA, B)
  for(b in 1:B){
    idx <- sample(1:length(data),size=length(data),replace = TRUE)
    sigma_est[b] <- c*mean(data[idx])
  }
  CI <- quantile(sigma_est,prob=c(alpha/2,1-alpha/2))
  return(sigma>CI[1] & sigma<CI[2])}

CI_test<-rep(NA,reps)
CI_test<-sapply(CI_test, sigma_bootstrap)
cat(sprintf("%.1f\n",sum(CI_test)/length(CI_test)))
