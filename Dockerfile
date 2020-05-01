#download base OS
FROM ubuntu:18.04

#update ubuntu repository and install
RUN apt-get update && \
echo Y | apt-get install openssh-server openssh-client vim ufw iptables

#jdk binaries
COPY ./jdk-8u251-linux-x64.tar.gz ./opt

#extract jdk binaries
RUN cd /opt && \
tar -xzf jdk-8u251-linux-x64.tar.gz

#run JAVA environment
RUN update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_251/bin/java 100 && \
update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_251/bin/javac 100 && \
java -version

#hadoop directory
WORKDIR /home

#hadoop binaries
COPY ./hadoop-3.2.1.tar.gz ./

#extract hadoop binaries
RUN tar -xzf hadoop-3.2.1.tar.gz && \
mv hadoop-3.2.1 hadoop

#copy xml config file
COPY ./*.xml ./hadoop/etc/hadoop/
COPY ./hadoop-env.sh ./hadoop/etc/hadoop/

#remove binaries
RUN rm -rf hadoop-3.2.1.tar.gz && \
rm -rf /opt/jdk-8u251-linux-x64.tar.gz

RUN echo 'export HADOOP_HOME=/home/hadoop' >> ~/.bashrc && \
echo 'export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin' >> ~/.bashrc
