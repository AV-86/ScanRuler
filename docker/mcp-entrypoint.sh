#!/bin/sh
# The server binds 127.0.0.1:7317 only, which Docker cannot publish.
# Forward the published port to that socket. The process itself stays up
# with its stdin held open: Cursor talks to a second copy, started with
# `docker compose exec`, and that copy relays through this one.
socat TCP-LISTEN:7318,fork,bind=0.0.0.0,reuseaddr TCP:127.0.0.1:7317 &
exec node /opt/scanruler-mcp/bin/scanruler-mcp.js --app https://localhost:442 --out /data
