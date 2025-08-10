#!/bin/bash
set -eo pipefail

MOUNT_DIR=/opt/dramhit
NIX_DAEMON_VARS="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
USER=$(id -u -n)
GROUP=$(id -g -n)

prepare_machine() {
  sudo mkfs.ext4 -Fq /dev/nvme1n1
  sudo mkdir -p ${MOUNT_DIR}
  sudo mount -t ext4 /dev/nvme1n1 ${MOUNT_DIR}
  sudo chown -R ${USER}:${GROUP} ${MOUNT_DIR}

  sudo mkdir -p /nix
  sudo cp -r /nix ${MOUNT_DIR}
  sudo mount --bind ${MOUNT_DIR}/nix /nix

  sh <(curl -L https://nixos.org/nix/install) --daemon
  source ${NIX_DAEMON_VARS}
  nix-channel --list
}

clone_repos() {
  mkdir -p ${MOUNT_DIR}
  pushd ${MOUNT_DIR}
  git clone https://github.com/mars-research/dramhit --recursive
  popd
}

build_all() {
  pushd ${MOUNT_DIR}/dramhit
  nix-shell --command "mkdir -p build && cd build; cmake .. && make -j $(nproc)"
  popd
}

setup_system() {
  sudo ${MOUNT_DIR}/dramhit/scripts/min-setup.sh
  sudo ln -sf $(which nix-store) /usr/local/bin/nix-store
}

prepare_machine
clone_repos
build_all
setup_system
