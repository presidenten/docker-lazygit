FROM alpine:3.11 as builder

RUN apk --update --no-cache --no-progress add \
      git \
      go

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin && \
    go get github.com/jesseduffield/lazygit

# -------------------------------------------

FROM alpine:3.11

ARG USER_NAME=user
ARG USER_UID=1001
ARG USER_GID=1001
ARG WORKSPACE_ROOT=/app

RUN apk --update --no-cache --no-progress add \
      bash \
      git \
      git-lfs \
      gnupg \
      openssh \
      sudo && \
    addgroup -S -g ${USER_GID} ${USER_NAME} && \
    adduser -D -u ${USER_UID} -G ${USER_NAME} ${USER_NAME} && \
    echo "${USER_NAME}:${USER_NAME}" | chpasswd && \
    addgroup -g 150 sudo && \
    addgroup ${USER_NAME} sudo && \
    sed -i 's/^# \(%sudo.*\)/\1/g' /etc/sudoers && \
    rm -rf /var/cache/apk/*

COPY --from=builder /root/go/bin/lazygit /usr/local/bin/lazygit
COPY run.sh /usr/local/bin/run.sh
COPY config.yml /home/${USER_NAME}/.config/jesseduffield/lazygit/config.yml

RUN mkdir -p /home/${USER_NAME}/.config/git && \
    mkdir -p ${WORKSPACE_ROOT} && \
    chown -R ${USER_NAME}:${USER_NAME} /app && \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.config && \
    chmod -R 777 ${WORKSPACE_ROOT} && \
    chmod -R 777 /home/${USER_NAME}/.config

WORKDIR ${WORKSPACE_ROOT}

USER ${USER_UID}

ENTRYPOINT ["run.sh"]
