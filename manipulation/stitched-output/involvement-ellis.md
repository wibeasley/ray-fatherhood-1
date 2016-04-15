



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# knitr::stitch_rmd(script="./manipulation/involvement-ellis.R", output="./manipulation/stitched-output/involvement-ellis.md")
# For a brief description of this file see the presentation at
#   - slides: https://rawgit.com/wibeasley/RAnalysisSkeleton/master/documentation/time-and-effort-synthesis.html#/
#   - code: https://github.com/wibeasley/RAnalysisSkeleton/blob/master/documentation/time-and-effort-synthesis.Rpres
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
```

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
```

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr, quietly=TRUE)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr")
```

```
## Loading required namespace: readr
```

```r
requireNamespace("tidyr")
```

```
## Loading required namespace: tidyr
```

```r
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit") #For asserting conditions meet expected patterns.
```

```
## Loading required namespace: testit
```

```r
requireNamespace("tibble")
```

```
## Loading required namespace: tibble
```

```r
requireNamespace("car") #For it's `recode()` function.
```

```
## Loading required namespace: car
```

```r
requireNamespace("psych") #For item reliably
```

```
## Loading required namespace: psych
```

```r
# Constant values that won't change.
path_in                        <- "data-unshared/raw/Father_Involvement.csv"
path_in_translator             <- "data-phi-free/raw/variable-translator.csv"
path_out                       <- "data-unshared/derived/involvement-subject.csv"
figure_path                    <- 'manipulation/stitched-output/father-involvement/'

# URIs of CSV and County lookup table
# path_variable_translator       <- "./data-phi-free/raw/variable-translator.csv"

sections_to_summarize <- c(
  "autonomy", "competency", "relatedness",
  "motivation_internal", "motivation_external",
  "involvement", "satisfaction"
)
names(sections_to_summarize) <- sections_to_summarize

instruments_to_analyze_reliability <- c(
  "pri", "fss", "wafcs", "psi", "kmss", "rc", "rofq",
  "motivation_external", "motivation_internal",
  "ifi", "kpss"
)
names(instruments_to_analyze_reliability) <- instruments_to_analyze_reliability
section_minimum_to_retain <- 0.85 #If a subject's section has less than this much completed, it's set to missing/NA.
# ds_item_group <- tibble::frame_data(
  # ~
# )
# bad_characters <-
```

```r
# Read the CSVs
ds_wide_1                      <- readr::read_csv(path_in, skip=1)
ds_translator                  <- readr::read_csv(path_in_translator)

rm(path_in, path_in_translator)

# iconv(colnames(ds_wide_1), "latin1", "ASCII")
dput(unique(ds_translator$instrument))
```

```
## c("plumbing", "demographics", "pri", "fss", "wafcs", "psi", "kmss", 
## "rc", "rofq", "motivation_external", "motivation_internal", "ifi", 
## "kpss", "gift_card")
```

```r
# ds_translator <- ds_translator %>%
#   dplyr::mutate(
#     slope        = ifelse(is.na(slope)    , 1, slope),
#     intercept    = ifelse(is.na(intercept), 0, intercept)
#   )
```

```r
testit::assert("The count of variables should match the translator.", nrow(ds_translator)==length(colnames(ds_wide_1)))
colnames(ds_wide_1) <- ds_translator$variable


ds_wide_1 <- ds_wide_1[ , !duplicated(colnames(ds_wide_1))]

ds_translator <- ds_translator %>%
  dplyr::filter(retain)

columns_to_keep <- ds_translator$variable

# car::recode(ds_wide_1$work_hours_outside, "1='0'; 2='1-20'; 3='21-40'; 4='40+'")

ds_wide_1 <- ds_wide_1 %>%
  dplyr::select_(.dots=columns_to_keep) %>%
  dplyr::select(-response_id) %>%
  # dplyr::rename_(
  #   "response_tag"    = "response_id"
  # ) %>%
  dplyr::mutate(
    response_id          = seq_len(n()),
    one_child_at_least   = as.logical(car::recode(one_child_at_least    , "1='TRUE'; else='FALSE'"       )),
    live_with_mother     = as.logical(car::recode(live_with_mother      , "1='TRUE'; else='FALSE'"       )),
    is_married           = as.logical(car::recode(is_married            , "1='TRUE'; else='FALSE'"       )),
    sexual_orientation   = car::recode(sexual_orientation    , "1='Heterosexual'; 2='Homosexual'; 3='Bisexual'"       ),
    married_duration     = car::recode(married_duration,  "1='0-1 year'; 2='1-5 years'; 3='6-10 years'; 4='11-15 years'; 5='16-20 years'; 6='20+years'"),
    education            = car::recode(education, "1='High school diploma or GED'; 2='Vocational-Technical Training'; 3='Associates Degree'; 4='College Graduate'; 5='Graduate School'" ),
    age                  = car::recode(age, "1='18-25'; 2='26-40'; 3='41-55'; 4='56 or older'"),
    income_category      = car::recode(income_category, "1='Less than $24,999'; 2='$25,000 to $49,999'; 3='$50,000 to $99,999'; 4='$100,000'"),
    child_in_home_count  = car::recode(child_in_home_count,  "1='1'; 2='2'; 3='3'; 4='4 or more'"),
    race                 = car::recode(race, "1='Black'; 2='Caucasian'; 3='Asian-American'; 4='American Indian'; 5='Hispanic'; 6='Other'"),
    religion             = car::recode(religion, "1='Christian'; 2='Buddhist'; 3='Muslim'; 4='Hindu'; 5='American Indian spirituality/religion'; 6='Agnostic'; 7='Atheist'; 8='None'"),
    work_hours_outside   = car::recode(work_hours_outside, "1='0'; 2='1-20'; 3='21-40'; 4='40+'"),
    work_hours_spouse_outside   = car::recode(work_hours_spouse_outside ,  "1='0'; 2='1-20'; 3='21-40'; 4='40+'")
  ) %>%
  dplyr::filter(
    !is.na(one_child_at_least) & one_child_at_least &  #Drop if not 'yes'
      !is.na(live_with_child) & live_with_child &      #Drop if not 'yes'
      !is.na(is_married) & is_married                  #Drop if not 'yes'
  )
table(ds_wide_1$sexual_orientation)
```

```
## 
##     Bisexual Heterosexual   Homosexual 
##            1          311            3
```

```r
ds_item <- ds_wide_1 %>%
  tidyr::gather(key="item", value="response_unweighted", -response_id) %>%
  dplyr::left_join(ds_translator, by=c("item"="variable")) %>%
  dplyr::filter(section %in% sections_to_summarize) %>%
  dplyr::select(-label) %>%
  dplyr::mutate(
    response_unweighted    = as.integer(response_unweighted),
    response_weighted      = ifelse(!is.na(slope), intercept + slope*response_unweighted, response_unweighted)
  )
