FROM openjdk:8-jdk-alpine
ARG JAR_FILE=release/*/*.jar
COPY ${JAR_FILE} release.jar
ENTRYPOINT ["java","-jar","/release.jar","--server.port=8083"]
