# Build OpenVidu Call for production
FROM node:lts-alpine3.12 as openvidu-browser-build

WORKDIR /openvidu-browser

RUN apk add wget unzip

# Download openvidu-browser from master, compile and pack it
RUN wget "https://github.com/OpenVidu/openvidu/archive/master.zip" -O openvidu-browser.zip && \
    unzip openvidu-browser.zip openvidu-master/openvidu-browser/* && \
    rm openvidu-browser.zip && \
    mv openvidu-master/openvidu-browser/ . && \
    rm -rf openvidu-master && \
    npm i --prefix openvidu-browser && \
    npm run build --prefix openvidu-browser/ && \
    npm pack openvidu-browser/ && \
    rm -rf openvidu-browser

FROM node:lts-alpine3.11 as srec-video-conf-build

WORKDIR /srec-video-conf

ARG BRANCH_NAME=master
ARG BASE_HREF=/

COPY --from=openvidu-browser-build /openvidu-browser/openvidu-browser-*.tgz .

RUN apk add wget unzip

# Download srec-video-conf from specific branch (master by default), intall openvidu-browser and build for production
RUN wget "https://github.com/trendchaser4u/srec-video-conf/archive/${BRANCH_NAME}.zip" -O srec-video-conf.zip && \
    unzip srec-video-conf.zip && \
    rm srec-video-conf.zip && \
    mv srec-video-conf-${BRANCH_NAME}/srec-front/ . && \
    mv srec-video-conf-${BRANCH_NAME}/srec-back/ . && \
    rm srec-front/package-lock.json && \
    rm srec-back/package-lock.json && \
    rm -rf srec-video-conf-${BRANCH_NAME} && \
    # Install openvidu-browser in srec-video-conf
    npm i --prefix srec-front openvidu-browser-*.tgz && \
    # Install srec-front dependencies and build it for production
    npm i --prefix srec-front && \
    npm run build-prod ${BASE_HREF} --prefix srec-front && \
    rm -rf srec-front && \
    # Install srec-back dependencies and build it for production
    npm i --prefix srec-back && \
    npm run build --prefix srec-back && \
    mv srec-back/dist . && \
    rm -rf srec-back


FROM node:lts-alpine3.11

WORKDIR /opt/srec-video-conf

COPY --from=srec-video-conf-build /srec-video-conf/dist .
# Entrypoint
COPY docker/entrypoint.sh /usr/local/bin
RUN apk add curl && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    npm install -g nodemon

# CMD /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
