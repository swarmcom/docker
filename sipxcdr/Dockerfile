FROM ezuce/basecentos

USER root

COPY etc/sipxecx.repo /etc/yum.repos.d/

RUN yum install -y \
	ruby ruby-dbi ruby-devel rubygem-net-sftp rubygems ruby-libs ruby-postgres

COPY tmp/sipx/ /usr/local/sipx/

ENTRYPOINT ["/usr/local/sipx/bin/sipxcdr.sh"]
