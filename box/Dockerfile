#
# WARP
# Development Environment
# Dockerfile
#

FROM ubuntu:24.04

# create non-root user
ARG USER=mrzzy
# delete default user
RUN userdel -r ubuntu && \
    groupadd --gid 1000 ${USER} && \
    useradd --uid 1000 --gid ${USER} --create-home ${USER}

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
COPY ansible/roles/user /tmp/ansible/roles/user
ENV ANSIBLE_STDOUT_PLUGIN=yaml ANSIBLE_HOME=/home/${USER}/.ansible
RUN ansible-playbook -v /tmp/ansible/system.yaml --connection=local --inventory localhost, && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* ${ANSIBLE_HOME}/tmp

# deploy user playbook
USER ${USER}
COPY ansible /tmp/ansible
RUN ansible-playbook -v /tmp/ansible/user.yaml --connection=local --inventory localhost, && \
    rm -rf /home/${USER}/.cache /home/${USER}/.npm/_cacache \
        /home/${USER}/.asdf/installs/rust/*/toolchains/*/share/doc

# copy ssh key
RUN mkdir -p /home/${USER}/.ssh
COPY id_ed25519.pub /home/${USER}/.ssh/authorized_keys
USER root
RUN chown -R ${USER}:${USER} /home/${USER}/.ssh && \
    chmod 700 /home/${USER}/.ssh && \
    chmod 600 /home/${USER}/.ssh/authorized_keys

# supervisord
# create directoryh expected by sshd
RUN mkdir -p /run/sshd
COPY supervisord.conf /etc/supervisord.conf
CMD [ "supervisord", "-c", "/etc/supervisord.conf" ]
