# R Package Requirements
# Run this file to install all required packages:
#   source("requirements.R")
# Or from terminal:
#   Rscript requirements.R

packages <- c(
  "vars",        # VAR model estimation
  "tseries",     # ADF stationarity test
  "FinTS",       # ARCH test
  "strucchange", # CUSUM structural stability test
  "normtest",    # Jarque-Bera normality test
  "xts",         # Time series objects
  "zoo",         # Time series utilities
  "ggplot2",     # Visualization
  "psych",       # Descriptive statistics
  "readxl"       # Read .xlsx data files
)

install.packages(packages)
