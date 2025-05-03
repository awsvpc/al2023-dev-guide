# Setup Docker on Amazon Linux 2023

The following guide is for setting up Docker with docker-compose v2 on Amazon Linux 2023. The steps are intendend for AL2023 on EC2 but should mostly work for the AL2023 VMs running on other hypervisors.

## Overview of Updating Amazon Linux 2023

### Check for new updates

Get the hosts current Amazon Linux 2023 release:

```shell
rpm -q system-release --qf "%{VERSION}\n"
```

OR

```
cat /etc/amazon-linux-release
```

To find out the LATEST SYSTEM RELEASE of Amazon Linux 2023:

```shell
# You can use the following command to get more verbose output
sudo dnf check-release-update --refresh --latest-only --version-only
#sudo dnf check-release-update
```

To upgrade the Amazon Linux 2023 based host for the CURRENT SYSTEM RELEASE i.e. (`cat /etc/amazon-linux-release`):

```shell
sudo dnf check-update --refresh
sudo dnf upgrade --refresh
```

To upgrade the Amazon Linux 2023 based host to a SPECIFIC SYSTEM RELEASE:

```shell
sudo dnf check-update --refresh --releasever=2023.5.20240722
sudo dnf update --refresh --releasever=2023.5.20240722
```

To upgrade the Amazon Linux 2023 based host to the LATEST SYSTEM RELEASE:

```shell
sudo dnf check-update --refresh --releasever=latest
sudo dnf upgrade --refresh --releasever=latest
```

Note: Using `sudo dnf upgrade --releasever=latest` updates all packages, including system-release. Then, the version remains locked to the new system-release unless you set the persistent override.

To permanently switch the host to always get the latest system release updates:

```shell
# This command only needs to be run once
sudo touch /etc/dnf/vars/releasever && echo 'latest' | sudo tee /etc/dnf/vars/releasever
```

Then it's just a matter of running the following commands to update via `latest`:

```shell
sudo dnf check-update --refresh
sudo dnf upgrade --refresh
```

To get more details about the current repos:

```shell
dnf repoinfo
dnf repolist all --verbose
```

## Install and configure Docker on Amazon Linux 2023

### Install Base OS Packages

Install the following packages, which are good to have installed:

```shell
sudo dnf install --allowerasing -y \
  kernel-modules-extra \
  dnf-plugins-core \
  dnf-plugin-release-notification \
  dnf-plugin-support-info \
  dnf-utils \
  git-core \
  git-lfs \
  grubby \
  kexec-tools \
  chrony \
  audit \
  dbus \
  dbus-daemon \
  polkit \
  systemd-pam \
  systemd-container \
  udisks2 \
  crypto-policies \
  crypto-policies-scripts \
  openssl \
  nss-util \
  nss-tools \
  dmidecode \
  nvme-cli \
  lvm2 \
  dosfstools \
  e2fsprogs \
  xfsprogs \
  xfsprogs-xfs_scrub \
  attr \
  acl \
  shadow-utils \
  shadow-utils-subid \
  fuse3 \
  squashfs-tools \
  star \
  gzip \
  pigz \
  bzip2 \
  zstd \
  xz \
  unzip \
  p7zip \
  numactl \
  iproute \
  iproute-tc \
  iptables-nft \
  nftables \
  conntrack-tools \
  ipset \
  ethtool \
  net-tools \
  iputils \
  traceroute \
  mtr \
  telnet \
  whois \
  socat \
  bind-utils \
  tcpdump \
  cifs-utils \
  nfsv4-client-utils \
  nfs4-acl-tools \
  libseccomp \
  psutils \
  python3 \
  python3-pip \
  python3-psutil \
  python3-policycoreutils \
  policycoreutils-python-utils \
  bash-completion \
  vim-minimal \
  wget \
  jq \
  awscli-2 \
  ec2rl \
  ec2-utils \
  htop \
  sysstat \
  fio \
  inotify-tools \
  rsync
```

