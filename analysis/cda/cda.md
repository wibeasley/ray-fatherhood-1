# CDA of Scales

<!--  Set the working directory to the repository's base directory; this assumes the report is nested inside of three directories.-->


<!-- Set the report-wide options, and point to the external code file. -->


<!-- Load the sources.  Suppress the output when loading sources. -->


<!-- Load 'sourced' R files.  Suppress the output when loading packages. -->


<!-- Load any global functions and variables declared in the R file.  Suppress the output. -->


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. -->


<!-- Load the datasets. -->


<!-- Tweak the datasets. -->



# Summary

### Notes

### Unanswered questions


# Model (Motivation separated into two variables)


# Model (Motivation combined into one variable)

```
               npar                fmin               chisq                  df              pvalue      baseline.chisq 
              9.000               0.366             191.232               6.000               0.000             291.318 
        baseline.df     baseline.pvalue                 cfi                 tli                nnfi                 rfi 
             12.000               0.000               0.337              -0.326              -0.326               1.000 
                nfi                pnfi                 ifi                 rni                logl   unrestricted.logl 
              0.344               0.172               0.351               0.337           -1048.972            -953.356 
                aic                 bic              ntotal                bic2               rmsea      rmsea.ci.lower 
           2115.944            2148.024             261.000            2119.491               0.344               0.303 
     rmsea.ci.upper        rmsea.pvalue                 rmr          rmr_nomean                srmr        srmr_bentler 
              0.387               0.000               0.069               0.069               0.234               0.234 
srmr_bentler_nomean         srmr_bollen  srmr_bollen_nomean          srmr_mplus   srmr_mplus_nomean               cn_05 
              0.234               0.234               0.234               0.234               0.234              18.185 
              cn_01                 gfi                agfi                pgfi                 mfi                ecvi 
             23.945               0.847               0.465               0.242               0.701               0.802 
```

```
lavaan (0.5-20) converged normally after  18 iterations

  Number of observations                           261

  Estimator                                         ML
  Minimum Function Test Statistic              191.232
  Degrees of freedom                                 6
  P-value (Chi-square)                           0.000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)
  motivation ~                                        
    autonomy          0.013    0.110    0.116    0.907
    competency        0.027    0.069    0.393    0.694
    relatedness       0.310    0.089    3.486    0.000
  involvement ~                                       
    motivation        0.154    0.053    2.917    0.004
  satisfaction ~                                      
    motivation        0.175    0.064    2.753    0.006

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  involvement ~~                                      
    satisfaction      0.139    0.020    6.844    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    motivation        0.313    0.027   11.424    0.000
    involvement       0.245    0.021   11.424    0.000
    satisfaction      0.358    0.031   11.424    0.000
```

```
            lhs op          rhs est.std    se      z pvalue
1    motivation  ~     autonomy   0.008 0.066  0.116  0.907
2    motivation  ~   competency   0.028 0.071  0.393  0.694
3    motivation  ~  relatedness   0.252 0.070  3.602  0.000
4   involvement  ~   motivation   0.178 0.060  2.965  0.003
5  satisfaction  ~   motivation   0.168 0.060  2.792  0.005
6   involvement ~~ satisfaction   0.468 0.048  9.670  0.000
7    motivation ~~   motivation   0.927 0.030 30.425  0.000
8   involvement ~~  involvement   0.968 0.021 45.456  0.000
9  satisfaction ~~ satisfaction   0.972 0.020 48.095  0.000
10     autonomy ~~     autonomy   1.000 0.000     NA     NA
11     autonomy ~~   competency   0.354 0.000     NA     NA
12     autonomy ~~  relatedness   0.397 0.000     NA     NA
13   competency ~~   competency   1.000 0.000     NA     NA
14   competency ~~  relatedness   0.517 0.000     NA     NA
15  relatedness ~~  relatedness   1.000 0.000     NA     NA
```

```
Correlation between involvement ~~ satisfaction:  0.3568594
```

# Session Information
For the sake of documentation and reproducibility, the current report was rendered on a system using the following software.


```
Report rendered by Will at 2016-04-14, 21:54 -0500
```

```
R version 3.2.4 Patched (2016-03-28 r70435)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] magrittr_1.5  lavaan_0.5-20 knitr_1.12.3 

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.4                 quadprog_1.5-5              assertthat_0.1              dplyr_0.4.3                
 [5] digest_0.6.9                MASS_7.3-45                 R6_2.1.2                    DBI_0.3.1.9008             
 [9] stats4_3.2.4                formatR_1.3                 evaluate_0.8.3              TabularManifest_0.1-16.9000
[13] stringi_1.0-1               lazyeval_0.1.10             pbivnorm_0.6.0              rmarkdown_0.9.5            
[17] tools_3.2.4                 stringr_1.0.0               readr_0.2.2                 parallel_3.2.4             
[21] yaml_2.1.13                 mnormt_1.5-4                htmltools_0.3.5            
```

