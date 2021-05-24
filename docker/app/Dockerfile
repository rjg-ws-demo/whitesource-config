# Pull centos base image
FROM centos:7

# Install Java 8
RUN yum -y install java-1.8.0-openjdk \
  && yum clean all


# copy folder
COPY docker-image/ /
RUN chmod +x /start.sh

# Expose ports
# HTTP
EXPOSE 5678

# home directory
ENV HOME=/etc/usr/local/whitesource
ENV WHITESOURCE_HOME=$HOME
ENV BOLT4SCM_HOME=$HOME/bolt4scm
#ENV BOLT4SCM_HOME=/home/centos/bolt4scm/config
#ENV LOG_COLLECTOR_SERVER 192.168.1.102

RUN useradd -u 1542 -r -c "Docker image user" -d $HOME whitesource && \
chmod -R ugo+rw $HOME

USER whitesource

ENTRYPOINT ["/start.sh"]
