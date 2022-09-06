FROM eclipse-temurin:18-jdk

LABEL "Organization"="Apereo"
LABEL "Description"="Apereo CAS"

ENV SP_SSL_KEYSTORE_PATH "/etc/cas/thekeystore"
ENV SP_SSL_KEYSTORE_PASSWORD "changeit"

RUN mkdir -p fediz
COPY ./src fediz/src/
COPY ./gradle/ fediz/gradle/
COPY ./gradlew ./settings.gradle ./build.gradle ./gradle.properties fediz

RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && cd fediz \
    && chmod 750 ./gradlew \
    && ./gradlew --version;


RUN cd fediz \	
    && ./gradlew clean build --parallel --no-daemon;

EXPOSE 8080 8443

ENV PATH $PATH:$JAVA_HOME/bin:.

WORKDIR fediz
ENTRYPOINT ["./gradlew", "build", "appStart", "-x", "test", "--no-daemon", "-Dsp.sslKeystorePath=$SP_SSL_KEYSTORE_PATH"]