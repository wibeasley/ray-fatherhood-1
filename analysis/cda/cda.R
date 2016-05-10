rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("./SomethingSomething.R")

# ---- load-packages -----------------------------------------------------------
library(lavaan)
library(magrittr)
requireNamespace("readr")
requireNamespace("knitr")
# requireNamespace("scales") #For formating values in graphs
# requireNamespace("RColorBrewer")
requireNamespace("dplyr")
requireNamespace("TabularManifest") # devtools::install_github("Melinae/TabularManifest")

# ---- declare-globals ---------------------------------------------------------
options(show.signif.stars=F) #Turn off the annotations on p-values
path_input <- "./data-unshared/derived/involvement-subject.csv"

# ---- load-data ---------------------------------------------------------------
ds <- readr::read_csv(path_input)
rm(path_input)

# ---- tweak-data --------------------------------------------------------------
ds <- ds %>%
  dplyr::filter(section_complete_count == 7L) %>%
  dplyr::mutate(
    motivation   = motivation_internal + motivation_external
  ) %>%
  as.data.frame()


# ---- model-dual-motivation-partial-mediation --------------------------------------------------------------
# > colnames(ds)
# [1] "response_id"               "one_child_at_least"        "live_with_child"
# [4] "sexual_orientation"        "live_with_mother"          "is_married"
# [7] "married_duration"          "education"                 "age"
# [10] "income_category"           "child_in_home_count"       "race"
# [13] "religion"                  "work_hours_outside"        "work_hours_spouse_outside"
# [16] "section_complete_count"    "autonomy"                  "competency"
# [19] "involvement"               "motivation_external"       "motivation_internal"
# [22] "relatedness"               "satisfaction"

model_dual_motivation <- '
# regressions between tiers 1 & 2
motivation_internal ~ autonomy + competency + relatedness
motivation_external ~ autonomy + competency + relatedness

# regressions between tiers 2 & 3
involvement  ~ motivation_internal + motivation_external + autonomy + competency + relatedness
satisfaction ~ motivation_internal + motivation_external + autonomy + competency + relatedness

# residual covariances
# autonomy ~~ competency
# autonomy ~~ relatedness
# competency ~~ relatedness
# motivation_internal ~~ motivation_external
# involvement ~~ satisfaction
'
fit_dual_motivation <- sem(model_dual_motivation, data=ds)
fitmeasures(fit_dual_motivation)
summary(fit_dual_motivation)
standardizedSolution(fit_dual_motivation)
# sapply(ds, sd, na.rm=T)

cat("Correlation between motivation_internal ~~ motivatn_xtrnl: ", 0.060/sqrt(0.185*0.594)) #0.1809973
cat("Correlation between involvement ~~ satisfaction: ", 0.041/sqrt(.113*.288)) #0.2272733 =



# ---- model-dual-motivation --------------------------------------------------------------
# > colnames(ds)
# [1] "response_id"               "one_child_at_least"        "live_with_child"
# [4] "sexual_orientation"        "live_with_mother"          "is_married"
# [7] "married_duration"          "education"                 "age"
# [10] "income_category"           "child_in_home_count"       "race"
# [13] "religion"                  "work_hours_outside"        "work_hours_spouse_outside"
# [16] "section_complete_count"    "autonomy"                  "competency"
# [19] "involvement"               "motivation_external"       "motivation_internal"
# [22] "relatedness"               "satisfaction"

model_dual_motivation <- '
# regressions between tiers 1 & 2
motivation_internal ~ autonomy + competency + relatedness
motivation_external ~ autonomy + competency + relatedness

# regressions between tiers 2 & 3
involvement  ~ motivation_internal + motivation_external
satisfaction ~ motivation_internal + motivation_external

# residual covariances
# autonomy ~~ competency
# autonomy ~~ relatedness
# competency ~~ relatedness
motivation_internal ~~ motivation_external
involvement ~~ satisfaction
'
fit_dual_motivation <- sem(model_dual_motivation, data=ds)
fitmeasures(fit_dual_motivation)
summary(fit_dual_motivation)
standardizedSolution(fit_dual_motivation)
# sapply(ds, sd, na.rm=T)

cat("Correlation between motivation_internal ~~ motivatn_xtrnl: ", 0.060/sqrt(0.185*0.594)) #0.1809973
cat("Correlation between involvement ~~ satisfaction: ", 0.041/sqrt(.113*.288)) #0.2272733 =


# ---- model-single-motivation --------------------------------------------------------------
model_single_motivation <- '
   # regressions between tiers 1 & 2
   motivation ~ autonomy + competency + relatedness

   # regressions between tiers 2 & 3
   involvement  ~ motivation
   satisfaction ~ motivation

   # residual covariances
   involvement ~~ satisfaction
'
fit_single_motivation <- sem(model_single_motivation, data=ds)
fitmeasures(fit_single_motivation)
summary(fit_single_motivation)
standardizedSolution(fit_single_motivation)

cat("Correlation between involvement ~~ satisfaction: ", 0.081/sqrt(0.160*0.322)) #0.3568594 =
