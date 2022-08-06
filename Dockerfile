
FROM rocker/tidyverse:4.1
MAINTAINER Peter Kharchenko "peter_kharchenko@hms.harvard.edu"

RUN apt-get update --yes && apt-get install --no-install-recommends --yes \
  build-essential \
  cmake \
  git \
  libbamtools-dev \
  libboost-dev \
  libboost-iostreams-dev \
  libboost-log-dev \
  libboost-system-dev \
  libboost-test-dev \
  libssl-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  libz-dev \
  curl \
  libhdf5-serial-dev \ 
  libarmadillo-dev

RUN \
  R -e 'chooseCRANmirror(ind=52); install.packages(c("devtools", "Rcpp","RcppArmadillo", "Matrix", "mgcv", "abind","igraph","h5","Rtsne","cluster","data.table", "Seurat", "R.utils", "rmarkdown", "knitr"))'

RUN \
  R -e 'BiocManager::install(c("pcaMethods","edgeR","Rsamtools","GenomicAlignments","GenomeInfoDb","Biostrings"),suppressAutoUpdate=TRUE,ask=FALSE,suppressUpdates=TRUE)'

RUN \
  R -e 'library(devtools); install_github("velocyto-team/velocyto.R"); remotes::install_github("satijalab/seurat-wrappers")'


RUN \
  git clone https://github.com/velocyto-team/velocyto.R && \
  mkdir -p ~/R/x86_64-pc-linux-gnu-library/4.1

RUN \
  echo '.libPaths(c("~/R/x86_64-pc-linux-gnu-library/4.1/", .libPaths()))' > .Rprofile && \
  R -e 'devtools::install_local("~/velocyto.R/",dep=T,upgrade_dependencies=F)'

 RUN \
    apt-get install -y --no-install-recommends libxt6
