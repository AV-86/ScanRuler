#!/bin/sh
# Streamable HTTP for Open WebUI. This container shares the mcp service's
# network, so the copy started below relays through the holder on
# 127.0.0.1:7317. SCANRULER_OPENWEBUI_TOOLS is applied only here: Cursor's
# `compose exec` does not read it and keeps the full tool list.
TOOLS="${SCANRULER_OPENWEBUI_TOOLS:-compact}"
case "$TOOLS" in
  *[!A-Za-z0-9_,-]*)
    echo "SCANRULER_OPENWEBUI_TOOLS=${TOOLS} is not a scanruler-mcp --tools value." >&2
    exit 1
    ;;
esac
exec supergateway \
  --stdio "node /opt/scanruler-mcp/bin/scanruler-mcp.js --app https://localhost:442 --out /data --tools ${TOOLS}" \
  --outputTransport streamableHttp \
  --stateful \
  --sessionTimeout 3600000 \
  --host 0.0.0.0 \
  --port 8000 \
  --streamableHttpPath /mcp \
  --healthEndpoint /healthz
