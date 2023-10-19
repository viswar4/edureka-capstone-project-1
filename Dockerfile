FROM maven:3.9.4-eclipse-temurin-11-alpine as build
WORKDIR /app
COPY . .
RUN mvn install
FROM tomcat:10.1.15-jre17-temurin
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
RUN addgroup --system --gid 1000 tomcatuser && \
    adduser --system --uid 1000 --ingroup tomcatuser tomcatuser
USER tomcatuser
EXPOSE 8080
CMD ["catalina.sh", "run"]