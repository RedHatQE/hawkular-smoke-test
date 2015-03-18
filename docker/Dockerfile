FROM hawkular/docker-maven
MAINTAINER Matt Mahoney <mmahoney@redhat.com> USER root

ENV PATH .:$PATH
RUN echo "root:redhat" | chpasswd
RUN yum -y install wget git openssh-server httpd supervisor ant

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

RUN printf "\n[supervisord]\nnodaemon=true\n\
[program:sshd]\ncommand=/bin/bash -c /usr/sbin/sshd\n\
[program:httpd]\ncommand=/bin/bash -c /usr/sbin/httpd\n" >> /etc/supervisord.conf
RUN printf "\n[program:hawkuklar-test]\ncommand=/bin/bash -x /home/hudson/start.sh\n" >> /etc/supervisord.conf

EXPOSE 22 80

USER hudson
WORKDIR /home/hudson

ENV PATH .:$PATH
RUN git clone https://github.com/RedHatQE/hawkular-smoke-test.git
#RUN git clone https://github.com/redhatqe/hawkular-rest-test
#RUN cd /home/hudson/hawkular-rest-test; mvn clean install -DskipTests

# Install JMeter
RUN cd /home/hudson; git clone https://github.com/apache/jmeter.git; cd jmeter; ant download_jars; ant

# Script Run tests
RUN printf "\
cd /home/hudson/hawkular-smoke-test/tests;\n\
testRunner.sh > /var/www/html/hawkular-test-results/hawkular-test-results.txt\n\
" >> /home/hudson/start.sh

RUN chmod 766 /home/hudson/start.sh

USER root
WORKDIR /home/hudson
CMD ["/usr/bin/supervisord"]