```

```r
ds_scale <- ds_item %>%
  dplyr::group_by(response_id, section) %>%
  dplyr::summarize(
    section_response_count  = sum(!is.na(response_weighted)),
    section_item_count      = n(),
    complete_proportion     = section_response_count / section_item_count,
    section_mean            = mean(response_weighted, na.rm=TRUE),
    section_mean            = ifelse(section_minimum_to_retain<complete_proportion, section_mean, NA_real_)
  ) %>%
  dplyr::ungroup() #%>%
# dplyr::filter(0.85<complete_proportion) %>%
```

```r
ds_wide_2a <- ds_scale %>%
  dplyr::group_by(response_id) %>%
  dplyr::summarize(
    section_complete_count  = sum(!is.na(section_mean))
  ) %>%
  dplyr::ungroup()

ds_wide_2b <- ds_scale %>%
  dplyr::select(response_id, section, section_mean) %>%
  tidyr::spread(section, section_mean)

ds_wide_2 <- ds_wide_1 %>%
  dplyr::select_(
    "response_id", "one_child_at_least", "live_with_child", "sexual_orientation",
    "live_with_mother", "is_married", "married_duration", "education",
    "age", "income_category", "child_in_home_count", "race", #"race_other",
    "religion",
    # "relation_biodad", "relation_step", "relation_adoptive", "relation_other", "relation_other_text",
    "work_hours_outside", "work_hours_spouse_outside"
  ) %>%
  dplyr::left_join(ds_wide_2a, by="response_id") %>%
  dplyr::left_join(ds_wide_2b, by="response_id")

table(ds_wide_2$section_complete_count)
```

```
## 
##   0   1   2   3   5   6   7 
##  34   3   5   2   9   2 260
```

```r
testit::assert("All `response_id` values should be nonmissing.", sum(is.na(ds_wide_2$response_id))==0L)
```


```r
readr::write_csv(ds_wide_2, path_out)
```

```r
# ds_column <- data.frame(
#   variable          = NA_character_,
#   questionnaire     = NA_character_,
#   retain            = TRUE,
#   reverse_code      = FALSE,
#   reverse_intercept = NA_real_,
#   reverse_slope     = NA_real_,
#   label             = colnames(ds)
# )
# readr::write_csv(ds_column, path_variable_translator)
```

```r
cat("############### Stuff below this line ideally doesn't stay in an Ellis ############")
```

```
## ############### Stuff below this line ideally doesn't stay in an Ellis ############
```

```r
# ggplot(ds, aes(x = autonomy))

