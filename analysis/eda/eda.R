rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("./SomethingSomething.R")


# ---- load-packages -----------------------------------------------------------
# library(ggplot2) #For graphing
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
  dplyr::filter(section_complete_count == 6L) %>%
  as.data.frame()

# ---- singular-columns --------------------------------------------------------

# ---- na-columns --------------------------------------------------------------


# ---- marginals --------------------------------------------------------------
# sapply(names(ds), function(x) cat(paste0("TabularManifest::histogram_discrete(ds, \"", x, "\")\n"))) %>% invisible

# TabularManifest::histogram_discrete(ds, "response_id")
TabularManifest::histogram_discrete(ds, "one_child_at_least")
TabularManifest::histogram_discrete(ds, "live_with_child")
TabularManifest::histogram_discrete(ds, "sexual_orientation")
TabularManifest::histogram_discrete(ds, "live_with_mother")
TabularManifest::histogram_discrete(ds, "is_married")
TabularManifest::histogram_discrete(ds, "married_duration")
TabularManifest::histogram_discrete(ds, "education")
TabularManifest::histogram_discrete(ds, "age")
TabularManifest::histogram_discrete(ds, "income_category")
TabularManifest::histogram_discrete(ds, "child_in_home_count")
TabularManifest::histogram_discrete(ds, "race")
TabularManifest::histogram_discrete(ds, "religion")
TabularManifest::histogram_discrete(ds, "work_hours_outside")
TabularManifest::histogram_discrete(ds, "work_hours_spouse_outside")
TabularManifest::histogram_discrete(ds, "section_complete_count")
TabularManifest::histogram_continuous(ds, "autonomy"       , bin_width=.1    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "competency"     , bin_width=.25   , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "involvement"    , bin_width=.2    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "motivation"     , bin_width=.2    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "relatedness"    , bin_width=.2    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "satisfaction"   , bin_width=.5    , rounded_digits = 1)


# ---- scatterplots --------------------------------------------------------------
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
pairs(x=ds[, c("autonomy", "competency", "involvement", "motivation", "relatedness", "satisfaction" )], lower.panel=panel.smooth, upper.panel=panel.smooth, diag.panel=panel.hist)


