FROM node:lts-alpine3.12

ARG RELEASE_VERSION=1.0.0

RUN apk add wget unzip

WORKDIR /opt/srec-video-conf

# Install srec-video-conf
RUN wget "https://github.com/trendchaser4u/srec-video-conf/releases/download/v${RELEASE_VERSION}/srec-video-conf-${RELEASE_VERSION}.tar.gz" -O srec-video-conf.tar.gz && \
    tar zxf srec-video-conf.tar.gz  && \
    rm srec-video-conf.tar.gz

# Entrypoint
COPY docker/entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    npm install -g nodemon

CMD /usr/local/bin/entrypoint.sh