### (Optional) Remove EC2 Hibernation Agent

Run the following command to remove the EC2 Hibernation Agent:

```shell
sudo dnf remove -y ec2-hibinit-agent
```

### (Optional) Install EC2 Instance Connect Utility

```shell
sudo dnf install --allowerasing -y ec2-instance-connect ec2-instance-connect-selinux
```

### (Optional) Install Smart-Restart Utility

Amazon Linux now ships with the [smart-restart](https://github.com/amazonlinux/smart-restart) package, which the smart-restart utility restarts systemd services on system updates whenever a package is installed or deleted using the systems package manager. This occurs whenever a `dnf <update|upgrade|downgrade>` is executed.

The smart-restart uses the needs-restarting from the dnf-utils package and a custom denylisting mechanism to determine which services need to be restarted and whether a system reboot is advised. If a system reboot is advised, a reboot hint marker file is generated (/run/smart-restart/reboot-hint-marker).

```shell
sudo dnf install --allowerasing -y smart-restart python3-dnf-plugin-post-transaction-actions
```

After the installation, the subsequent transactions will trigger the smart-restart logic.

- https://docs.aws.amazon.com/linux/al2023/ug/managing-repos-os-updates.html#automatic-restart-services

### (Optional) Enable Kernel Live Patching (KLP)

Run the following command to install the kernel live patching feature:

```shell
sudo dnf install --allowerasing -y kpatch-dnf kpatch-runtime
```

Enable the service:

```shell
sudo dnf kernel-livepatch -y auto
sudo systemctl daemon-reload
sudo systemctl enable --now kpatch.service
```

### (Optional) Install Amazon EFS Utils

```shell
sudo dnf install --allowerasing -y amazon-efs-utils
```

### (Optional) Enable FIPS Mode on the Host

This step is safe to skip as it will only apply to specific end user environments. I would recommend reading into FIPS compliance, validation and certification before enabling FIPS mode on EC2 instances.

- https://docs.aws.amazon.com/linux/al2023/ug/fips-mode.html

```shell
sudo dnf install --allowerasing -y crypto-policies crypto-policies-scripts
```

```shell
sudo fips-mode-setup --check
sudo fips-mode-setup --enable
sudo fips-mode-setup --check
```

```shell
sudo systemctl reboot
```

### (Optional) Setup Amazon SSM Agent

Install the Amazon SSM Agent:

```shell
sudo dnf install --allowerasing -y amazon-ssm-agent
```

The following is a tweak, which should resolve the following reported issue.

- https://repost.aws/questions/QU_tj7NQl6ReKoG53zzEqYOw/amazon-linux-2023-issue-with-installing-packages-with-cloud-init
- https://github.com/amazonlinux/amazon-linux-2023/issues/397

Add the following drop-in to make sure networking is up, dns resolution works and cloud-init has finished before the amazon ssm agent is started.

```shell
sudo mkdir -pv /etc/systemd/system/amazon-ssm-agent.service.d

cat <<'EOF' | sudo tee /etc/systemd/system/amazon-ssm-agent.service.d/00-override.conf
[Unit]
# To have a service start after cloud-init.target it requires the
# addition of DefaultDependencies=no due to the following default
# DefaultDependencies=y, which results in the default target e.g.
# multi-user.target to depending on the service.
#
# See the follow for more details: https://serverfault.com/a/973985
Wants=network-online.target
After=network-online.target nss-lookup.target cloud-init.target
DefaultDependencies=no
ConditionFileIsExecutable=/usr/bin/amazon-ssm-agent

EOF
```

```shell
sudo systemctl daemon-reload
sudo systemctl enable --now amazon-ssm-agent.service
sudo systemctl try-reload-or-restart amazon-ssm-agent.service
sudo systemctl status amazon-ssm-agent.service
```

Verify:

```shell
systemd-delta --type=extended
systemctl show amazon-ssm-agent --all
# systemctl show <unit>.service --property=<PROPERTY_NAME>
# systemctl show <unit>.service --property=<PROPERTY_NAME1>,<PROPERTY_NAME2>
systemctl show amazon-ssm-agent.service --property=After,Wants
```


- https://ubuntu.com/blog/cloud-init-v-18-2-cli-subcommands

### (Optional) Install and setup the Unified CloudWatch Agent

Install the Unified CloudWatch Agent:

```shell
sudo dnf install --allowerasing -y amazon-cloudwatch-agent collectd
```

Add the following drop-in to make sure networking is up, dns resolution works and cloud-init has finished before the unified cloudwatch agent is started.

```shell
sudo mkdir -pv /etc/systemd/system/amazon-cloudwatch-agent.d

cat <<'EOF' | sudo tee /etc/systemd/system/amazon-cloudwatch-agent.d/00-override.conf
[Unit]
# To have a service start after cloud-init.target it requires the
# addition of DefaultDependencies=no due to the following default
# DefaultDependencies=y, which results in the default target e.g.
# multi-user.target depending on the service.
#
# See the follow for more details: https://serverfault.com/a/973985
Wants=network-online.target
After=network-online.target nss-lookup.target cloud-init.target
DefaultDependencies=no
ConditionFileIsExecutable=/opt/aws/amazon-cloudwatch-agent/bin/start-amazon-cloudwatch-agent

EOF
```

```shell
sudo systemctl daemon-reload
sudo systemctl enable --now amazon-cloudwatch-agent.service
sudo systemctl try-reload-or-restart amazon-cloudwatch-agent.service
sudo systemctl status amazon-cloudwatch-agent.service
```

The current version of the `CloudWatchAgentServerPolicy`:

```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "cloudwatch:PutMetricData",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeTags",
                    "logs:PutLogEvents",
                    "logs:DescribeLogStreams",
                    "logs:DescribeLogGroups",
                    "logs:CreateLogStream",
                    "logs:CreateLogGroup"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ssm:GetParameter"
                ],
                "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
            }
        ]
    }
```

### (Optional) Install Ansible

Run the following to install ansible on the host:

```shell
sudo dnf install -y \
  python3-psutil \
  ansible \
  ansible-core \
  sshpass
```

### Configure sane defaults for the OS

Configure the locale:

```shell
sudo localectl set-locale LANG=en_US.UTF-8
```

Verify:

```shell
localectl
```

Configure the hostname:

```shell
sudo hostnamectl set-hostname --static <hostname>
sudo hostnamectl set-chassis vm
```

Verify:

```shell
hostnamectl
```

Set the system timezone to UTC and ensure chronyd is enabled and started:

```shell
sudo systemctl enable --now chronyd
```

```shell
sudo timedatectl set-timezone Etc/UTC
sudo timedatectl set-ntp true
```

Verify:

```shell
timedatectl
```

Configure logging:

```shell
sudo mkdir -pv /etc/systemd/journald.conf.d

cat <<'EOF' | sudo tee /etc/systemd/journald.conf.d/00-override.conf
[Journal]
SystemMaxUse=100M
RuntimeMaxUse=100M
RuntimeMaxFileSize=10M
RateLimitInterval=1s
RateLimitBurst=10000

EOF

sudo systemctl daemon-reload
sudo systemctl try-reload-or-restart systemd-journald.service
sudo systemctl status systemd-journald.service
```

Configure custom MOTD banner:

```shell
# Disable the AL2023 MOTD banner (found at /usr/lib/motd.d/30-banner):
sudo ln -s /dev/null /etc/motd.d/30-banner
cat <<'EOF' | sudo tee /etc/motd.d/31-banner
   ,     #_
   ~\_  ####_
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   Amazon Linux 2023 (Docker Optimized)
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
EOF
```

AL2023 uses pam-motd, see: http://www.linux-pam.org/Linux-PAM-html/sag-pam_motd.html


### Configure a sane user environment for the current user e.g. ec2-user

```shell
touch ~/.{profile,bashrc,bash_profile,bash_login,bash_logout,hushlogin}

mkdir -pv "${HOME}"/bin
mkdir -pv "${HOME}"/.config/{systemd,environment.d}
mkdir -pv "${HOME}"/.config/systemd/user/sockets.target.wants
mkdir -pv "${HOME}"/.local/share/systemd/user
mkdir -pv "${HOME}"/.local/bin
```

```shell
#cat <<'EOF' | tee ~/.config/environment.d/environment_vars.conf
#PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
#
#EOF
```

```shell
sudo loginctl enable-linger $(whoami)
systemctl --user daemon-reload
```

Note: If you need to switch to root user, use the following instead of `sudo su - <user>`.

```shell
# sudo machinectl shell <username>@
sudo machinectl shell root@
```

### Install and configure Moby aka Docker on the host

Run the following command to install moby aka docker:

```shell
sudo dnf install --allowerasing -y \
  docker \
  containerd \
  runc \
  container-selinux \
  cni-plugins \
  oci-add-hooks \
  amazon-ecr-credential-helper \
  udica
```

Add the current user e.g. `ec2-user` to the docker group:

```shell
sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker
```

Configure the following docker daemon settings:

```shell
test -d /etc/docker || sudo mkdir -pv /etc/docker

test -f /etc/docker/daemon.json || cat <<'EOF' | sudo tee /etc/docker/daemon.json
{
  "debug": false,
  "experimental": false,
  "exec-opts": ["native.cgroupdriver=systemd"],
  "userland-proxy": false,
  "live-restore": true,
  "log-level": "warn",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF
```

- https://docs.docker.com/reference/cli/dockerd/#daemon-configuration-file
- https://docs.docker.com/config/containers/logging/awslogs/

Enable and start the docker and containerd service(s):

```shell
sudo systemctl enable --now docker.service containerd.service
sudo systemctl status docker containerd
```

### Install the Docker Compose v2 CLI Plugin

Install the Docker Compose plugin with the following commands.

To install the docker compose plugin for all users:

```shell
sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -sL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-"$(uname -m)" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

# Set ownership to root and make executable
test -f /usr/local/lib/docker/cli-plugins/docker-compose \
  && sudo chown root:root /usr/local/lib/docker/cli-plugins/docker-compose
test -f /usr/local/lib/docker/cli-plugins/docker-compose \
  && sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```

(Optional) To install only for the local user e.g. `ec2-user`, run the following commands:

```shell
mkdir -p "${HOME}/.docker/cli-plugins" && touch "${HOME}/.docker/config.json"
curl -sL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-"$(uname -m)" \
  -o "${HOME}/.docker/cli-plugins/docker-compose"

cat <<'EOF' | tee -a "${HOME}/.bashrc"

# https://specifications.freedesktop.org/basedir-spec/latest/index.html
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS 

# Docker
DOCKER_TLS_VERIFY=1
#DOCKER_CONFIG=/usr/local/lib/docker
DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
export DOCKER_CONFIG DOCKER_TLS_VERIFY
#DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
#export DOCKER_HOST

EOF
```

Verify the plugin is installed correctly with the following command(s):

```shell
docker compose version
```

### (Optional) Install the Docker Scout Plugin

(Optional) Install docker scout with the following commands:

```shell
curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s --
chmod +x $HOME/.docker/scout/docker-scout
```

- https://github.com/docker/scout-cli

### (Skip) Install the Docker Buildx Plugin

**Note: You can safely skip this step as it should not be necessary due to the version of Moby shipped in AL2023 bundling the buildx plugin by default.**

(Optional) Install the docker buildx plugin with the following commands:

```shell
sudo curl -sSfL 'https://github.com/docker/buildx/releases/download/v0.14.0/buildx-v0.14.0.linux-amd64' \
  -o /usr/local/lib/docker/cli-plugins/docker-buildx

#sudo curl -sL https://github.com/docker/compose/releases/latest/download/docker-buildx-linux-"$(uname -m)" \
#  -o /usr/local/lib/docker/cli-plugins/docker-buildx

# Set ownership to root and make executable
test -f /usr/local/lib/docker/cli-plugins/docker-buildx \
  && sudo chown root:root /usr/local/lib/docker/cli-plugins/docker-buildx
test -f /usr/local/lib/docker/cli-plugins/docker-buildx \
  && sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

cp /usr/local/lib/docker/cli-plugins/docker-buildx "${HOME}/.docker/cli-plugins/docker-buildx"

docker buildx install
```

- https://github.com/docker/buildx

### (Optional) Install the EC2 Nitro Enclave CLI tool

This is mostly optional if needed, otherwise you can just skip this one.

```shell
sudo dnf install --allowerasing -y aws-nitro-enclaves-cli aws-nitro-enclaves-cli-devel
```

Add teh user to the `ne` group:

```shell
sudo groupadd ne
sudo usermod -aG ne $USER
sudo newgrp ne
```

Enable and start the service:

```shell
sudo systemctl enable --now nitro-enclaves-allocator.service
```

- https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave-cli-install.html
- https://github.com/aws/aws-nitro-enclaves-cli


### (Optional) Install the Nvidia Drivers

To install the Nvidia drivers:

```shell
sudo dnf install -y wget kernel-modules-extra kernel-devel gcc dkms
```

Add the Nvidia Driver and CUDA repository:

```shell
sudo dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/amzn2023/x86_64/cuda-amzn2023.repo
sudo dnf clean expire-cache
```

Install the Nvidia driver + CUDA toolkit from the Nvidia repo:

```
sudo dnf module install -y nvidia-driver:latest-dkms
sudo dnf install -y cuda-toolkit
```

(Alternative) Download the driver install script and run it to install the nvidia drivers:

```shell
curl -sL 'https://us.download.nvidia.com/tesla/535.161.08/NVIDIA-Linux-x86_64-535.161.08.run' -O
sudo sh NVIDIA-Linux-x86_64-535.161.08.run -a -s --ui=none -m=kernel-open
```

Verify:

```
nvidia-smi
```

For the Nvidia container runtime, add the nvidia container repo:

```shell
curl -sL 'https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo' | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
sudo dnf clean expire-cache
sudo dnf check-update
```

Install and configure the `nvidia-container-toolkit`:

```shell
sudo dnf install -y nvidia-container-toolkit
```

```shell
sudo nvidia-ctk runtime configure --runtime=docker
```

Restart the docker and containerd services:

```shell
sudo systemctl restart docker containerd
```

To create an Ubuntu based container with access to the host GPUs:

```shell
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

```shell
docker run --rm --runtime=nvidia --gpus all public.ecr.aws/amazonlinux/amazonlinux:2023 nvidia-smi
```

### (Optional) Configure the aws-cli for the ec2-user

```shell
# configure region
aws configure set default.region $(curl --noproxy '*' -w "\n" -s -H "X-aws-ec2-metadata-token: $(curl --noproxy '*' -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
# use regional endpoints
aws configure set default.sts_regional_endpoints regional
# get credentials from imds
aws configure set default.credential_source Ec2InstanceMetadata
# get credentials last for 1hr
aws configure set default.duration_seconds 3600
# set default pager
aws configure set default.cli_pager ""
# set output to json
aws configure set default.output json
```

Verify:

```shell
aws configure list
aws sts get-caller-identity
```

### (Optional) Create your first Amazon Linux 2023 based container(s)

Login to the AWS ECR service:

```shell
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
```

To create an AL2023 based container:

```shell
docker pull public.ecr.aws/amazonlinux/amazonlinux:2023
docker run -it --security-opt seccomp=unconfined public.ecr.aws/amazonlinux/amazonlinux:2023 /bin/bash
```
