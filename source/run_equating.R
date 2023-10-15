# Set target IRT model
# >> options: GMFRM, MFRM, RMFRM (RMFRM means MFRM with RSS)
model_name = "GMFRM"

dat <- read.csv(paste("data/4_res_BERT_pred/focal/pred.csv", sep=""))

A <- sd(dat$theta) / sd(dat$theta_irt)
K <- mean(dat$theta) - A * mean(dat$theta_irt)
mu_bert_pred <- mean(dat$theta)
sigma_bert_pred <- sd(dat$theta)

est_theta <- read.csv(paste("data/2_res_IRT/focal/theta.csv", sep=""))[,2]
est_beta <- read.csv(paste("data/2_res_IRT/focal/beta.csv", sep=""))[,2]
est_d <- read.csv(paste("data/2_res_IRT/focal/d.csv", sep=""))[,2:5]
if(model_name == "GMFRM"){
  est_alpha <- read.csv(paste("data/2_res_IRT/focal/alpha.csv", sep=""))[,2]
}

linked_theta <- A * est_theta + K
linked_beta <- A * est_beta + K
linked_d <- A * est_d
if(model_name == "GMFRM"){
  linked_alpha <- est_alpha / A  
}

# Output Linked Param
write.csv(data.frame(linked_theta), paste("data/5_result/linked_focal_theta.csv", sep=""))
write.csv(data.frame(linked_beta), paste("data/5_result/linked_focal_beta.csv", sep=""))
write.csv(data.frame(linked_d),paste("data/5_result/linked_focal_d.csv", sep=""))
if(model_name == "GMFRM"){
  write.csv(data.frame(linked_alpha), paste("data/5_result/linked_focal_alpha.csv", sep=""))
}

write.csv(c(A=A, K=K, mu =mu_bert_pred, sigma=sigma_bert_pred), paste("data/5_result/linking_coef.csv", sep=""))
