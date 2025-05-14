FROM tomcat:11.0.7-jdk21-temurin-noble
COPY target/simple-webapp.war /usr/local/tomcat/webapps/