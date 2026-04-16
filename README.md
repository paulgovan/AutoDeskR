
# AutoDeskR <a href="http://paulgovan.github.io/AutoDeskR/"><img src="man/figures/logo.png" align="right" height="139" alt="AutoDeskR website" /></a>

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/AutoDeskR)](https://CRAN.R-project.org/package=AutoDeskR)
[![R-CMD-check](https://github.com/paulgovan/AutoDeskR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/paulgovan/AutoDeskR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/paulgovan/AutoDeskR/graph/badge.svg)](https://app.codecov.io/gh/paulgovan/AutoDeskR)
[![](http://cranlogs.r-pkg.org/badges/last-month/AutoDeskR)](https://cran.r-project.org/package=AutoDeskR)
[![](http://cranlogs.r-pkg.org/badges/grand-total/AutoDeskR)](https://cran.r-project.org/package=AutoDeskR)
[![](https://img.shields.io/badge/doi-10.32614/CRAN.package.AutoDeskR-green.svg)](https://doi.org/10.32614/CRAN.package.AutoDeskR)

<!-- badges: end -->

![](https://github.com/paulgovan/AutoDeskR/blob/master/inst/images/basicSample.png?raw=true)

## Introduction

AutoDeskR is an R package that provides an interface to the:

- Authentication API for obtaining authentication to the AutoDesk
  Platform Services (APS).
- Data Management API for managing data across the platform’s cloud
  services.
- Design Automation API for performing automated tasks on model files in
  the cloud.
- Model Derivative API for translating design files into different
  formats, sending them to the viewer app, and extracting model data.
- Viewer for rendering 2D and 3D models.

## Quick Start

To install AutoDeskR in [R](https://www.r-project.org):

    install.packages("AutoDeskR")

Or to install the development version:

    devtools::install_github('paulgovan/autodeskr')

## Code of Conduct

Please note that the AutoDeskR project is released with a [Contributor
Code of
Conduct](http://paulgovan.github.io/AutoDeskR/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.

## Acknowledgements

Many thanks to the developers at <https://aps.autodesk.com> for
providing this great set of tools and for the support needed to learn
and implement these APIs.
