#
# WARP
# Development Environment
# Dockerfile
#

FROM ubuntu:24.04

# non-root user
ARG USER=ubuntu

# install ansible
RUN apt-get update && \
    apt-get install --no-install-recommends -y ansible git sudo ca-certificates supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/lib/python3/dist-packages/ansible_collections

# install ansible collections
USER ${USER}
COPY ansible/requirements.yaml /tmp/ansible/requirements.yaml
RUN ansible-galaxy install -r /tmp/ansible/requirements.yaml -v

# deploy ansible playbooks
# deploy system playbook
USER root
COPY ansible/system.yaml ansible/vars.yaml /tmp/ansible/
COPY ansible/roles/system /tmp/ansible/roles/system
COPY ansible/roles/user /tmp/ansible/roles/user
ENV ANSIBLE_STDOUT_CALLBACK=yaml ANSIBLE_HOME=/home/${USER}/.ansible
RUN ansible-playbook -v /tmp/ansible/system.yaml \
    -e "devbox_user=${USER}" \
    --connection=local \
    --inventory localhost, && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* ${ANSIBLE_HOME}/tmp

# deploy user playbook
USER ${USER}
ENV USER=${USER}
ENV HOME=/home/${USER}
WORKDIR ${HOME}
COPY ansible /tmp/ansible
RUN ansible-playbook -v /tmp/ansible/user.yaml \
    -e "devbox_user=${USER}" \
    --connection=local \
    --inventory localhost, && \
    rm -rf ${HOME}/.cache ${HOME}/.npm/_cacache \
        ${HOME}/.asdf/installs/rust/*/toolchains/*/share/doc && \
    # many applications persist their data in .config (XDG_CONFIG_DIR) & ~/.local/share (XDG_DATA_DIR)
    # shift .config and ~/.local/share allow volumes to be mounted at those folders
    # and copy them back using the entrypoint.sh script
    mkdir -p ${HOME}/.deploy && \
        mv ${HOME}/.config ${HOME}/.deploy/.config && \
        mv ${HOME}/.local/share ${HOME}/.deploy/share
# replace moved directories
RUN mkdir -p ${HOME}/.config ${HOME}/.local/share

# copy ssh key
RUN mkdir -p ${HOME}/.ssh
COPY --chown=${USER}:${USER} id_ed25519.pub ${HOME}/.ssh/authorized_keys
RUN chmod 700 ${HOME}/.ssh && \
    chmod 600 ${HOME}/.ssh/authorized_keys

# create directory expected by sshd
USER root
RUN mkdir -p /run/sshd
COPY supervisord.conf /etc/supervisord.conf

# run services with supervisord
EXPOSE 22
EXPOSE 7681
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
