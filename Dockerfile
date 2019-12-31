FROM ubuntu:xenial
RUN apt -y update

# Download OpenJDK
RUN apt install -y openjdk-8-jdk

# Download Gradle
RUN apt install -y wget
RUN wget https://services.gradle.org/distributions/gradle-5.2.1-bin.zip -P /tmp
RUN apt install -y unzip
RUN unzip -d /opt/gradle /tmp/gradle-*.zip

# Set environment variables
ENV GRADLE_HOME=/opt/gradle/gradle-5.2.1
ENV PATH=${GRADLE_HOME}/bin:${PATH}

# We define the user we will use in this instance to prevent using root that even in a container, can be a security risk.
ENV APPLICATION_USER ktor

# Then we add the user, create the /app folder and give permissions to our user.
RUN adduser -disabled-password -gecos '' $APPLICATION_USER
RUN mkdir /app
WORKDIR /app
RUN chown -R $APPLICATION_USER /app
COPY ./start.sh ./start.sh
RUN chmod o=rx ./start.sh

# Marks this container to use the specified $APPLICATION_USER
USER $APPLICATION_USER
