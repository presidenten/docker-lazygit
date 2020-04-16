FROM alpine:3.11 as builder
LABEL maintainer "Takashi Makimoto <mackie@beehive-dev.com>"

RUN apk --update --no-cache --no-progress add \
      git \
      go

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin && \
    go get github.com/jesseduffield/lazygit


FROM alpine:3.11
LABEL maintainer "Takashi Makimoto <mackie@beehive-dev.com>"

ARG USER_NAME=mackie
ARG USER_ID=1000
ARG WORKSPACE_ROOT=workspace

RUN apk --update --no-cache --no-progress add \
      bash \
      git \
      git-lfs \
      gnupg \
      openssh \
      sudo && \
    adduser -D -u ${USER_ID} ${USER_NAME} ${USER_NAME} && \
    echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
    addgroup -g 150 sudo && \
    addgroup ${USER_NAME} sudo && \
    sed -i 's/^# \(%sudo.*\)/\1/g' /etc/sudoers && \
    rm -rf /var/cache/apk/*

COPY --from=builder /root/go/bin/lazygit /usr/local/bin/lazygit
COPY run.sh /usr/local/bin/run.sh
COPY config.yml /home/${USER_NAME}/.config/jesseduffield/lazygit/config.yml

RUN chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.config

USER ${USER_ID}
WORKDIR /home/${USER_NAME}

RUN mkdir -p /home/${USER_NAME}/.config/git

WORKDIR /home/${USER_NAME}/workspace

ENTRYPOINT ["run.sh"]