panel.hist <- function(x, ...) {
  usr <- par("usr")
  on.exit(par(usr))
  par(usr=c(usr[1:2], 0, 1.5))

  h <- hist(x, plot=F)
  breaks <- h$breaks
  nB <- length(breaks)
  y <- h$counts
  y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col="white", ...)
}
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * (r)^.2)
}
```

```r
sections_to_summarize
```

```
##              autonomy            competency           relatedness 
##            "autonomy"          "competency"         "relatedness" 
##   motivation_internal   motivation_external           involvement 
## "motivation_internal" "motivation_external"         "involvement" 
##          satisfaction 
##        "satisfaction"
```

```r
lapply(sections_to_summarize, function( construct ) {
  # cat("\n\n+++++++++++++++++++++++++ ", sections_to_summarize[scale], " ++++++++++++++++++++++++\n\n")
  psych::alpha(cor(ds_wide_1[, ds_translator$variable[ds_translator$section==construct]], use="pairwise.complete.obs"))
})
```

```
## Warning in psych::alpha(cor(ds_wide_1[, ds_translator
## $variable[ds_translator$section == : Some items were negatively correlated
## with the total scale and probably should be reversed. To do this, run the
## function again with the 'check.keys=TRUE' option
```

```
## Some items ( tasks_without_help financial_stress_today financial_satisfaction financial_situation_feelings financial_worry_expenses confidence_financial_emergency financial_activities_canceled financial_paycheck_paycheck financial_stress_general ) were negatively correlated with the total scale and probably should be reversed.  To do this, run the function again with the 'check.keys=TRUE' option
```

```
## Warning in psych::alpha(cor(ds_wide_1[, ds_translator
## $variable[ds_translator$section == : Some items were negatively correlated
## with the total scale and probably should be reversed. To do this, run the
## function again with the 'check.keys=TRUE' option
```

```
## Some items ( affection_difficulty father_enjoyment_older_children father_sensitivity ) were negatively correlated with the total scale and probably should be reversed.  To do this, run the function again with the 'check.keys=TRUE' option
```

```
## $autonomy
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.88      0.88    0.94      0.13 7.3
## 
##  Reliability if an item is dropped:
##                                   raw_alpha std.alpha G6(smc) average_r
## encourage_childcare_tasks              0.88      0.88    0.94      0.13
## encourage_ask_help                     0.87      0.87    0.94      0.13
## encourage_compliment                   0.88      0.88    0.94      0.13
## encourage_invite_help                  0.87      0.87    0.94      0.13
## encourage_refuse                       0.88      0.88    0.94      0.13
## encourage_give_look                    0.88      0.88    0.94      0.13
## encourage_appreciation                 0.88      0.88    0.94      0.13
## encourage_irritated_look               0.88      0.88    0.94      0.13
## encourage_hint_work                    0.87      0.87    0.94      0.13
## encourage_tasks_independent            0.88      0.88    0.94      0.13
## encourage_leave_house                  0.88      0.88    0.94      0.13
## encourage_child_ask_help               0.88      0.88    0.94      0.13
## encourage_tells_good_parent            0.88      0.88    0.94      0.13
## encourage_ask_opinion                  0.88      0.88    0.94      0.13
## encourage_tell_others_good_parent      0.88      0.88    0.94      0.13
## encourage_tell_happy                   0.88      0.88    0.94      0.13
## encourage_alone_time                   0.87      0.87    0.94      0.13
## encourage_arrange_activities           0.88      0.88    0.94      0.13
## tells_right_way                        0.87      0.87    0.94      0.13
## shows_anger                            0.87      0.87    0.94      0.13
## keeps_quiet                            0.88      0.88    0.94      0.13
## tells_mistake                          0.88      0.88    0.94      0.13
## explains_concerns                      0.87      0.87    0.94      0.13
## criticize                              0.88      0.88    0.94      0.13
## solicits_their_help                    0.88      0.88    0.94      0.13
## exasperated_look                       0.88      0.88    0.94      0.13
## feelings_discuss                       0.88      0.88    0.94      0.13
## situations_learned                     0.87      0.87    0.94      0.13
## complains_others                       0.88      0.88    0.94      0.13
## take_over                              0.88      0.88    0.94      0.13
## mistakes_on_your_own                   0.88      0.88    0.94      0.13
## instruction                            0.87      0.87    0.94      0.13
## redo_after                             0.88      0.88    0.94      0.13
## tells_child_mistake                    0.88      0.88    0.94      0.13
## tasks_without_help                     0.88      0.88    0.94      0.13
## financial_stress_today                 0.88      0.88    0.94      0.14
## financial_satisfaction                 0.88      0.88    0.94      0.13
## financial_situation_feelings           0.88      0.88    0.94      0.14
## financial_worry_expenses               0.88      0.88    0.94      0.14
## confidence_financial_emergency         0.88      0.88    0.94      0.13
## financial_activities_canceled          0.88      0.88    0.94      0.14
## financial_paycheck_paycheck            0.88      0.88    0.94      0.13
## financial_stress_general               0.88      0.88    0.94      0.14
## work_conflict_family                   0.88      0.88    0.94      0.13
## work_conflict_time                     0.88      0.88    0.94      0.13
## work_commitments_family_time           0.88      0.88    0.94      0.13
## work_conflict_negative_family          0.88      0.88    0.94      0.13
## work_conflict_irritability             0.88      0.88    0.95      0.14
##                                   S/N
## encourage_childcare_tasks         7.0
## encourage_ask_help                6.9
## encourage_compliment              7.1
## encourage_invite_help             6.9
## encourage_refuse                  7.1
## encourage_give_look               7.0
## encourage_appreciation            7.0
## encourage_irritated_look          7.0
## encourage_hint_work               7.0
## encourage_tasks_independent       7.1
## encourage_leave_house             7.3
## encourage_child_ask_help          7.0
## encourage_tells_good_parent       7.1
## encourage_ask_opinion             7.1
## encourage_tell_others_good_parent 7.1
## encourage_tell_happy              7.0
## encourage_alone_time              6.9
## encourage_arrange_activities      7.0
## tells_right_way                   7.0
## shows_anger                       7.0
## keeps_quiet                       7.3
## tells_mistake                     7.0
## explains_concerns                 7.0
## criticize                         7.1
## solicits_their_help               7.0
## exasperated_look                  7.1
## feelings_discuss                  7.0
## situations_learned                7.0
## complains_others                  7.1
## take_over                         7.1
## mistakes_on_your_own              7.1
## instruction                       7.0
## redo_after                        7.2
## tells_child_mistake               7.1
## tasks_without_help                7.3
## financial_stress_today            7.4
## financial_satisfaction            7.3
## financial_situation_feelings      7.3
## financial_worry_expenses          7.4
## confidence_financial_emergency    7.3
## financial_activities_canceled     7.4
## financial_paycheck_paycheck       7.3
## financial_stress_general          7.3
## work_conflict_family              7.3
## work_conflict_time                7.2
## work_commitments_family_time      7.2
## work_conflict_negative_family     7.3
## work_conflict_irritability        7.4
## 
##  Item statistics 
##                                      r r.cor r.drop
## encourage_childcare_tasks         0.50 0.492  0.463
## encourage_ask_help                0.56 0.552  0.522
## encourage_compliment              0.42 0.409  0.372
## encourage_invite_help             0.58 0.572  0.543
## encourage_refuse                  0.42 0.410  0.376
## encourage_give_look               0.46 0.455  0.419
## encourage_appreciation            0.48 0.483  0.440
## encourage_irritated_look          0.48 0.477  0.439
## encourage_hint_work               0.52 0.505  0.474
## encourage_tasks_independent       0.37 0.342  0.324
## encourage_leave_house             0.26 0.228  0.205
## encourage_child_ask_help          0.48 0.460  0.433
## encourage_tells_good_parent       0.43 0.432  0.387
## encourage_ask_opinion             0.38 0.365  0.336
## encourage_tell_others_good_parent 0.41 0.406  0.367
## encourage_tell_happy              0.48 0.483  0.438
## encourage_alone_time              0.63 0.626  0.593
## encourage_arrange_activities      0.50 0.491  0.460
## tells_right_way                   0.51 0.502  0.468
## shows_anger                       0.54 0.536  0.496
## keeps_quiet                       0.26 0.236  0.208
## tells_mistake                     0.50 0.495  0.460
## explains_concerns                 0.55 0.542  0.514
## criticize                         0.41 0.402  0.360
## solicits_their_help               0.48 0.471  0.441
## exasperated_look                  0.46 0.453  0.413
## feelings_discuss                  0.51 0.498  0.464
## situations_learned                0.55 0.549  0.515
## complains_others                  0.38 0.366  0.337
## take_over                         0.40 0.390  0.355
## mistakes_on_your_own              0.40 0.385  0.353
## instruction                       0.53 0.521  0.493
## redo_after                        0.33 0.312  0.282
## tells_child_mistake               0.39 0.373  0.340
## tasks_without_help                0.27 0.258  0.222
## financial_stress_today            0.15 0.139  0.094
## financial_satisfaction            0.22 0.214  0.171
## financial_situation_feelings      0.19 0.188  0.139
## financial_worry_expenses          0.13 0.118  0.076
## confidence_financial_emergency    0.22 0.204  0.169
## financial_activities_canceled     0.16 0.141  0.106
## financial_paycheck_paycheck       0.22 0.213  0.172
## financial_stress_general          0.19 0.186  0.139
## work_conflict_family              0.25 0.243  0.204
## work_conflict_time                0.30 0.281  0.249
## work_commitments_family_time      0.31 0.304  0.259
## work_conflict_negative_family     0.25 0.243  0.199
## work_conflict_irritability        0.13 0.099  0.074
## 
## $competency
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.84      0.84    0.82      0.51 5.2
## 
##  Reliability if an item is dropped:
##                              raw_alpha std.alpha G6(smc) average_r S/N
## father_confidence                 0.78      0.78    0.74      0.47 3.5
## father_good_job                   0.77      0.77    0.73      0.46 3.4
## father_helping_parents            0.83      0.83    0.80      0.55 4.8
## father_problem_solve              0.81      0.81    0.78      0.51 4.2
## father_child_conflict_change      0.83      0.83    0.80      0.55 5.0
## 
##  Item statistics 
##                                 r r.cor r.drop
## father_confidence            0.84  0.82   0.74
## father_good_job              0.85  0.83   0.75
## father_helping_parents       0.72  0.61   0.55
## father_problem_solve         0.77  0.68   0.63
## father_child_conflict_change 0.71  0.59   0.54
## 
## $relatedness
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.82      0.82    0.89      0.18 4.4
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## marital_satisfaction                 0.81      0.81    0.89      0.18 4.2
## relationship_satisfaction            0.81      0.81    0.88      0.18 4.2
## spousal_satisfaction                 0.81      0.81    0.88      0.18 4.2
## child_relationship_satisfaction      0.79      0.79    0.88      0.17 3.8
## child_relationship_positivity        0.80      0.80    0.88      0.17 3.9
## playing_child                        0.80      0.80    0.88      0.17 3.9
## affection_difficulty                 0.83      0.83    0.90      0.21 5.0
## father_role_development              0.80      0.80    0.88      0.17 4.0
## father_responsibility                0.81      0.81    0.89      0.18 4.3
## father_enjoyment_older_children      0.84      0.84    0.90      0.21 5.1
## moods_adult_sensing                  0.80      0.80    0.88      0.18 4.1
## moods_adult_affecting                0.80      0.80    0.88      0.18 4.1
## family_time                          0.80      0.80    0.89      0.17 4.0
## father_childcare                     0.80      0.80    0.89      0.18 4.1
## father_sensitivity                   0.83      0.83    0.90      0.20 4.7
## father_example                       0.80      0.80    0.88      0.17 3.9
## father_psychological_needs           0.80      0.80    0.88      0.17 4.0
## father_response_time                 0.82      0.82    0.90      0.20 4.6
## father_nurture_six_months            0.80      0.80    0.89      0.18 4.1
## father_reward                        0.80      0.80    0.88      0.17 3.9
## 
##  Item statistics 
##                                      r  r.cor r.drop
## marital_satisfaction             0.478  0.487  0.390
## relationship_satisfaction        0.484  0.498  0.396
## spousal_satisfaction             0.488  0.500  0.401
## child_relationship_satisfaction  0.711  0.727  0.652
## child_relationship_positivity    0.678  0.693  0.614
## playing_child                    0.640  0.627  0.570
## affection_difficulty            -0.031 -0.115 -0.136
## father_role_development          0.616  0.599  0.543
## father_responsibility            0.418  0.354  0.324
## father_enjoyment_older_children -0.082 -0.166 -0.186
## moods_adult_sensing              0.546  0.536  0.465
## moods_adult_affecting            0.551  0.542  0.470
## family_time                      0.590  0.559  0.514
## father_childcare                 0.526  0.494  0.443
## father_sensitivity               0.132  0.052  0.026
## father_example                   0.683  0.680  0.620
## father_psychological_needs       0.609  0.597  0.535
## father_response_time             0.200  0.110  0.095
## father_nurture_six_months        0.529  0.491  0.446
## father_reward                    0.663  0.653  0.597
## 
## $motivation_internal
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.94      0.94    0.96      0.46  16
## 
##  Reliability if an item is dropped:
##                                raw_alpha std.alpha G6(smc) average_r S/N
## teach_responsibility_enjoyment      0.94      0.94    0.96      0.48  15
## teach_responsibility_important      0.94      0.94    0.96      0.46  15
## school_encouragement_enjoyment      0.94      0.94    0.96      0.48  15
## school_encouragement_important      0.94      0.94    0.95      0.46  15
## support_mother_enjoyment            0.94      0.94    0.96      0.47  15
## support_mother_important            0.94      0.94    0.96      0.47  15
## provide_enjoyment                   0.94      0.94    0.96      0.47  15
## provide_important                   0.94      0.94    0.96      0.46  15
## talking_child_enjoyment             0.93      0.93    0.95      0.46  14
## talking_child_important             0.94      0.94    0.96      0.46  15
## praise_child_enjoyment              0.93      0.93    0.96      0.45  14
## praise_child_important              0.93      0.93    0.95      0.45  14
## talent_future_enjoyment             0.94      0.94    0.96      0.46  14
## talent_future_important             0.93      0.93    0.95      0.46  14
## reading_support_enjoyment           0.94      0.94    0.96      0.48  16
## reading_support_important           0.94      0.94    0.96      0.46  14
## attention_enjoyment                 0.94      0.94    0.96      0.46  14
## attention_important                 0.93      0.93    0.95      0.45  14
## 
##  Item statistics 
##                                   r r.cor r.drop
## teach_responsibility_enjoyment 0.57  0.53   0.51
## teach_responsibility_important 0.70  0.69   0.66
## school_encouragement_enjoyment 0.57  0.55   0.51
## school_encouragement_important 0.71  0.70   0.67
## support_mother_enjoyment       0.65  0.63   0.60
## support_mother_important       0.66  0.64   0.61
## provide_enjoyment              0.66  0.63   0.62
## provide_important              0.73  0.71   0.69
## talking_child_enjoyment        0.78  0.77   0.74
## talking_child_important        0.74  0.73   0.70
## praise_child_enjoyment         0.80  0.79   0.76
## praise_child_important         0.81  0.80   0.78
## talent_future_enjoyment        0.74  0.73   0.70
## talent_future_important        0.76  0.75   0.72
## reading_support_enjoyment      0.47  0.44   0.41
## reading_support_important      0.75  0.74   0.71
## attention_enjoyment            0.74  0.73   0.70
## attention_important            0.82  0.82   0.79
## 
## $motivation_external
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.93      0.93    0.98      0.44  14
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## teach_responsibility_others          0.93      0.93    0.98      0.43  13
## teach_responsibility_obligation      0.93      0.93    0.98      0.44  14
## school_encouragement_others          0.93      0.93    0.98      0.43  13
## school_encouragement_obligation      0.93      0.93    0.98      0.44  13
## support_mother_others                0.93      0.93    0.98      0.43  13
## support_mother_obligation            0.93      0.93    0.98      0.44  14
## provide_others                       0.93      0.93    0.98      0.43  13
## provide_obligation                   0.93      0.93    0.98      0.44  13
## talking_child_others                 0.93      0.93    0.98      0.43  13
## talking_child_obligation             0.93      0.93    0.98      0.44  13
## praise_child_others                  0.93      0.93    0.98      0.43  13
## praise_child_obligation              0.93      0.93    0.98      0.44  13
## talent_future_others                 0.93      0.93    0.98      0.43  13
## talent_future_obligation             0.93      0.93    0.98      0.44  13
## reading_support_others               0.93      0.93    0.98      0.43  13
## reading_support_obligation           0.93      0.93    0.98      0.44  13
## attention_others                     0.93      0.93    0.98      0.43  13
## attention_obligation                 0.93      0.93    0.98      0.44  13
## 
##  Item statistics 
##                                    r r.cor r.drop
## teach_responsibility_others     0.70  0.69   0.65
## teach_responsibility_obligation 0.60  0.57   0.54
## school_encouragement_others     0.73  0.73   0.69
## school_encouragement_obligation 0.64  0.62   0.58
## support_mother_others           0.73  0.72   0.69
## support_mother_obligation       0.60  0.57   0.54
## provide_others                  0.72  0.72   0.68
## provide_obligation              0.66  0.64   0.61
## talking_child_others            0.73  0.73   0.69
## talking_child_obligation        0.66  0.65   0.61
## praise_child_others             0.72  0.72   0.68
## praise_child_obligation         0.65  0.64   0.60
## talent_future_others            0.73  0.73   0.69
## talent_future_obligation        0.66  0.65   0.61
## reading_support_others          0.71  0.71   0.66
## reading_support_obligation      0.66  0.66   0.62
## attention_others                0.73  0.73   0.69
## attention_obligation            0.68  0.68   0.63
## 
## $involvement
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.95      0.95    0.97      0.45  21
## 
##  Reliability if an item is dropped:
##                                  raw_alpha std.alpha G6(smc) average_r S/N
## attending_events                      0.95      0.95    0.97      0.45  21
## reading_encouragement                 0.95      0.95    0.97      0.45  21
## provide_needs                         0.95      0.95    0.96      0.45  20
## praising_choices                      0.95      0.95    0.96      0.44  20
## encouraging_mother                    0.95      0.95    0.96      0.45  21
## routine_daily_involvement             0.95      0.95    0.97      0.45  21
## praise_mom_to_children                0.95      0.95    0.96      0.45  21
## praise_children_good_job              0.95      0.95    0.96      0.44  20
## encourage_school                      0.95      0.95    0.96      0.44  20
## befriend_children                     0.96      0.96    0.97      0.47  22
## financial_support_responsibility      0.95      0.95    0.97      0.45  21
## encourage_homework                    0.95      0.95    0.96      0.44  20
## love_communication                    0.95      0.95    0.96      0.45  20
## children_whereabouts                  0.95      0.95    0.96      0.45  20
## talking_children                      0.95      0.95    0.96      0.44  20
## mother_cooperation_parenting          0.95      0.95    0.96      0.45  20
## reading_child                         0.95      0.95    0.97      0.45  21
## teach_rules_following                 0.95      0.95    0.96      0.44  20
## encourage_college                     0.95      0.95    0.97      0.45  20
## discipline_child                      0.95      0.95    0.96      0.45  20
## homework_help                         0.95      0.95    0.97      0.45  21
## plan_child_future                     0.95      0.95    0.97      0.45  21
## encourage_talent_development          0.95      0.95    0.96      0.45  20
## time_child                            0.95      0.95    0.96      0.45  20
## chores_encouragement                  0.95      0.95    0.97      0.45  21
## rules_behavior_child                  0.95      0.95    0.96      0.45  20
## 
##  Item statistics 
##                                     r r.cor r.drop
## attending_events                 0.62  0.60   0.59
## reading_encouragement            0.61  0.60   0.58
## provide_needs                    0.73  0.72   0.70
## praising_choices                 0.82  0.82   0.80
## encouraging_mother               0.65  0.64   0.61
## routine_daily_involvement        0.60  0.58   0.56
## praise_mom_to_children           0.65  0.64   0.61
## praise_children_good_job         0.81  0.81   0.79
## encourage_school                 0.81  0.81   0.79
## befriend_children                0.40  0.36   0.35
## financial_support_responsibility 0.64  0.63   0.60
## encourage_homework               0.77  0.76   0.74
## love_communication               0.72  0.71   0.69
## children_whereabouts             0.73  0.73   0.71
## talking_children                 0.76  0.75   0.73
## mother_cooperation_parenting     0.74  0.73   0.71
## reading_child                    0.59  0.57   0.55
## teach_rules_following            0.76  0.76   0.74
## encourage_college                0.66  0.64   0.62
## discipline_child                 0.69  0.68   0.66
## homework_help                    0.61  0.59   0.57
## plan_child_future                0.64  0.62   0.60
## encourage_talent_development     0.73  0.72   0.70
## time_child                       0.73  0.73   0.71
## chores_encouragement             0.64  0.62   0.60
## rules_behavior_child             0.72  0.71   0.69
## 
## $satisfaction
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$section == 
##     construct]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##        0.8       0.8    0.73      0.57   4
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## satisfaction_child                   0.78      0.78    0.64      0.64 3.5
## satisfaction_parenting               0.71      0.71    0.55      0.55 2.5
## satisfaction_relationship_child      0.69      0.69    0.53      0.53 2.3
## 
##  Item statistics 
##                                    r r.cor r.drop
## satisfaction_child              0.82  0.66   0.60
## satisfaction_parenting          0.85  0.75   0.66
## satisfaction_relationship_child 0.86  0.76   0.68
```

```r
instruments_to_analyze_reliability
```

```
##                   pri                   fss                 wafcs 
##                 "pri"                 "fss"               "wafcs" 
##                   psi                  kmss                    rc 
##                 "psi"                "kmss"                  "rc" 
##                  rofq   motivation_external   motivation_internal 
##                "rofq" "motivation_external" "motivation_internal" 
##                   ifi                  kpss 
##                 "ifi"                "kpss"
```

```r
lapply(instruments_to_analyze_reliability, function( instrument ) {
  # cat("\n\n+++++++++++++++++++++++++ ", instruments_to_analyze_reliability[scale], " ++++++++++++++++++++++++\n\n")
  psych::alpha(cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument==instrument]], use="pairwise.complete.obs"))
})
```

```
## Warning in psych::alpha(cor(ds_wide_1[, ds_translator
## $variable[ds_translator$instrument == : Some items were negatively
## correlated with the total scale and probably should be reversed. To do
## this, run the function again with the 'check.keys=TRUE' option
```

```
## Some items ( affection_difficulty father_enjoyment_older_children father_sensitivity ) were negatively correlated with the total scale and probably should be reversed.  To do this, run the function again with the 'check.keys=TRUE' option
```

```
## $pri
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.91      0.91    0.94      0.21 9.6
## 
##  Reliability if an item is dropped:
##                                   raw_alpha std.alpha G6(smc) average_r
## encourage_childcare_tasks              0.90      0.90    0.94      0.21
## encourage_ask_help                     0.90      0.90    0.94      0.21
## encourage_compliment                   0.90      0.90    0.94      0.22
## encourage_invite_help                  0.90      0.90    0.94      0.21
## encourage_refuse                       0.90      0.90    0.94      0.22
## encourage_give_look                    0.90      0.90    0.94      0.21
## encourage_appreciation                 0.90      0.90    0.94      0.22
## encourage_irritated_look               0.90      0.90    0.94      0.21
## encourage_hint_work                    0.90      0.90    0.94      0.21
## encourage_tasks_independent            0.90      0.90    0.94      0.22
## encourage_leave_house                  0.91      0.91    0.95      0.22
## encourage_child_ask_help               0.90      0.90    0.94      0.21
## encourage_tells_good_parent            0.90      0.90    0.94      0.22
## encourage_ask_opinion                  0.90      0.90    0.94      0.22
## encourage_tell_others_good_parent      0.90      0.90    0.94      0.22
## encourage_tell_happy                   0.90      0.90    0.94      0.21
## encourage_alone_time                   0.90      0.90    0.94      0.21
## encourage_arrange_activities           0.90      0.90    0.94      0.21
## tells_right_way                        0.90      0.90    0.94      0.21
## shows_anger                            0.90      0.90    0.94      0.21
## keeps_quiet                            0.91      0.91    0.94      0.22
## tells_mistake                          0.90      0.90    0.94      0.21
## explains_concerns                      0.90      0.90    0.94      0.21
## criticize                              0.90      0.90    0.94      0.21
## solicits_their_help                    0.90      0.90    0.94      0.21
## exasperated_look                       0.90      0.90    0.94      0.21
## feelings_discuss                       0.90      0.90    0.94      0.21
## situations_learned                     0.90      0.90    0.94      0.21
## complains_others                       0.90      0.90    0.94      0.22
## take_over                              0.90      0.90    0.94      0.21
## mistakes_on_your_own                   0.90      0.90    0.94      0.22
## instruction                            0.90      0.90    0.94      0.21
## redo_after                             0.90      0.90    0.94      0.22
## tells_child_mistake                    0.90      0.90    0.94      0.22
## tasks_without_help                     0.91      0.91    0.94      0.22
##                                   S/N
## encourage_childcare_tasks         9.3
## encourage_ask_help                9.2
## encourage_compliment              9.3
## encourage_invite_help             9.1
## encourage_refuse                  9.3
## encourage_give_look               9.2
## encourage_appreciation            9.3
## encourage_irritated_look          9.2
## encourage_hint_work               9.2
## encourage_tasks_independent       9.4
## encourage_leave_house             9.6
## encourage_child_ask_help          9.2
## encourage_tells_good_parent       9.4
## encourage_ask_opinion             9.4
## encourage_tell_others_good_parent 9.4
## encourage_tell_happy              9.3
## encourage_alone_time              9.1
## encourage_arrange_activities      9.3
## tells_right_way                   9.1
## shows_anger                       9.0
## keeps_quiet                       9.6
## tells_mistake                     9.2
## explains_concerns                 9.1
## criticize                         9.3
## solicits_their_help               9.2
## exasperated_look                  9.2
## feelings_discuss                  9.2
## situations_learned                9.1
## complains_others                  9.4
## take_over                         9.3
## mistakes_on_your_own              9.4
## instruction                       9.1
## redo_after                        9.5
## tells_child_mistake               9.4
## tasks_without_help                9.7
## 
##  Item statistics 
##                                      r r.cor r.drop
## encourage_childcare_tasks         0.50  0.48   0.45
## encourage_ask_help                0.54  0.52   0.49
## encourage_compliment              0.45  0.44   0.40
## encourage_invite_help             0.58  0.57   0.54
## encourage_refuse                  0.47  0.45   0.42
## encourage_give_look               0.54  0.53   0.50
## encourage_appreciation            0.46  0.46   0.42
## encourage_irritated_look          0.54  0.54   0.50
## encourage_hint_work               0.54  0.53   0.50
## encourage_tasks_independent       0.39  0.36   0.34
## encourage_leave_house             0.32  0.29   0.27
## encourage_child_ask_help          0.52  0.50   0.47
## encourage_tells_good_parent       0.44  0.44   0.39
## encourage_ask_opinion             0.40  0.38   0.35
## encourage_tell_others_good_parent 0.43  0.42   0.38
## encourage_tell_happy              0.48  0.48   0.43
## encourage_alone_time              0.61  0.60   0.57
## encourage_arrange_activities      0.49  0.48   0.45
## tells_right_way                   0.58  0.57   0.54
## shows_anger                       0.63  0.63   0.59
## keeps_quiet                       0.30  0.28   0.25
## tells_mistake                     0.55  0.54   0.50
## explains_concerns                 0.61  0.60   0.58
## criticize                         0.48  0.47   0.43
## solicits_their_help               0.52  0.51   0.48
## exasperated_look                  0.54  0.54   0.50
## feelings_discuss                  0.56  0.56   0.52
## situations_learned                0.58  0.57   0.53
## complains_others                  0.44  0.42   0.39
## take_over                         0.47  0.46   0.42
## mistakes_on_your_own              0.44  0.42   0.39
## instruction                       0.58  0.56   0.54
## redo_after                        0.38  0.35   0.33
## tells_child_mistake               0.43  0.41   0.38
## tasks_without_help                0.23  0.21   0.17
## 
## $fss
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.94      0.94    0.94      0.65  15
## 
##  Reliability if an item is dropped:
##                                raw_alpha std.alpha G6(smc) average_r S/N
## financial_stress_today              0.93      0.93    0.93      0.65  13
## financial_satisfaction              0.93      0.93    0.93      0.64  13
## financial_situation_feelings        0.92      0.92    0.92      0.63  12
## financial_worry_expenses            0.93      0.93    0.93      0.64  13
## confidence_financial_emergency      0.94      0.94    0.94      0.68  15
## financial_activities_canceled       0.93      0.93    0.93      0.67  14
## financial_paycheck_paycheck         0.93      0.93    0.93      0.65  13
## financial_stress_general            0.92      0.92    0.92      0.63  12
## 
##  Item statistics 
##                                   r r.cor r.drop
## financial_stress_today         0.84  0.82   0.78
## financial_satisfaction         0.85  0.83   0.80
## financial_situation_feelings   0.89  0.89   0.85
## financial_worry_expenses       0.85  0.82   0.80
## confidence_financial_emergency 0.74  0.69   0.66
## financial_activities_canceled  0.76  0.72   0.69
## financial_paycheck_paycheck    0.83  0.80   0.78
## financial_stress_general       0.89  0.89   0.86
## 
## $wafcs
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.86      0.86    0.86      0.56 6.3
## 
##  Reliability if an item is dropped:
##                               raw_alpha std.alpha G6(smc) average_r S/N
## work_conflict_family               0.82      0.82    0.81      0.54 4.7
## work_conflict_time                 0.85      0.85    0.84      0.59 5.7
## work_commitments_family_time       0.81      0.81    0.78      0.51 4.2
## work_conflict_negative_family      0.80      0.80    0.78      0.51 4.1
## work_conflict_irritability         0.88      0.88    0.86      0.65 7.5
## 
##  Item statistics 
##                                  r r.cor r.drop
## work_conflict_family          0.83  0.79   0.72
## work_conflict_time            0.76  0.66   0.62
## work_commitments_family_time  0.88  0.87   0.79
## work_conflict_negative_family 0.88  0.87   0.80
## work_conflict_irritability    0.67  0.53   0.49
## 
## $psi
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.84      0.84    0.82      0.51 5.2
## 
##  Reliability if an item is dropped:
##                              raw_alpha std.alpha G6(smc) average_r S/N
## father_confidence                 0.78      0.78    0.74      0.47 3.5
## father_good_job                   0.77      0.77    0.73      0.46 3.4
## father_helping_parents            0.83      0.83    0.80      0.55 4.8
## father_problem_solve              0.81      0.81    0.78      0.51 4.2
## father_child_conflict_change      0.83      0.83    0.80      0.55 5.0
## 
##  Item statistics 
##                                 r r.cor r.drop
## father_confidence            0.84  0.82   0.74
## father_good_job              0.85  0.83   0.75
## father_helping_parents       0.72  0.61   0.55
## father_problem_solve         0.77  0.68   0.63
## father_child_conflict_change 0.71  0.59   0.54
## 
## $kmss
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.96      0.96    0.94      0.89  25
## 
##  Reliability if an item is dropped:
##                           raw_alpha std.alpha G6(smc) average_r S/N
## marital_satisfaction           0.95      0.95    0.91      0.91  21
## relationship_satisfaction      0.93      0.93    0.87      0.87  14
## spousal_satisfaction           0.94      0.94    0.89      0.89  17
## 
##  Item statistics 
##                              r r.cor r.drop
## marital_satisfaction      0.96  0.92   0.90
## relationship_satisfaction 0.97  0.95   0.93
## spousal_satisfaction      0.96  0.94   0.92
## 
## $rc
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.93      0.93    0.87      0.87  13
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## child_relationship_satisfaction      0.87      0.87    0.75      0.87  NA
## child_relationship_positivity        0.87      0.87    0.75      0.87  NA
## 
##  Item statistics 
##                                    r r.cor r.drop
## child_relationship_satisfaction 0.97   0.9   0.87
## child_relationship_positivity   0.97   0.9   0.87
## 
## $rofq
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.75      0.75    0.83      0.17 3.1
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## playing_child                        0.73      0.73    0.80      0.16 2.7
## affection_difficulty                 0.78      0.78    0.84      0.21 3.6
## father_role_development              0.73      0.73    0.80      0.16 2.7
## father_responsibility                0.74      0.74    0.82      0.17 2.9
## father_enjoyment_older_children      0.79      0.79    0.84      0.21 3.7
## moods_adult_sensing                  0.73      0.73    0.80      0.16 2.7
## moods_adult_affecting                0.73      0.73    0.80      0.16 2.6
## family_time                          0.73      0.73    0.81      0.16 2.6
## father_childcare                     0.73      0.73    0.81      0.16 2.7
## father_sensitivity                   0.77      0.77    0.84      0.20 3.4
## father_example                       0.71      0.71    0.79      0.15 2.5
## father_psychological_needs           0.72      0.72    0.80      0.16 2.6
## father_response_time                 0.77      0.77    0.84      0.19 3.3
## father_nurture_six_months            0.73      0.73    0.81      0.16 2.7
## father_reward                        0.72      0.72    0.80      0.16 2.6
## 
##  Item statistics 
##                                       r  r.cor  r.drop
## playing_child                    0.6147  0.600  0.5153
## affection_difficulty             0.0266 -0.084 -0.1130
## father_role_development          0.6122  0.600  0.5124
## father_responsibility            0.4670  0.390  0.3465
## father_enjoyment_older_children -0.0064 -0.119 -0.1452
## moods_adult_sensing              0.6028  0.603  0.5014
## moods_adult_affecting            0.6202  0.625  0.5219
## family_time                      0.6197  0.589  0.5213
## father_childcare                 0.5741  0.544  0.4682
## father_sensitivity               0.1306  0.017 -0.0098
## father_example                   0.7375  0.752  0.6624
## father_psychological_needs       0.6666  0.667  0.5767
## father_response_time             0.2265  0.108  0.0881
## father_nurture_six_months        0.5908  0.554  0.4875
## father_reward                    0.6432  0.637  0.5489
## 
## $motivation_external
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.93      0.93    0.98      0.44  14
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## teach_responsibility_others          0.93      0.93    0.98      0.43  13
## teach_responsibility_obligation      0.93      0.93    0.98      0.44  14
## school_encouragement_others          0.93      0.93    0.98      0.43  13
## school_encouragement_obligation      0.93      0.93    0.98      0.44  13
## support_mother_others                0.93      0.93    0.98      0.43  13
## support_mother_obligation            0.93      0.93    0.98      0.44  14
## provide_others                       0.93      0.93    0.98      0.43  13
## provide_obligation                   0.93      0.93    0.98      0.44  13
## talking_child_others                 0.93      0.93    0.98      0.43  13
## talking_child_obligation             0.93      0.93    0.98      0.44  13
## praise_child_others                  0.93      0.93    0.98      0.43  13
## praise_child_obligation              0.93      0.93    0.98      0.44  13
## talent_future_others                 0.93      0.93    0.98      0.43  13
## talent_future_obligation             0.93      0.93    0.98      0.44  13
## reading_support_others               0.93      0.93    0.98      0.43  13
## reading_support_obligation           0.93      0.93    0.98      0.44  13
## attention_others                     0.93      0.93    0.98      0.43  13
## attention_obligation                 0.93      0.93    0.98      0.44  13
## 
##  Item statistics 
##                                    r r.cor r.drop
## teach_responsibility_others     0.70  0.69   0.65
## teach_responsibility_obligation 0.60  0.57   0.54
## school_encouragement_others     0.73  0.73   0.69
## school_encouragement_obligation 0.64  0.62   0.58
## support_mother_others           0.73  0.72   0.69
## support_mother_obligation       0.60  0.57   0.54
## provide_others                  0.72  0.72   0.68
## provide_obligation              0.66  0.64   0.61
## talking_child_others            0.73  0.73   0.69
## talking_child_obligation        0.66  0.65   0.61
## praise_child_others             0.72  0.72   0.68
## praise_child_obligation         0.65  0.64   0.60
## talent_future_others            0.73  0.73   0.69
## talent_future_obligation        0.66  0.65   0.61
## reading_support_others          0.71  0.71   0.66
## reading_support_obligation      0.66  0.66   0.62
## attention_others                0.73  0.73   0.69
## attention_obligation            0.68  0.68   0.63
## 
## $motivation_internal
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.94      0.94    0.96      0.46  16
## 
##  Reliability if an item is dropped:
##                                raw_alpha std.alpha G6(smc) average_r S/N
## teach_responsibility_enjoyment      0.94      0.94    0.96      0.48  15
## teach_responsibility_important      0.94      0.94    0.96      0.46  15
## school_encouragement_enjoyment      0.94      0.94    0.96      0.48  15
## school_encouragement_important      0.94      0.94    0.95      0.46  15
## support_mother_enjoyment            0.94      0.94    0.96      0.47  15
## support_mother_important            0.94      0.94    0.96      0.47  15
## provide_enjoyment                   0.94      0.94    0.96      0.47  15
## provide_important                   0.94      0.94    0.96      0.46  15
## talking_child_enjoyment             0.93      0.93    0.95      0.46  14
## talking_child_important             0.94      0.94    0.96      0.46  15
## praise_child_enjoyment              0.93      0.93    0.96      0.45  14
## praise_child_important              0.93      0.93    0.95      0.45  14
## talent_future_enjoyment             0.94      0.94    0.96      0.46  14
## talent_future_important             0.93      0.93    0.95      0.46  14
## reading_support_enjoyment           0.94      0.94    0.96      0.48  16
## reading_support_important           0.94      0.94    0.96      0.46  14
## attention_enjoyment                 0.94      0.94    0.96      0.46  14
## attention_important                 0.93      0.93    0.95      0.45  14
## 
##  Item statistics 
##                                   r r.cor r.drop
## teach_responsibility_enjoyment 0.57  0.53   0.51
## teach_responsibility_important 0.70  0.69   0.66
## school_encouragement_enjoyment 0.57  0.55   0.51
## school_encouragement_important 0.71  0.70   0.67
## support_mother_enjoyment       0.65  0.63   0.60
## support_mother_important       0.66  0.64   0.61
## provide_enjoyment              0.66  0.63   0.62
## provide_important              0.73  0.71   0.69
## talking_child_enjoyment        0.78  0.77   0.74
## talking_child_important        0.74  0.73   0.70
## praise_child_enjoyment         0.80  0.79   0.76
## praise_child_important         0.81  0.80   0.78
## talent_future_enjoyment        0.74  0.73   0.70
## talent_future_important        0.76  0.75   0.72
## reading_support_enjoyment      0.47  0.44   0.41
## reading_support_important      0.75  0.74   0.71
## attention_enjoyment            0.74  0.73   0.70
## attention_important            0.82  0.82   0.79
## 
## $ifi
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##       0.95      0.95    0.97      0.45  21
## 
##  Reliability if an item is dropped:
##                                  raw_alpha std.alpha G6(smc) average_r S/N
## attending_events                      0.95      0.95    0.97      0.45  21
## reading_encouragement                 0.95      0.95    0.97      0.45  21
## provide_needs                         0.95      0.95    0.96      0.45  20
## praising_choices                      0.95      0.95    0.96      0.44  20
## encouraging_mother                    0.95      0.95    0.96      0.45  21
## routine_daily_involvement             0.95      0.95    0.97      0.45  21
## praise_mom_to_children                0.95      0.95    0.96      0.45  21
## praise_children_good_job              0.95      0.95    0.96      0.44  20
## encourage_school                      0.95      0.95    0.96      0.44  20
## befriend_children                     0.96      0.96    0.97      0.47  22
## financial_support_responsibility      0.95      0.95    0.97      0.45  21
## encourage_homework                    0.95      0.95    0.96      0.44  20
## love_communication                    0.95      0.95    0.96      0.45  20
## children_whereabouts                  0.95      0.95    0.96      0.45  20
## talking_children                      0.95      0.95    0.96      0.44  20
## mother_cooperation_parenting          0.95      0.95    0.96      0.45  20
## reading_child                         0.95      0.95    0.97      0.45  21
## teach_rules_following                 0.95      0.95    0.96      0.44  20
## encourage_college                     0.95      0.95    0.97      0.45  20
## discipline_child                      0.95      0.95    0.96      0.45  20
## homework_help                         0.95      0.95    0.97      0.45  21
## plan_child_future                     0.95      0.95    0.97      0.45  21
## encourage_talent_development          0.95      0.95    0.96      0.45  20
## time_child                            0.95      0.95    0.96      0.45  20
## chores_encouragement                  0.95      0.95    0.97      0.45  21
## rules_behavior_child                  0.95      0.95    0.96      0.45  20
## 
##  Item statistics 
##                                     r r.cor r.drop
## attending_events                 0.62  0.60   0.59
## reading_encouragement            0.61  0.60   0.58
## provide_needs                    0.73  0.72   0.70
## praising_choices                 0.82  0.82   0.80
## encouraging_mother               0.65  0.64   0.61
## routine_daily_involvement        0.60  0.58   0.56
## praise_mom_to_children           0.65  0.64   0.61
## praise_children_good_job         0.81  0.81   0.79
## encourage_school                 0.81  0.81   0.79
## befriend_children                0.40  0.36   0.35
## financial_support_responsibility 0.64  0.63   0.60
## encourage_homework               0.77  0.76   0.74
## love_communication               0.72  0.71   0.69
## children_whereabouts             0.73  0.73   0.71
## talking_children                 0.76  0.75   0.73
## mother_cooperation_parenting     0.74  0.73   0.71
## reading_child                    0.59  0.57   0.55
## teach_rules_following            0.76  0.76   0.74
## encourage_college                0.66  0.64   0.62
## discipline_child                 0.69  0.68   0.66
## homework_help                    0.61  0.59   0.57
## plan_child_future                0.64  0.62   0.60
## encourage_talent_development     0.73  0.72   0.70
## time_child                       0.73  0.73   0.71
## chores_encouragement             0.64  0.62   0.60
## rules_behavior_child             0.72  0.71   0.69
## 
## $kpss
## 
## Reliability analysis   
## Call: psych::alpha(x = cor(ds_wide_1[, ds_translator$variable[ds_translator$instrument == 
##     instrument]], use = "pairwise.complete.obs"))
## 
##   raw_alpha std.alpha G6(smc) average_r S/N
##        0.8       0.8    0.73      0.57   4
## 
##  Reliability if an item is dropped:
##                                 raw_alpha std.alpha G6(smc) average_r S/N
## satisfaction_child                   0.78      0.78    0.64      0.64 3.5
## satisfaction_parenting               0.71      0.71    0.55      0.55 2.5
## satisfaction_relationship_child      0.69      0.69    0.53      0.53 2.3
## 
##  Item statistics 
##                                    r r.cor r.drop
## satisfaction_child              0.82  0.66   0.60
## satisfaction_parenting          0.85  0.75   0.66
## satisfaction_relationship_child 0.86  0.76   0.68
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.2.4 Patched (2016-03-28 r70435)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] magrittr_1.5
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.4        knitr_1.12.3       splines_3.2.4     
##  [4] MASS_7.3-45        mnormt_1.5-4       testit_0.5.1      
##  [7] lattice_0.20-33    R6_2.1.2           minqa_1.2.4       
## [10] stringr_1.0.0      car_2.1-2          dplyr_0.4.3       
## [13] tools_3.2.4        nnet_7.3-12        parallel_3.2.4    
## [16] pbkrtest_0.4-6     grid_3.2.4         nlme_3.1-125      
## [19] mgcv_1.8-12        quantreg_5.21      psych_1.5.8       
## [22] DBI_0.3.1.9008     MatrixModels_0.4-1 lazyeval_0.1.10   
## [25] lme4_1.1-11        assertthat_0.1     tibble_1.0        
## [28] Matrix_1.2-4       nloptr_1.0.4       readr_0.2.2       
## [31] formatR_1.3        tidyr_0.4.1        rsconnect_0.4.2.1 
## [34] evaluate_0.8.3     stringi_1.0-1      SparseM_1.7
```

```r
Sys.time()
```

```
## [1] "2016-04-15 10:03:58 CDT"
```

