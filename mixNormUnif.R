args<-commandArgs(trailingOnly = T)
x=scan(args)
a=min(x)
b=max(x)

pi_vec <- rep(1/2,length=2)
tol=1e-5
prob_mat <- matrix(NA,nrow=length(x),ncol=2)

log_lik = function(mu_vec){
  prob_mat[,1] <- log(pi_vec[1]+tol)+dnorm(x,mean=mu_vec,sd=1,log=TRUE)
  prob_mat[,2] <- log(pi_vec[2]+tol)+dunif(x,min=a,max=b,log=TRUE)
  max_log_prob <- apply(prob_mat,1,max)
  prob_mat <- exp(prob_mat - max_log_prob)
  sum_prob <- apply(prob_mat,1,sum)
  prob_mat <- prob_mat/sum_prob
  return(sum(max_log_prob + log(sum_prob)))
}

mus=seq(min(x),max(x))
log_liks=sapply(mus, log_lik)
mu_init=mus[which(log_liks==max(log_liks))]

normMixEm <- setRefClass("normMixEM",
                         fields=list(k = "integer",
                                     n = "integer",
                                     dat_vec = "vector",
                                     pi_vec = "vector",
                                     mu_vec = "vector",
                                     prob_mat = "matrix",
                                     loglik = "numeric",
                                     tol = "numeric"))

normMixEm$methods(initialize = function(input_dat,num_components){
  dat_vec <<- input_dat
  k <<- num_components
  n <<- length(dat_vec)
})

normMixEm$methods(init.paras = function(){
  tol <<- 1e-100
  pi_vec <<- rep(1.0/k,length=k)
  #mu_init <<- seq(min(x), max(x))
  mu_vec <<- mu_init
  #mus=seq(min(x), max(x))
  #find mu which maximizes likelihood
  prob_mat <<- matrix(NA,nrow=n,ncol=k)
  loglik <<- -Inf
})

normMixEm$methods(update.prob = function(){
  prob_mat[,1] <<- log(pi_vec[1]+tol)+dnorm(dat_vec,mean=mu_vec,sd=1,log=TRUE)
  prob_mat[,2] <<- log(pi_vec[2]+tol)+dunif(dat_vec,min=a,max=b,log=TRUE)
  max_log_prob <- apply(prob_mat,1,max)
  
  prob_mat <<- exp(prob_mat - max_log_prob)
  sum_prob <- apply(prob_mat,1,sum)
  prob_mat <<- prob_mat/sum_prob
  
  loglik <<- sum(max_log_prob + log(sum_prob))
})

normMixEm$methods(update.pi = function(){
  pi_vec <<- apply(prob_mat,2,mean)
})

normMixEm$methods(update.mu = function(){
  mu_vec <<- mean(dat_vec*prob_mat[,1])/(pi_vec[1]+tol)
})

normMixEm$methods(check.tol = function(fmax,fmin,ftol){
  delta = abs(fmax - fmin)
  accuracy = (abs(fmax) + abs(fmin))*ftol
  return(delta < (accuracy + tol))
})


normMixEm$methods(run.EM = function(max_iter=1000L,loglik_tol=1e-5){
  convergence = 1L
  init.paras()
  loglik_list = NULL
  for(iter in 1:max_iter){
    loglik0 <- loglik
    update.prob()
    update.pi()
    update.mu()
    loglik_list = c(loglik_list,loglik)
    if(check.tol(loglik0,loglik,loglik_tol)){
      convergence = 0
      break
    }
  }
  return(list(convergence=convergence,mu_vec=mu_vec,#sigma_vec=sigma_vec,
              pi_vec=pi_vec,iter=iter,loglik_list=loglik_list))
})


set.seed(1000)
EM <- normMixEm$new(input_dat = x, num_components = 2L)
res_EM <- EM$run.EM(loglik_tol=1e-5)
cat(round(res_EM$mu_vec))
