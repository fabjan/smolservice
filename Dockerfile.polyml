# We need some build tools to compile the SML code
FROM alpine:3.18
RUN apk add --no-cache polyml
RUN apk add --no-cache g++
RUN apk add --no-cache polyml-dev

COPY src src
COPY *.mlb polybuild.sml build.sh .

RUN SML_COMPILER=polyc ./build.sh

# but we don't need them to run the finished program
FROM alpine:3.18
RUN apk add --no-cache polyml

WORKDIR /app

COPY --from=0 _build/smolservice .

CMD /app/smolservice
