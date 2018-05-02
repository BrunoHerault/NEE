NEE versus Rg - Comparing Nouragues to Paracou
================
Bruno Hérault
5/2/2018

-   [Loading Data](#loading-data)
-   [The basic Michaelis-Menten model](#the-basic-michaelis-menten-model)
-   [Testing for a site effect on model parameters](#testing-for-a-site-effect-on-model-parameters)
-   [Predictions](#predictions)
-   [Conclusions](#conclusions)

We then compared the light response curve of NEE at the two sites. Empirical description of the measured NEE fluxes was performed with a non-linear least squares fit of the data to a hyperbolic light response model, also known as the Michaelis-Menten or rectangular hyperbola model (Owen et al., 2007). NEE = -(α*β*Rg)/(α\*Rg+β)+γ Where α is the initial slope of the curve and an approximation of the canopy light utilization efficiency, β is the maximum NEE of the canopy at light saturation, Rg is the global radiation and γ is an estimate of the average ecosystem respiration (Reco) occurring during the observation period.

Loading Data
============

``` r
library(ggplot2) 
data<-read.table(file="data.txt", header = TRUE, sep = "", dec = ".") 
ggplot(data, aes(Rg, NEE)) + geom_point() + geom_smooth() + facet_wrap(~site) 
```

    ## `geom_smooth()` using method = 'gam'

![](Analyses_files/figure-markdown_github/data-1.png)

The basic Michaelis-Menten model
================================

$$NEE =-\\frac{\\alpha \\times \\beta \\times Rg}{\\alpha \\times Rg + \\beta} + \\gamma $$

``` r
library(rstan)
```

    ## Loading required package: StanHeaders

    ## rstan (Version 2.17.3, GitRev: 2e1f913d3ca3)

    ## For execution on a local, multicore CPU with excess RAM we recommend calling
    ## options(mc.cores = parallel::detectCores()).
    ## To avoid recompilation of unchanged Stan programs, we recommend calling
    ## rstan_options(auto_write = TRUE)

``` r
load(file="mod0.Rdata")
traceplot(mod0, pars=c("alpha", "beta", "gamma", "sigma"), nrow=2)
```

![](Analyses_files/figure-markdown_github/basic%20plot-1.png)

``` r
plot(mod0)
```

    ## ci_level: 0.8 (80% intervals)

    ## outer_level: 0.95 (95% intervals)

![](Analyses_files/figure-markdown_github/basic%20plot-2.png)

``` r
# Model parameters
par<-summary(mod0)$summary[,1]
par
```

    ##         alpha          beta         gamma         sigma          lp__ 
    ##  1.357356e-01  4.628608e+01  9.454549e+00  9.964080e+00 -4.636418e+04

``` r
# plotting predictions
ggplot(data, aes(Rg, NEE)) + geom_point() + geom_smooth() +
    stat_function(fun = function(x) -(par[1]*par[2]*x/(par[1]*x+par[2]))+par[3], color="red")
```

    ## `geom_smooth()` using method = 'gam'

![](Analyses_files/figure-markdown_github/basic%20plot-3.png) The basic model fits well the data. no convergence problems. Good estimates of model parameters. No chain covariance.

Testing for a site effect on model parameters
=============================================

We first test on all parameters simultaneously. Let's see.

``` r
library(rstan)
load(file="mod1.Rdata")
traceplot(mod1, pars=c("alpha", "beta", "gamma", "sigma"), nrow=2)
```

![](Analyses_files/figure-markdown_github/all%20plot-1.png)

``` r
plot(mod1)
```

    ## ci_level: 0.8 (80% intervals)

    ## outer_level: 0.95 (95% intervals)

![](Analyses_files/figure-markdown_github/all%20plot-2.png)

``` r
# Model parameters
par<-summary(mod1)$summary[,1]
par
```

    ##      alpha[1]      alpha[2]       beta[1]       beta[2]      gamma[1] 
    ##  1.111553e-01  1.617042e-01  4.666792e+01  4.669262e+01  9.636282e+00 
    ##      gamma[2]         sigma          lp__ 
    ##  8.987885e+00  9.855074e+00 -4.606304e+04

From this model, it looks like

**alphas are different, with a lower canopy light utilisation efficiency (0.10-0.12) at Guyaflux than at Nouraflux (0.15-0.17)**

**betas are not different, with the maximum NEE of the canopy at light saturation similar between the two sites (45-49)**

**gammas are slightly different, with the average ecosystem respiration lower at Guyaflux (9.3-10.0) than at Nouraflux (8.6-9.4)**

Predictions
===========

Conclusions
===========
