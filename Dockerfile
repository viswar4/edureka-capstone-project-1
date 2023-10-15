FROM maven:3.9.2-eclipse-temurin-11-alpine as build
WORKDIR /app
COPY . .
RUN mvn install
FROM tomcat:9.0.82-jre8-temurin
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
RUN addgroup --system --gid 1000 tomcatuser && \
    adduser --system --uid 1000 --ingroup tomcatuser tomcatuser
USER tomcatuser
EXPOSE 8080
CMD ["catalina.sh", "run"]