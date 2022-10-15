FROM eclipse-temurin:11

LABEL "Organization"="Apereo"
LABEL "Description"="Apereo CAS"

ENV SP_SSL_KEYSTORE_PATH "/etc/cas/thekeystore"
ENV SP_SSL_KEYSTORE_PASSWORD "changeit"

RUN mkdir -p fediz
COPY ./src fediz/src/
COPY ./gradle/ fediz/gradle/
COPY ./gradlew ./settings.gradle ./build.gradle ./gradle.properties ./run.sh fediz/

RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && cd fediz \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd fediz \	
    && ./gradlew clean build --parallel --no-daemon;

EXPOSE 8076 9876

ENV PATH $PATH:$JAVA_HOME/bin:.

WORKDIR fediz
ENTRYPOINT ["./run.sh"]