#!/usr/bin/env bash
set -euo pipefail

# Read from PRIMARY selection; fallback to regular clipboard if empty
SEL="$(wl-paste --primary 2>/dev/null || true)"
if [ -z "${SEL// /}" ]; then
  SEL="$(wl-paste 2>/dev/null || true)"
fi

if [ -z "${SEL// /}" ]; then
  notify-send "LaTeX → clipboard" "No selection or clipboard text found." || true
  exit 1
fi

# URL-encode the selection safely
ENCODED="$(printf '%s' "$SEL" | jq -sRr @uri)"

# Get the url
URL="https://latex.codecogs.com/png.latex?${ENCODED}"

# Download and pipe directly to wl-copy as image/png
# (Also save a temp file so you can reuse it if needed)
TMPFILE="$(mktemp --suffix=.png)"
if ! curl -fsSL "$URL" -o "$TMPFILE"; then
  notify-send "LaTeX → clipboard" "Failed to render LaTeX (curl error)." || true
  rm -f "$TMPFILE"
  exit 1
fi

# Copy to clipboard as an image
wl-copy --type image/png < "$TMPFILE"


notify-send "LaTeX → clipboard" "Rendered selection to image and copied." || true
