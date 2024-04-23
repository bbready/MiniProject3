//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] y;
  vector[N] hfa;
  
  int<lower=0> n_teams;
  int<lower=0, upper=n_teams> off_team_index[N];
  int<lower=0, upper=n_teams> def_team_index[N];
  
  vector[n_teams] off_team_prior_mean;
  vector[n_teams] def_team_prior_mean;
  
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> sigma;
  
  real hfa_beta;
  
  vector[n_teams] off_beta;//team effects (offense)
  vector[n_teams] def_beta;//team effects (defense)
  
}
transformed parameters{
  vector[N] mu;
  
  for(i in 1:N){
    mu[i] = hfa[i]*hfa_beta + off_beta[off_team_index[i]] + def_beta[def_team_index[i]];
  }
  
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  
  // priors for offense and defense
  off_beta ~ normal(off_team_prior_mean, 5);
  def_beta ~ normal(def_team_prior_mean, 5);
  
  sigma ~ gamma(10, 1);//prior on model variance has expectation of 10 and variance of 10
  
  y ~ normal(mu, sigma);
}

