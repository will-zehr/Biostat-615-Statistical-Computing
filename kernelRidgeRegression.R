library(Matrix)
library(stats)
args<-commandArgs(trailingOnly = T)
data<-read.csv(args[1])
lam=as.numeric(args[2])
p=as.numeric(args[3])
b=as.numeric(args[4])
n=length(data$x_train)

ij<-which(abs(outer(data$x_train,data$x_train,FUN='-'))<=b,arr.ind=T)
val<-vector('double',nrow(ij))
for (i in 1:nrow(ij)){val[i]=exp(-p*(data$x_train[ij[i,1]]-data$x_train[ij[i,2]])^2)}
k_check=sparseMatrix(i=ij[,1],j=ij[,2],x=val,dims=c(n,n))

sparse.lm = function(X,Y){
  tXX = crossprod(X)
  tXY <- crossprod(X,Y)
  R <- chol(tXX)
  z <- forwardsolve(R,tXY,upper.tri=TRUE,transpose=TRUE)
  return(backsolve(R,z))
}

beta_est <- sparse.lm(k_check+diag(lam,nrow=n,ncol=n),data$y_train)
ij<-which(abs(outer(data$x_test,data$x_train,FUN='-'))<=b,arr.ind=T)
val<-vector('double',nrow(ij))
for (i in 1:nrow(ij)){val[i]=exp(-p*(data$x_test[ij[i,1]]-data$x_train[ij[i,2]])^2)}
k_check=sparseMatrix(i=ij[,1],j=ij[,2],x=val,dims=c(n,n))

PMSE<-(1/n)*sum((data$y_test-k_check%*%beta_est)^2)

cat(formatC(PMSE,digits=4),fill=T)
