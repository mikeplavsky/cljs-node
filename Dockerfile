FROM java:8

RUN apt-get update -y && \ 
    apt-get install --no-install-recommends -y \ 
    -q curl python build-essential git ca-certificates

RUN mkdir /nodejs && \
    curl http://nodejs.org/dist/v0.12.7/node-v0.12.7-linux-x64.tar.gz \ 
    | tar xvzf - -C /nodejs --strip-components=1

ENV PATH $PATH:/nodejs/bin

RUN apt-get install -y rlwrap

RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /bin/lein
RUN chmod a+x /bin/lein

ENV LEIN_ROOT=1
RUN lein

RUN lein new figwheel age
WORKDIR /age

RUN lein deps

WORKDIR /
RUN git clone https://github.com/mikeplavsky/figwheel-node-template.git


WORKDIR /figwheel-node-template
RUN lein jar
RUN lein install

RUN lein new figwheel-node age1 && \
    cd age1 && \
    lein deps

RUN rm -rf /age && rm -rf /figwheel-node-template

WORKDIR /


