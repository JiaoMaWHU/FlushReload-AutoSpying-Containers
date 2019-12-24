FROM ubuntu:18.04
COPY ./FlushReload-AutoSpying-Containers /FlushReload-AutoSpying-Containers
COPY ./links-2.13 /links-2.13
RUN apt-get update
RUN apt-get -y install build-essential libelf-dev ruby ruby-dev links libssl-dev
RUN gem install levenshtein-ffi parallel gnuplot colorize graphviz
RUN cd links-2.13 && \
        ./configure && \
        make && \
        cp links /FlushReload-AutoSpying-Containers/experiments/links/binaries/links-demo && \
        cd /FlushReload-AutoSpying-Containers/flush-reload/myversion && \
        make
