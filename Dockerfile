FROM debian:stable
RUN apt-get update && apt-get install -y basex wget
RUN wget https://raw.githubusercontent.com/w3c/xml-entities/refs/heads/gh-pages/unicode.xml
COPY uncompressed.xq compressed.xq ./
CMD basex uncompressed.xq