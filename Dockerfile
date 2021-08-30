FROM openjdk:8-jdk-alpine
ARG JAR_FILE=/home/ec2-user/release/*/*.jar
COPY ${JAR_FILE} release.jar
ENTRYPOINT ["java","-jar","/release.jar","--server.port=8083"]
