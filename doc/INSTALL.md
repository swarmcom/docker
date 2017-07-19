How to Install
==============

CentOS 7
========

Post-Installation steps CentOS 7
--------------------------------

- IP forwarding (allow packets arriving on your externally-listening interface to be forwarded (or routed) to the docker interface that all of your containers are attached to). Edit /etc/sysctl.conf :

   - `net.ipv4.ip_forward=1`
   - `systemctl restart network`

- Disable SELinux CentOS7 :

   Edit /etc/selinux/config
   `_SELINUX=disabled_` (reboot required)   

Install Docker
--------------

   - `cd /etc/yum.repos.d/`
   - Create a `docker.repo` file with:
     ```sh
     [docker-ce-stable]
     name=Docker CE Stable - $basearch
     baseurl=https://download.docker.com/linux/centos/7/$basearch/stable
     enabled=1
     gpgcheck=1
     gpgkey=https://download.docker.com/linux/centos/gpg
     ```

Next steps
----------

- systemctl start docker   
- Install git to the working directory: `yum install git`
- 	`git clone https://github.com/swarmcom/docker.git`
- Required to access Reach Private Repository - token can be found in Git-> Account Settings -> Personal Access Tokens
  Add following to ~/.bashrc
  `export TOKEN=$GITHUB_ACCESS_TOKEN`
- Exit shell & re-enter
- Run build.sh script in docker folder
- Run run.sh in docker folder
- Add the resulting ip addresses to /etc/hosts

