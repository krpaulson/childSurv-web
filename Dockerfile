FROM rocker/shiny:4.4

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/shiny-server

RUN R -e "install.packages(c('shiny', 'knitr'), repos = 'https://cloud.r-project.org')"

COPY . /srv/shiny-server

EXPOSE 3838

CMD ["R", "-e", "setwd('/srv/shiny-server'); shiny::runApp('app.R', host = '0.0.0.0', port = 3838)"]
