args<-commandArgs(trailingOnly = TRUE)
#args<-'logit_test2.csv'
data<-read.csv(args)
#alpha is parameter of interest and is in (-5,5)
#max_iter=1000
#alpha=0
#data[,'Z']<-data[,'Z']^2
#log(P(y=1)/P(y=0))=aX+a^2*Z^2

guesses=matrix(seq(-5,5,by=10/11),ncol=2,byrow=T)

#p=1/(1+exp(-(alpha*X+alpha^2*Z^2)))
#need to develop a method to choose the two good initial values that close the true value.
#likelihood:
likelihood = function(alpha){
  a=alpha
  x=data[,'X']
  y=data[,'Y']
  z=data[,'Z']
  p=exp(a*x-a^2*z^2)
  p=p/(1+p)
  sum(y*log(p)+(1-y)*log(1-p))
}

#score: 
score = function(alpha){
  #n=nrow(data)
  a=alpha
  x=data[,'X']
  y=data[,'Y']
  z=data[,'Z']
  p=exp(a*x-a^2*z^2)
  p=p/(1+p)
  sum((y-p)*(x-2*a*z^2))
  sum(y*x)-2*a*sum(y*z^2)-sum(p*x)+2*a*sum(z^2*p)
}


secant <- function(f,x0,x1,tol=1e-10,max_iter=1000){
  convergence = 1
  f0 = f(x0); f1 = f(x1)
  if(abs(f0-f1)<tol){
    warning("Expect a huge jump!")
    break
  }
  x12 <- -f1/(f1-f0)*(x1-x0);  x2 <- x1 + x12
  for(iter in 1:max_iter){
    if(abs(x12)<tol){
      convergence = 0
      break
    }
    f0 <- f1; x1 <- x2; f1 <- f(x2); f01 <- f1 - f0
    if(abs(f01)<tol){
      warning("Expect a huge jump!")
      break
    }
    x12 <- -f1/f01*x12
    x2 <- x1 + x12
  }
  #return(list(root=x2,f_root = f(x2),iter=iter,convergence=convergence))
  return(c(x2,f(x2),iter,convergence))
}

#secant(score, x0=-5,x1=5)
#returns=matrix(apply(guesses,1, function(x) secant(score, x0=x[1], x1=x[2])),ncol=4,byrow=F)

returns=t(apply(guesses,1, function(x) secant(score, x0=x[1], x1=x[2])))
roots<-unique(returns[which(returns[,4]==0),1])
final=roots[which.max(sapply(roots,  function (x) likelihood(x)))]

#returns=returns[returns[,4]==0,]
#final=unique(returns[,1][returns[,2]==min(abs(returns[,2]))])
cat(formatC(final,digits=5))
