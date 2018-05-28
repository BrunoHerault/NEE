Comparison of relationship between LE and VPD in both ecosystems with Bayesian estimates of the parameters following the theoretical equation between LE and VPD:
LE =𝐿 ∗𝑔𝑡𝑜𝑡 ∗𝑉𝑃𝐷/𝑃𝑎
Where L is the latent heat of vaporization that depend on air temperature (L ~ -0.0019T - 2.2366T + 2499.5 at ambient pressure)
And gtot is the total canopy conductance of the ecosystem (in mgH2O m-2 s-1)

``` r
dat<-read.table(file="DATA_STAN.txt", header = TRUE, sep = "", dec = ".")
datDAY<-dat[dat$Rg>5,]

datDAYLE<-datDAY[datDAY$LE>0,]
datDAYLE<-datDAYLE[is.na(datDAYLE$LE)==F,]
datDAYLE<-datDAYLE[is.na(datDAYLE$VPD)==F,]
datDAYLE<-datDAYLE[is.na(datDAYLE$Pa)==F,]
datDAYLE<-datDAYLE[is.na(datDAYLE$Tair)==F,]
datDAYLE<-datDAYLE[datDAYLE$Pa>0,]

L<- function (x){-0.0019*x^2 - 2.2366*x + 2499.5}

datStanLE<-list(N=nrow(datDAYLE), T=2, LE=datDAYLE$LE, VPD=datDAYLE$VPD, L=L(datDAYLE$Tair), Pa=datDAYLE$Pa, site=as.numeric(datDAYLE$site))

fitM2 <- stan(file = 'mich0_1.stan', data = datStanLE, iter = 1000, chains = 1)
fitM3 <- stan(file = 'mich1_1.stan', data = datStanLE, iter = 1000, chains = 1)

traceplot(fitM3)

``` 

![](Analyses_files/figure-markdown_github/TraceplotM1_LE-VPD.png)

``` r
summary(fitM3)$summary[,1]
     alpha[1]      alpha[2]         sigma          lp__ 
 1.099568e-02  9.996707e-03  9.999997e+00 -1.238005e+06 
```

**gtot is different in the two sites with a higher canopy conductance at Guyaflux (10.98-11.00) than at Nouraflux (9.98-10.00)
