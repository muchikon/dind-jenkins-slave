FROM ubuntu
#ADD file:e97fe9bddafcfac4ca966c9cc2bab9526cc3f722df71710f4b7c6349de2db82b in /
RUN /bin/sh -c echo '#!/bin/sh' > /usr/sbin/policy-rc.d         \
    && echo 'exit 101' >> /usr/sbin/policy-rc.d         \
    && chmod +x /usr/sbin/policy-rc.d           \
    && dpkg-divert --local --rename --add /sbin/initctl         \
    && cp -a /usr/sbin/policy-rc.d /sbin/initctl        \
    && sed -i 's/^exit.*/exit 0/' /sbin/initctl                 \
    && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup                 \
    && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || tr>
    && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bi>
    && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean          \
    && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages              \
    && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes
#RUN /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
RUN sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
CMD ["/bin/bash"]
MAINTAINER Victor Muchica <vmuchica@outlook.com>
#RUN /bin/sh -c apt-get update \
RUN apt-get update \
    &&    apt-get install -y openssh-server curl \
    &&    apt-get clean -y \
    &&    rm -rf /var/lib/apt/lists/* \
    &&    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    &&    mkdir -p /var/run/sshd
RUN adduser --disabled-password jenkins \
    &&    echo "jenkins:jenkins" | chpasswd
RUN curl -sSL https://get.docker.com/ | sh
RUN apt-get update \
    &&    apt-get install -y openjdk-8-jdk git \
    &&    apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
EXPOSE 22/tcp
CMD ["/usr/sbin/sshd" "-D"]
