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

```
               npar                fmin               chisq                  df              pvalue      baseline.chisq 
             16.000               0.173              89.728               6.000               0.000             536.279 
        baseline.df     baseline.pvalue                 cfi                 tli                nnfi                 rfi 
             18.000               0.000               0.838               0.515               0.515               0.498 
                nfi                pnfi                 ifi                 rni                logl   unrestricted.logl 
              0.833               0.278               0.842               0.838           -1170.491           -1125.627 
                aic                 bic              ntotal                bic2               rmsea      rmsea.ci.lower 
           2372.983            2429.953             260.000            2379.227               0.232               0.191 
     rmsea.ci.upper        rmsea.pvalue                 rmr          rmr_nomean                srmr        srmr_bentler 
              0.275               0.000               0.030               0.030               0.095               0.095 
srmr_bentler_nomean         srmr_bollen  srmr_bollen_nomean          srmr_mplus   srmr_mplus_nomean               cn_05 
              0.095               0.095               0.095               0.095               0.095              37.486 
              cn_01                 gfi                agfi                pgfi                 mfi                ecvi 
             49.715               0.922               0.634               0.197               0.851               0.468 
```

```
lavaan (0.5-20) converged normally after  28 iterations

  Number of observations                           260

  Estimator                                         ML
  Minimum Function Test Statistic               89.728
  Degrees of freedom                                 6
  P-value (Chi-square)                           0.000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                        Estimate  Std.Err  Z-value  P(>|z|)
  motivation_internal ~                                    
    autonomy              -0.095    0.084   -1.126    0.260
    competency             0.268    0.053    5.045    0.000
    relatedness            0.602    0.068    8.803    0.000
  motivation_external ~                                    
    autonomy              -0.069    0.151   -0.454    0.650
    competency             0.216    0.095    2.265    0.024
    relatedness            0.103    0.123    0.843    0.399
  involvement ~                                            
    motivatn_ntrnl         0.605    0.038   16.057    0.000
    motivatn_xtrnl         0.070    0.027    2.540    0.011
  satisfaction ~                                           
    motivatn_ntrnl         0.482    0.060    8.034    0.000
    motivatn_xtrnl         0.025    0.044    0.576    0.565

Covariances:
                         Estimate  Std.Err  Z-value  P(>|z|)
  motivation_internal ~~                                    
    motivatn_xtrnl          0.060    0.021    2.889    0.004
  involvement ~~                                            
    satisfaction            0.041    0.011    3.589    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    motivatn_ntrnl    0.185    0.016   11.402    0.000
    motivatn_xtrnl    0.594    0.052   11.402    0.000
    involvement       0.113    0.010   11.402    0.000
    satisfaction      0.288    0.025   11.402    0.000
```

```
                   lhs op                 rhs est.std    se      z pvalue
1  motivation_internal  ~            autonomy  -0.058 0.052 -1.128  0.259
2  motivation_internal  ~          competency   0.279 0.053  5.233  0.000
3  motivation_internal  ~         relatedness   0.497 0.050  9.935  0.000
4  motivation_external  ~            autonomy  -0.031 0.068 -0.454  0.650
5  motivation_external  ~          competency   0.164 0.071  2.298  0.022
6  motivation_external  ~         relatedness   0.062 0.074  0.844  0.399
7          involvement  ~ motivation_internal   0.699 0.032 21.997  0.000
8          involvement  ~ motivation_external   0.111 0.043  2.541  0.011
9         satisfaction  ~ motivation_internal   0.456 0.050  9.033  0.000
10        satisfaction  ~ motivation_external   0.033 0.057  0.576  0.564
11 motivation_internal ~~ motivation_external   0.182 0.060  3.037  0.002
12         involvement ~~        satisfaction   0.228 0.059  3.884  0.000
13 motivation_internal ~~ motivation_internal   0.563 0.041 13.791  0.000
14 motivation_external ~~ motivation_external   0.963 0.023 42.190  0.000
15         involvement ~~         involvement   0.461 0.041 11.269  0.000
16        satisfaction ~~        satisfaction   0.784 0.045 17.526  0.000
17            autonomy ~~            autonomy   1.000 0.000     NA     NA
18            autonomy ~~          competency   0.354 0.000     NA     NA
19            autonomy ~~         relatedness   0.398 0.000     NA     NA
20          competency ~~          competency   1.000 0.000     NA     NA
21          competency ~~         relatedness   0.518 0.000     NA     NA
22         relatedness ~~         relatedness   1.000 0.000     NA     NA
```

