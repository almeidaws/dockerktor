FROM ubuntu:xenial
RUN apt -y update

# Install OpenJDK and two more auxiliary programs
RUN apt-get install -y openjdk-8-jdk wget unzip

# Install Graddle
RUN wget https://services.gradle.org/distributions/gradle-5.2.1-bin.zip -P /tmp
RUN unzip -d /opt/gradle /tmp/gradle-*.zip
ENV GRADLE_HOME=/opt/gradle/gradle-5.2.1
ENV PATH=${GRADLE_HOME}/bin:${PATH}

# We define the user we will use in this instance to prevent using root that even in a container, can be a security risk.
ENV APPLICATION_USER ktor

# Then we add the user, create the /app folder and give permissions to our user.
RUN adduser -disabled-password -gecos '' $APPLICATION_USER
RUN mkdir /app
WORKDIR /app
RUN chown -R $APPLICATION_USER /app

# Marks this container to use the specified $APPLICATION_USER
USER $APPLICATION_USER