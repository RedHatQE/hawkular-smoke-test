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

# Install JMeter
RUN cd /home/hudson; git clone https://github.com/apache/jmeter.git; cd jmeter; ant download_jars; ant

# Install Hakular Sauce Labs tests
RUN git clone https://github.com/ahovsepy/hawkular-ui-test.git
RUN cd hawkular-ui-test; mvn clean install -DskipTests
RUN printf "1=firefox:24.0:Linux" > /home/hudson/hawkular-ui-test/src/test/resources/browserAndOs.properties

# Script Run tests
RUN printf "\
sleep 2m;\n\
cd /home/hudson/hawkular-smoke-test/tests;\n\
testRunner.sh > /var/www/html/hawkular-test-results/script-test-results.txt;\n\
sleep 4m;\n\
cd /home/hudson/hawkular-ui-test;  mvn test -DhawkularUrl=\$IP; cp /home/hudson/hawkular-ui-test/target/surefire-reports/testng-results.xml /var/www/html/hawkular-test-results/ui-test-results.xml\n\
" >> /home/hudson/start.sh

RUN chmod 766 /home/hudson/start.sh

USER root
WORKDIR /home/hudson
CMD ["/usr/bin/supervisord"]

