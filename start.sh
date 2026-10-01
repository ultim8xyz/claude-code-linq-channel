#!/bin/sh
# Start the channel without npm: claude gives an MCP server 30s to answer, and on a loaded
# machine an npm install and a tsc on every start ran past it. Build only when dist is stale.
cd "$(dirname "$0")" || exit 1
if [ ! -d node_modules ] || [ ! -f dist/channel.js ] || [ -n "$(find src package.json -newer dist/channel.js)" ]; then
  npm install --no-summary >&2 && npx tsc >&2 || exit 1
fi
exec node dist/channel.js
