library(rstan)
library(loo)
library(psych)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Set target IRT model
# >> options: GMFRM, MFRM, RMFRM (RMFRM means MFRM with RSS)
model_name <- "GMFRM"

# Prepare a function used below
get_category_prm <- function(category_prm, N, K){
  for(n in 1:N){
    prm = category_prm[((n-1)*(K-2)+1):((n-1)*(K-2)+(K-2))]
    prm = append(prm, -1*sum(prm))
    if(n == 1){
      mat = t(data.frame(prm))
    } else {
      mat = rbind(mat, t(data.frame(prm)))
    }
  }  
  return(mat)
}

# Run MCMC for data of focal and reference group, respectively. 
for(target in c("focal", "reference")){
  # Read Data
  data <- read.csv(paste("data//1_for_IRT/", target, "/data.csv", sep=""), header=TRUE)
  setting <- read.csv(paste("data/1_for_IRT/", target, "/setting.csv", sep=""), header=TRUE)
  data_stan <- list(N=nrow(data), J=setting$J, K=5, R=setting$R, EssayID=data$essay_id, RaterID=data$rater, X=data$score)
  
  # Run MCMC Estimation
  uni_stan <- stan_model(paste("stan/", model_name, ".stan", sep=""))
  fit <- sampling(uni_stan, data=data_stan, iter=5000, warmup=2000, chains=3)
  
  # Output Theta Estimates
  theta_est <- data.frame(theta = summary(fit, par="theta")$summary[, "mean"])
  row.names(theta_est) <- 1:length(theta_est[,1])
  write.csv(theta_est, paste("data/2_res_IRT/", target, "/theta.csv", sep=""))
  
  # Output Alpha Estimates only for GMFRM
  if(model_name == "GMFRM"){
    alpha_est <- data.frame(alpha_r = summary(fit, par="alpha_r")$summary[, "mean"])
    row.names(alpha_est) <- 1:length(alpha_est[,1])
    write.csv(alpha_est, paste("data/2_res_IRT/", target, "/alpha.csv", sep=""))
  }

  # Output Beta Estimates
  beta_est <- data.frame(beta_r = summary(fit, par="beta_r")$summary[, "mean"])
  row.names(beta_est) <- 1:length(beta_est[,1])
  write.csv(beta_est, paste("data/2_res_IRT/", target, "/beta.csv", sep=""))
  
  # Output Step Parameter Estimates
  if(model_name == "MFRM"){
    d_est <- t(data.frame(d = summary(fit, par="beta_k")$summary[, "mean"]))
    d_est <- cbind(d_est, -sum(d_est[1,]))
    colnames(d_est) <- paste("beta_", 2:data_stan$K, sep="")
  } else { # if RMFRM and GMFRM
    d_est <- summary(fit, par="beta_rk")$summary[, "mean"]
    d_est <- get_category_prm(d_est, data_stan$R, data_stan$K)
    row.names(d_est) <- 1:length(d_est[,1])
    colnames(d_est) <- paste("beta_r", 2:data_stan$K, sep="")
  }
  write.csv(d_est,paste("data/2_res_IRT/", target, "/d.csv", sep=""))
}