```
Correlation between motivation_internal ~~ motivatn_xtrnl:  0.1809973
```

```
Correlation between involvement ~~ satisfaction:  0.2272733
```

# Model (Motivation combined into one variable)

```
               npar                fmin               chisq                  df              pvalue      baseline.chisq 
              9.000               0.277             143.934               6.000               0.000             394.096 
        baseline.df     baseline.pvalue                 cfi                 tli                nnfi                 rfi 
             12.000               0.000               0.639               0.278               0.278               0.270 
                nfi                pnfi                 ifi                 rni                logl   unrestricted.logl 
              0.635               0.317               0.645               0.639           -1127.842           -1055.875 
                aic                 bic              ntotal                bic2               rmsea      rmsea.ci.lower 
           2273.684            2305.730             260.000            2277.197               0.297               0.256 
     rmsea.ci.upper        rmsea.pvalue                 rmr          rmr_nomean                srmr        srmr_bentler 
              0.340               0.000               0.050               0.050               0.167               0.167 
srmr_bentler_nomean         srmr_bollen  srmr_bollen_nomean          srmr_mplus   srmr_mplus_nomean               cn_05 
              0.167               0.167               0.167               0.167               0.167              23.745 
              cn_01                 gfi                agfi                pgfi                 mfi                ecvi 
             31.369               0.872               0.551               0.249               0.767               0.623 
```

```
lavaan (0.5-20) converged normally after  22 iterations

  Number of observations                           260

  Estimator                                         ML
  Minimum Function Test Statistic              143.934
  Degrees of freedom                                 6
  P-value (Chi-square)                           0.000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)
  motivation ~                                        
    autonomy         -0.163    0.186   -0.879    0.379
    competency        0.483    0.117    4.127    0.000
    relatedness       0.705    0.151    4.674    0.000
  involvement ~                                       
    motivation        0.271    0.023   11.830    0.000
  satisfaction ~                                      
    motivation        0.197    0.033    6.063    0.000

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  involvement ~~                                      
    satisfaction      0.081    0.015    5.418    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    motivation        0.899    0.079   11.402    0.000
    involvement       0.160    0.014   11.402    0.000
    satisfaction      0.322    0.028   11.402    0.000
```

```
            lhs op          rhs est.std    se      z pvalue
1    motivation  ~     autonomy  -0.053 0.060 -0.881  0.378
2    motivation  ~   competency   0.267 0.062  4.279  0.000
3    motivation  ~  relatedness   0.308 0.063  4.898  0.000
4   involvement  ~   motivation   0.592 0.040 14.741  0.000
5  satisfaction  ~   motivation   0.352 0.054  6.489  0.000
6   involvement ~~ satisfaction   0.357 0.054  6.591  0.000
7    motivation ~~   motivation   0.769 0.043 17.824  0.000
8   involvement ~~  involvement   0.650 0.047 13.694  0.000
9  satisfaction ~~ satisfaction   0.876 0.038 22.944  0.000
10     autonomy ~~     autonomy   1.000 0.000     NA     NA
11     autonomy ~~   competency   0.354 0.000     NA     NA
12     autonomy ~~  relatedness   0.398 0.000     NA     NA
13   competency ~~   competency   1.000 0.000     NA     NA
14   competency ~~  relatedness   0.518 0.000     NA     NA
15  relatedness ~~  relatedness   1.000 0.000     NA     NA
```

```
Correlation between involvement ~~ satisfaction:  0.3568594
```

# Session Information
For the sake of documentation and reproducibility, the current report was rendered on a system using the following software.


```
Report rendered by Will at 2016-04-13, 23:00 -0500
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

