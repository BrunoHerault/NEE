data {
  int<lower=0> N;
  int<lower=0> T;
  real NEE[N]; 
  real Rg[N];
  int<lower=0, upper=T> site[N];
}

parameters {
  real<lower=0, upper=1> alpha;
  real<lower=0, upper=100> beta;
  real<lower=0, upper=100> gamma;
  real<lower=0.01, upper=10> sigma;
}

model{
  real mu[N];
  for (i in 1:N)
  {
    mu[i]=-(alpha*beta*Rg[i])/(alpha*Rg[i]+beta)+gamma;
  }
  NEE ~ normal(mu, sigma);
  alpha ~ gamma(0.01, 0.01);
  beta ~ gamma(0.01, 0.01);
  gamma ~ gamma(0.01, 0.01);
  sigma ~ gamma(0.01, 0.01);
}
