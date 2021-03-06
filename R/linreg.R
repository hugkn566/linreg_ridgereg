#' Perform linear regression with OLS
#' 
#' @param formula An object of the class \code{\link[stats]{formula}}.
#' @param data A data set of the class \code{\link[base]{data.frame}}
#' @return The function returns the results of the linear regression as an object of class "linreg".
#' @examples 
#' linreg_obj <- linreg(Petal.Length~Species, datasets::iris)
#' @export

### linreg ###
linreg <- function(formula, data){
  
  # Checking if the arguments are correct
  stopifnot(class(formula)=="formula" & is.data.frame(data))
  
  # Setting up the matrices
  X <- stats::model.matrix(formula, data)
  y_name <- all.vars(formula, data)
  Y <- as.matrix(data[y_name[1]])
  
  # Regression coefficients
  beta_hat <- solve(t(X)%*%X) %*% t(X)%*%Y
  
  # The fitted values
  y_hat <- X%*%beta_hat
  
  # The Residuals
  e_hat <- Y-y_hat
  
  # The degrees of freedom
  df <- nrow(data) - ncol(X)
  
  # The residual variance
  sigma2_hat <- as.numeric((t(e_hat)%*%e_hat)/df)
  
  # The variance of the regression coefficients
  var_beta_hat <- sigma2_hat * (solve(t(X)%*%X))
  
  # The t-values for each coefficient
  t_beta <- beta_hat/(sqrt(diag(var_beta_hat)))
  
  p <- 2*stats::pt(q=abs(t_beta), df=df, lower.tail = FALSE)

  
  
  result <- list(formula= formula,
                 data_name= deparse(substitute(data)),
                 y_name = as.character(formula[2]),
                 x_names = as.character(formula[3]),
                 beta_hat=beta_hat,
                 y_hat=y_hat,
                 e_hat=e_hat,
                 df=df,
                 sigma2_hat=sigma2_hat,
                 var_beta_hat=var_beta_hat,
                 t_beta=t_beta,
                 p=p)
  class(result) <- "linreg"
  return(result)
}

