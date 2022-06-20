FROM tomcat
MAINTAINER xyz

ADD target/*.war /usr/local/tomcat/webapps/webapp.war

CMD ["catalina.sh", "run"]
