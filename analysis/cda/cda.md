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
Correlation between motivation_internal ~~ motivatn_xtrnl:  0.1809973
```

```
Correlation between involvement ~~ satisfaction:  0.2272733
```

# Model (Motivation combined into one variable)

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
Correlation between involvement ~~ satisfaction:  0.3568594
```

