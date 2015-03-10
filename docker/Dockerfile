FROM jboss/base-jdk:8

MAINTAINER Matt Mahoney <mmahoney@redhat.com>

USER root
RUN echo "root:redhat" | chpasswd
RUN yum -y install wget git openssh-server httpd supervisor

RUN groupadd hudson
RUN useradd -m -g hudson -s /bin/bash hudson
RUN echo "hudson:hudson" | chpasswd

RUN mkdir /var/run/sshd
RUN ssh-keygen -A
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

RUN mkdir -p /var/www/html/hawkular-test-results; chmod 777 /var/www/html/hawkular-test-results
RUN echo "Hawkular Test Results Directory" > /var/www/html/hawkular-test-results/Hawkular-README.txt
RUN printf "\n;Hawkular\n[program:sshd]\ncommand=/bin/bash -c /usr/sbin/sshd\n[program:httpd]\ncommand=/bin/bash -c "/usr/sbin/httpd -DFOREGROUND"\n" \\
    >> /etc/supervisord.conf

USER hudson

ENV PATH .:$PATH
RUN cd /home/hudson; git clone https://github.com/RedHatQE/hawkular-smoke-test.git

# Script 1) starts sshd and httpd (via supervisord), and then 2) run tests
RUN printf "\n/usr/bin/supervisord\ncd /home/hudson/hawkular-smoke-test/tests; testRunner.sh" > /home/hudson/runTests.sh; chmod 766 /home/hudson/runTests.sh
EXPOSE 22 80

# Install JMeter
# RUN cd /home/hudson; wget -r -l0 --no-parent -A .zip http://www.webhostingreviewjam.com/mirror/apache/jmeter/binaries/ ; \
# export H=`find . -name "apache-jmeter*.zip"`; /usr/bin/unzip $H -d /home/hudson ; chmod -R 766 /home/hudson/apache-jmeter*  ; \
# mv /home/hudson/apache-jmeter-* /home/hudson/apache-jmeter ; rm -rf /home/hudson/www.webhosting*

USER root
WORKDIR /home/hudson/hawkular-smoke-test/tests
CMD /bin/bash /home/hudson/hawkular-smoke-test/tests/testRunner.sh
#CMD /bin/bash /home/hudson/runTests.sh

