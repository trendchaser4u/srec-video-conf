# Build OpenVidu Call for production
FROM node:lts-alpine3.12 as srec-video-conf-build

WORKDIR /srec-video-conf

ARG BASE_HREF=/

RUN apk add wget

COPY . .

# Build openvidu call
RUN rm srec-front/package-lock.json && \
    rm srec-back/package-lock.json && \
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
