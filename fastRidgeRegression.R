args <- commandArgs(trailingOnly = TRUE)
xfile<-args[1]
yfile<-args[2]
lam=as.numeric(args[3])
sizeX<-readBin(xfile,integer(),  n = 2)
X<-readBin(xfile, numeric(),n=prod(sizeX)+2)[-1]
sizeY<-readBin(yfile,integer(),  n = 2)
Y<-readBin(yfile, double(),n=prod(sizeY)+2)[-1]
p=sizeX[2]
n=sizeX[1]
X<-matrix(X, nrow=n,ncol=p)
if(p<=n){
  tXX<-crossprod(X)+diag(lam,nrow=p,ncol=p)
  tXY<-crossprod(X,Y)
  R<-chol(tXX)
  z <- forwardsolve(R,tXY,upper.tri=TRUE,transpose=TRUE)
  soln=backsolve(R,z)
  }else{
    res_svd <- svd(X,LINPACK=FALSE)
    soln<-(res_svd$v)%*%solve(diag(res_svd$d)^2+diag(lam,nrow=n,ncol=n))%*%(diag(res_svd$d)%*%t(res_svd$u))%*%Y
}
soln<-cbind(seq(1:length(soln)),round(soln))
soln<-soln[which(soln[,2]!=0),]
write.table(format(soln, justify="right"),row.names=F, col.names=F, quote=F)
