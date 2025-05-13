#
# WARP
# Entrypoint Script
#
#!/bin/bash

# merge deploy directories to original locations
# since they are potentially volume mounted, we chown to ensure permissions remain accessible
sudo chown -R $(id -u):$(id -g) ${HOME}/.config && cp -arf ${HOME}/.deploy/.config/ -t ${HOME} || echo "Failed to restore ~/.config"
sudo chown -R $(id -u):$(id -g) ${HOME}/.local/share && cp -arf ${HOME}/.deploy/share/ -t ${HOME}/.local || echo "Failed to restore ~/.local/share"

exec "$@"
