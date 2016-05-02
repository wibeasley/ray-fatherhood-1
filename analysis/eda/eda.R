rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("./SomethingSomething.R")


# ---- load-packages -----------------------------------------------------------
library(ggplot2) #For graphing
library(magrittr)
requireNamespace("readr")
requireNamespace("knitr")
# requireNamespace("scales") #For formating values in graphs
# requireNamespace("RColorBrewer")
requireNamespace("moments")
requireNamespace("dplyr")
requireNamespace("TabularManifest") # devtools::install_github("Melinae/TabularManifest")


# ---- declare-globals ---------------------------------------------------------
options(show.signif.stars=F) #Turn off the annotations on p-values

path_input <- "./data-unshared/derived/involvement-subject.rds"


# ---- load-data ---------------------------------------------------------------
ds <- readr::read_rds(path_input)

rm(path_input)


# ---- tweak-data --------------------------------------------------------------
ds <- ds %>%
  dplyr::filter(section_complete_count == 7L) %>%
  as.data.frame()

# ---- moments --------------------------------------------------------------
summary(ds) #Mean and quartiles
sapply(ds, sd) #Standard Deviation
sapply(ds, e1071::skewness, na.rm=T) #Skew (0 signifies symmetry)
sapply(ds, e1071::kurtosis, na.rm=T) #Kurtosis (0 signifies Gaussian-ish peakedness)


# ---- marginals --------------------------------------------------------------
# sapply(names(ds), function(x) cat(paste0("TabularManifest::histogram_discrete(ds, \"", x, "\")\n"))) %>% invisible

# TabularManifest::histogram_discrete(ds, "response_id")
TabularManifest::histogram_discrete(ds, "one_child_at_least")
TabularManifest::histogram_discrete(ds, "live_with_child")
TabularManifest::histogram_discrete(ds, "sexual_orientation", main_title="Sexual Orientation")
TabularManifest::histogram_discrete(ds, "live_with_mother")
TabularManifest::histogram_discrete(ds, "is_married")
TabularManifest::histogram_discrete(ds, "married_duration", main_title="Years Married")
TabularManifest::histogram_discrete(ds, "education", main_title="Level of Education")
TabularManifest::histogram_discrete(ds, "age", main_title="Age")
TabularManifest::histogram_discrete(ds, "income_category", main_title="Income Level")
TabularManifest::histogram_discrete(ds, "child_in_home_count", main_title="Number of Children in the Home")
TabularManifest::histogram_discrete(ds, "race", main_title="Race")
TabularManifest::histogram_discrete(ds, "religion", main_title="Religion")
TabularManifest::histogram_discrete(ds, "work_hours_outside", main_title="Work Hours Outside Home")
TabularManifest::histogram_discrete(ds, "work_hours_spouse_outside", main_title="Spousal Work Hours Outside Home")
TabularManifest::histogram_discrete(ds, "section_complete_count")
TabularManifest::histogram_continuous(ds, "autonomy"       , bin_width=.1    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "competency"     , bin_width=.25   , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "involvement"    , bin_width=.2    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "motivation_internal"     , bin_width=.2    , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "motivation_external"     , bin_width=.2    , rounded_digits = 1)
# TabularManifest::histogram_continuous(ds, "motivation"     , bin_width=.2    , rounded_digits = 1)
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
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * (r)^.2)
}
pairs(x=ds[, c("autonomy", "competency", "relatedness", "motivation_internal", "motivation_external", "involvement", "satisfaction" )], lower.panel=panel.smooth, upper.panel=panel.cor, diag.panel=panel.hist)

pairs(x=ds[, c("autonomy", "competency", "relatedness", "motivation_internal", "motivation_external")], lower.panel=panel.smooth, upper.panel=panel.cor, diag.panel=panel.hist)
pairs(x=ds[, c("motivation_internal", "motivation_external", "involvement", "satisfaction" )], lower.panel=panel.smooth, upper.panel=panel.cor, diag.panel=panel.hist)


# grep(" colnames(ds)
