#!/usr/bin/env bash
cd "$(dirname "$0")"
PORT="${1:-8080}"
echo "Serving at http://localhost:${PORT}"
echo "Press Ctrl+C to stop."
exec python3 -m http.server "$PORT"
