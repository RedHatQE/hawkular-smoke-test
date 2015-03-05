FROM jboss/base-jdk:8

MAINTAINER Matt Mahoney <mmahoney@redhat.com>

USER root
RUN echo "root:redhat" | chpasswd
RUN yum -y install wget git openssh-server

RUN groupadd hudson
RUN useradd -m -g hudson -s /bin/bash hudson
RUN echo "hudson:hudson" | chpasswd

RUN mkdir /var/run/sshd
RUN ssh-keygen -A
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
EXPOSE 22
RUN /usr/sbin/sshd -D &

USER hudson

ENV PATH .:$PATH
RUN cd /home/hudson; git clone https://github.com/RedHatQE/hawkular-smoke-test.git

# Install JMeter
RUN cd /home/hudson; wget -r -l0 --no-parent -A .zip http://www.webhostingreviewjam.com/mirror/apache/jmeter/binaries/ ; \
export H=`find . -name "apache-jmeter*.zip"`; /usr/bin/unzip $H -d /home/hudson ; chmod -R 766 /home/hudson/apache-jmeter*  ; \
mv /home/hudson/apache-jmeter-* /home/hudson/apache-jmeter ; rm -rf /home/hudson/www.webhosting*

WORKDIR /home/hudson/hawkular-smoke-test/tests
CMD /bin/bash /home/hudson/hawkular-smoke-test/tests/testRunner.sh
