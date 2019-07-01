FROM nginx:stable-alpine

RUN apk add --no-cache tzdata bc jq bash

COPY templates/ /var/tmp/templates/
COPY docs/* /var/tmp/
COPY scripts/setup-env /var/tmp/

RUN "/var/tmp/setup-env"

CMD ["nginx", "-g", "daemon off;"]
