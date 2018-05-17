data {
  int<lower=0> N;
  int<lower=0> T;
  real LE[N]; 
  real VPD[N];
  real L[N];
  real Pa[N];
  int<lower=0, upper=T> site[N];
}

parameters {
  real<lower=0, upper=1> alpha;
  real<lower=0.01, upper=10> sigma;
}

model{
  real mu[N];
  for (i in 1:N)
  {
    mu[i]=L[i]*alpha*(VPD[i]/Pa[i]);
  }
  LE ~ normal(mu, sigma);
  alpha ~ gamma(0.01, 0.01);

}
