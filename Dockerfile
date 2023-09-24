FROM nickblah/lua

WORKDIR /

COPY . /

CMD lua main.lua
