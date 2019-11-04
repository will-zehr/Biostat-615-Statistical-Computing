args<-commandArgs(trailingOnly=TRUE)
#args<-c('nn_test2.csv',14)
data=read.csv(args[1])
p=as.numeric(args[2])
n<-length(data)

relu=function(alpha, x_i){
  relu_vals=alpha[(p+2):(2*p+1)]+alpha[(2*p+2):(3*p+1)]*x_i
  relu_vals[relu_vals<0]=0
  relu_vals=alpha[2:(p+1)]*relu_vals
  return(sum(relu_vals))
}
obj_function<-function(alpha,x=data[,1],y=data[,2]){
  running=0
  n=length(x)
  for (i in 1:n){
    #r=0
  #   for(j in 2:(p+1)){
  #     r=r+alpha[j]*max(0,alpha[p+j]+alpha[2*p+j]*x[i])
  #   }
  #running=running+(y[i]-alpha[1]-r)^2
  #relu=alpha[(p+2):(2*p+1)]+alpha[(2*p+2):(3*p+1)]*x[i]
  #relu[relu<=0]=0L
  #running=running+(y[i]-alpha[1]-sum(relu))^2
  running=running+(y[i]-alpha[1]-relu(alpha,x[i]))^2
  }
  running/n
  #apply(data,1, function (x){(1/n)*sum(x[2]-alpha[1]-alpha[(p+2):(2*p+1)]+alpha[(2*p+2):(3*p+1)]*x[2])^2})
}





# obj_function<-function(alpha,x=data[,1],y=data[,2]){
#   running=0
#   n=length(x)
#   for (i in 1:n){
#     r=0
#     for(j in 2:p){
#       r=r+alpha[j]*max(0,alpha[p+j]+alpha[2*p+j]*x[i])
#     }
#     running=running+(y[i]-alpha[1]-r)^2
#   }
#   running/n
# }



Nelder.Mead <- function(f, x0, tol = 1e-5, max_iter = 8000){
  #dimension of the simplex
  f_evals<-0
  d <- length(x0)
  
  #set d+1 simplex points
  X <- matrix(x0,nrow=d,ncol=d+1)
  #create a simplex 
  X[,-(d+1)] <- X[,-(d+1)] + diag(d)
  
  #evaluate function
  Y <- apply(X,2,f)
  f_evals<-f_evals+ncol(X) #maybe this should be 1
  
  idx_max <- NULL; idx_min <- NULL; idx_2ndmax <- NULL
  mid_point <- NULL; tru_line <- NULL
  
  #Update the extremes 
  update.extremes <- function(){
    if(Y[1] > Y[2]){
      idx_max <<- 1; idx_min <<- 2; idx_2ndmax <<- 2
    } else{
      idx_max <<- 2; idx_2ndmax <<- 1; idx_min <<- 1
    }
    if(d>1){
      for(i in 3:(d+1)){
        if(Y[i] <= Y[idx_min]){
          idx_min <<- i
        } else if(Y[i] > Y[idx_max]){
          idx_2ndmax <<- idx_max; idx_max <<- i
        } else if(Y[i] > Y[idx_2ndmax]){
          idx_2ndmax <<- i
        }
      } 
    }
  }
  
  
  #Update the mid-point and the tru-line 
  update.mid.point <- function(){
    mid_point <<- apply(X[,-idx_max,drop=FALSE],1,mean)
    tru_line <<- X[,idx_max] - mid_point
  }
  
  #Update the next point
  update.next.point <- function(step_scale){
    
    next_point <- mid_point + tru_line*step_scale
    Y_next <- f(next_point)
    f_evals<<-f_evals+1
    if(Y_next < Y[idx_max]){
      X[,idx_max] <<- next_point
      Y[idx_max] <<- Y_next
      return(TRUE)
    } else{
      return(FALSE)
    }
  }
  
  #contract simplex
  contract.simplex <- function(){
    X[,-idx_min] <<- 0.5*(X[,-idx_min] + X[,idx_min])
    Y <<- apply(X,2,f)
    f_evals<<-f_evals+nrow(X)
  }
  
  convergence = 1
  #the whole procedure
  for(iter in 1:max_iter){
    update.extremes()
    #determine the direction for update
    update.mid.point()
    if(abs(Y[idx_max]-Y[idx_min]) <= tol*(abs(Y[idx_max])  + abs(Y[idx_min]))){
      convergence = 0
      break
    }
    #Refelection 
    update.next.point(-1.0)
    if(Y[idx_max] < Y[idx_min]){
      #Expansion
      update.next.point(-2.0)
    } else if(Y[idx_max] >= Y[idx_2ndmax]){
      #One direction contraction
      if(!update.next.point(0.5)){
        #all contraction
        contract.simplex()
      }
    }
  }
  
  #cat(formatC(Y[idx_min],digits=5,flag="-"),'\n',f_evals)
  #return(list(xmin=X[,idx_min],fmin=Y[idx_min],convergence=convergence,iter=iter, evals=f_evals))
  return(list(fmin=Y[idx_min],evals=f_evals))
}

results=Nelder.Mead(obj_function,x0=rep(0,3*p+1))
cat(formatC(results$fmin, digits=5), '\n', results$evals,sep='')
