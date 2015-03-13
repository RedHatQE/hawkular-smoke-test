FROM hawkular/docker-maven
MAINTAINER Matt Mahoney <mmahoney@redhat.com> USER root

ENV PATH .:$PATH
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

RUN printf "\n[supervisord]\nnodaemon=true\n\
[program:sshd]\ncommand=/bin/bash -c /usr/sbin/sshd\n\
[program:httpd]\ncommand=/bin/bash -c /usr/sbin/httpd\n" >> /etc/supervisord.conf
RUN printf "\n[program:hawkuklar-test]\ncommand=/bin/bash /home/hudson/start.sh\n" >> /etc/supervisord.conf

EXPOSE 22 80

USER hudson
WORKDIR /home/hudson

ENV PATH .:$PATH
RUN git clone https://github.com/RedHatQE/hawkular-smoke-test.git
RUN git clone https://mattmahoneyrh@github.com/redhatqe/hawkular-rest-test

# Install JMeter
RUN cd /home/hudson; wget http://mirror.cc.columbia.edu/pub/software/apache//jmeter/binaries/apache-jmeter-2.12.zip ; \
/usr/bin/unzip apache-jmeter*.zip ; chmod -R 766 /home/hudson/apache-jmeter*  ; \
rm *.zip ; mv /home/hudson/apache-jmeter-* /home/hudson/apache-jmeter

# Script Run tests
RUN printf "\
cd /home/hudson/hawkular-smoke-test/tests;\n\
testRunner.sh > /var/www/html/hawkular-test-results/hawkular-test-results.txt\n\
cd /home/hudson/hawkular-rest-test; mvn test -DbaseUrl="$IP"; yes | cp -rf  ./target/surefire-reports/testng-results.xml /var/www/html/hawkular-test-results\
" >> /home/hudson/start.sh

RUN chmod 766 /home/hudson/start.sh

USER root
WORKDIR /home/hudson
CMD ["/usr/bin/supervisord"]

