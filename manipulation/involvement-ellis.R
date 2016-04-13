# knitr::stitch_rmd(script="./manipulation/te-ellis.R", output="./manipulation/stitched-output/te-ellis.md")
# For a brief description of this file see the presentation at
#   - slides: https://rawgit.com/wibeasley/RAnalysisSkeleton/master/documentation/time-and-effort-synthesis.html#/
#   - code: https://github.com/wibeasley/RAnalysisSkeleton/blob/master/documentation/time-and-effort-synthesis.Rpres
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr, quietly=TRUE)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr")
requireNamespace("tidyr")
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit") #For asserting conditions meet expected patterns.
requireNamespace("tibble")
requireNamespace("car") #For it's `recode()` function.

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
path_in                        <- "data-unshared/raw/Father_Involvement.csv"
path_in_translator             <- "data-phi-free/raw/variable-translator.csv"
path_out                       <- "data-unshared/derived/involvement-subject.csv"
figure_path                    <- 'manipulation/stitched-output/father-involvement/'

# URIs of CSV and County lookup table
# path_variable_translator       <- "./data-phi-free/raw/variable-translator.csv"

sections_to_summarize <- c("autonomy", "competency", "relatedness", "motivation_internal", "motivation_external", "involvement", "satisfaction")
section_minimum_to_retain <- 0.85 #If a subject's section has less than this much completed, it's set to missing/NA.
# ds_item_group <- tibble::frame_data(
  # ~
# )
# bad_characters <-
# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds_wide_1                      <- readr::read_csv(path_in, skip=1)
ds_translator                  <- readr::read_csv(path_in_translator)

rm(path_in, path_in_translator)

# iconv(colnames(ds_wide_1), "latin1", "ASCII")

# ---- tweak-data --------------------------------------------------------------
# ds_translator <- ds_translator %>%
#   dplyr::mutate(
#     slope        = ifelse(is.na(slope)    , 1, slope),
#     intercept    = ifelse(is.na(intercept), 0, intercept)
#   )



# ---- rename-items --------------------------------------------------------------
testit::assert("The count of variables should match the translator.", nrow(ds_translator)==length(colnames(ds_wide_1)))
colnames(ds_wide_1) <- ds_translator$variable

ds_wide_1 <- ds_wide_1[ , !duplicated(colnames(ds_wide_1))]


columns_to_keep <- ds_translator$variable[ds_translator$retain]

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
    is_married           = as.logical(car::recode(is_married            , "1='TRUE'; else='FALSE'"       ))
  ) %>%
  dplyr::filter(
    !is.na(one_child_at_least) & one_child_at_least &  #Drop if not 'yes'
      !is.na(live_with_child) & live_with_child &      #Drop if not 'yes'
      !is.na(is_married) & is_married                  #Drop if not 'yes'
  )
table(ds_wide_1$sexual_orientation)

# ---- weight-items --------------------------------------------------------------

ds_item <- ds_wide_1 %>%
  tidyr::gather(key="item", value="response_unweighted", -response_id) %>%
  dplyr::left_join(ds_translator, by=c("item"="variable")) %>%
  dplyr::filter(section %in% sections_to_summarize) %>%
  dplyr::select(-label) %>%
  dplyr::mutate(
    response_unweighted    = as.integer(response_unweighted),
    response_weighted      = ifelse(!is.na(slope), intercept + slope*response_unweighted, response_unweighted)
  )

# ---- aggreate-scales --------------------------------------------------------------
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


# ---- widen -------------------------------------------------------------------

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

# ---- verify-values -----------------------------------------------------------
testit::assert("All `response_id` values should be nonmissing.", sum(is.na(ds_wide_2$response_id))==0L)


# ---- specify-columns-to-upload -----------------------------------------------


# ---- save-to-disk ------------------------------------------------------------
readr::write_csv(ds_wide_2, path_out)


# ---- save-metadata-skeleton --------------------------------------------------
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
