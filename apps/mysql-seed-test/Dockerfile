# Last updated: 2024-04-10

# Use Alpine Linux for its small size
FROM alpine

ENV TERM xterm
ENV DB_PORT=3306

# Install mysql-client, jq, and bash packages
# Then clean up the cache to keep the image small
RUN apk add --update jq ncurses mariadb mariadb-client mariadb-connector-c-dev bash && \
    rm -rf /var/cache/apk/*

COPY init-script.sh /init-script.sh
RUN chmod +x /init-script.sh

# Run as non-root user
USER 1000

# The default command can be an instruction to keep the container running,
# or to execute a specific task
CMD [ "/bin/bash", "-c", "/init-script.sh" ]

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="alpine-db-init-runner" \
  org.label-schema.description="Alpine Init Image For MySQL DB Seeding" \
  org.label-schema.vendor="Bluescape"