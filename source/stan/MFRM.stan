data{
  int <lower=0> J; // number of essays
  int <lower=0> R; // number of raters
  int <lower=2> K; // number of score categories
  int <lower=0> N; // number of samples
  int <lower=1, upper=J> EssayID [N];
  int <lower=1, upper=R> RaterID [N];
  int <lower=1, upper=K> X [N];
}
transformed data{
  vector[K] c = cumulative_sum(rep_vector(1, K)) - 1;
}
parameters {
  real theta[J];
  vector[R] beta_r;
  vector[K-2] beta_k;
}
transformed parameters{
  vector[K-1] category_est;
  vector[K] category_prm;
  category_est[1:(K-2)] = beta_k;
  category_est[K-1] = -1*sum(beta_k);
  category_prm = cumulative_sum(append_row(0, category_est));
}
model{
  theta ~ normal(0, 1);
  beta_r ~ normal(0, 1);
  category_est ~ normal(0, 1);
  for (n in 1:N){
    X[n] ~ categorical_logit(1.7 * ( c * (theta[EssayID[n]]- beta_r[RaterID[n]])-category_prm));
  }
}
generated quantities {
  vector[N] log_lik;
  int<lower=1, upper=K> X_tilde[N];
  for (n in 1:N){
    log_lik[n] = categorical_logit_log(X[n],1.7 * ( c * (theta[EssayID[n]] - beta_r[RaterID[n]]) -category_prm));
    X_tilde[n] = categorical_logit_rng(1.7 * ( c * (theta[EssayID[n]] - beta_r[RaterID[n]]) -category_prm));
  }
}
