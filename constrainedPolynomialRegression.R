args <- as.numeric(commandArgs(trailingOnly = TRUE))
p=as.numeric(args[1])
y=args[2:length(args)]
n=length(y)
x=seq(1:n)/n

des2=vector('double',n)
for (i in 1:n){
  m=1
  q=0
  for (j in 1:p){
    m=x[i]*(1/j)*m
    q=q+m
  }
  des2[i]<-q
}
fastSimpleLinearRegression <- function(x, y) {
  #center x and y
  ybar<-mean(y)
  xbar<-mean(x)
  y <- y - ybar
  x <- x - xbar
  n <- length(y)
  stopifnot(length(x) == n)        # for error handling
  #corrected variance: divide by n-1
  s2y <- sum( y * y ) / ( n - 1 )  # \sigma_y^2
  s2x <- sum( x * x ) / ( n - 1 )  # \sigma_x^2
  sxy <- sum( x * y ) / ( n - 1 )  # \sigma_xy
  rxy <- sxy / sqrt( s2y * s2x )   # \rho_xy
  b <- rxy * sqrt( s2y / s2x )
  a <- ybar-b*xbar
  return(list( beta = b , alpha=a))
}
model<-fastSimpleLinearRegression(des2,y)
betavec<-vector('double',p+1)
betavec[1]<-model$alpha
betavec[2]<-model$beta
for (i in 3:(p+1)){
  betavec[i]=betavec[i-1]/(i-1)
}
cat(formatC(betavec,digits=8,flag="-"), fill=T,sep=' ')
