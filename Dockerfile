FROM nickblah/lua

WORKDIR /app

COPY . /app
COPY ./examples/print.rinha.json /var/rinha/source.rinha.json

CMD lua main.lua
