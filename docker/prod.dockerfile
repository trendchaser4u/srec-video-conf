# Build OpenVidu Call for production
FROM node:lts-alpine3.12 as srec-video-conf-build

WORKDIR /srec-video-conf

ARG BRANCH_NAME=master
ARG BASE_HREF=/

RUN apk add wget unzip

# Download srec-video-conf from specific branch (master by default), intall openvidu-browser and build for production
RUN wget "https://github.com/trendchaser4u/srec-video-conf/archive/${BRANCH_NAME}.zip" -O srec-video-conf.zip && \
    unzip srec-video-conf.zip && \
    rm srec-video-conf.zip && \
    mv srec-video-conf-${BRANCH_NAME}/srec-front/ . && \
    mv srec-video-conf-${BRANCH_NAME}/srec-back/ . && \
    mv srec-video-conf-${BRANCH_NAME}/docker/ . && \
    rm srec-front/package-lock.json && \
    rm srec-back/package-lock.json && \
    rm -rf srec-video-conf-${BRANCH_NAME} && \
    # Install srec-front dependencies and build it for production
    npm i --prefix srec-front && \
    npm run build-prod ${BASE_HREF} --prefix srec-front && \
    rm -rf srec-front && \
    # Install srec-back dependencies and build it for production
    npm i --prefix srec-back && \
    npm run build-prod --prefix srec-back && \
    mv srec-back/dist . && \
    rm -rf srec-back


FROM node:lts-alpine3.11

WORKDIR /opt/srec-video-conf

COPY --from=srec-video-conf-build /srec-video-conf/dist .
# Entrypoint
COPY --from=srec-video-conf-build /srec-video-conf/docker/entrypoint.sh /usr/local/bin
RUN apk add curl && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    npm install -g nodemon

# CMD /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]
