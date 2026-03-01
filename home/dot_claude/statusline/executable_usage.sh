#!/bin/bash

# Claude Pro/Max Usage Fetcher
# Fetches usage limits from Anthropic API with 5-minute disk cache
# Output (JSON): { "five_hour": { "utilization": 25.5, "resets_at": "..." }, ... }

CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage.json"
CACHE_TTL=300  # 5 minutes in seconds
CREDENTIALS_FILE="$HOME/.claude/.credentials.json"
API_URL="https://api.anthropic.com/api/oauth/usage"

# Print cached data if still fresh
if [[ -f "$CACHE_FILE" ]]; then
    age=$(( $(date +%s) - $(date -r "$CACHE_FILE" +%s) ))
    if [[ $age -lt $CACHE_TTL ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Read access token from credentials file
if [[ ! -f "$CREDENTIALS_FILE" ]]; then
    echo '{"error":"credentials not found"}' >&2
    exit 1
fi

ACCESS_TOKEN=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDENTIALS_FILE")
if [[ -z "$ACCESS_TOKEN" ]]; then
    echo '{"error":"no access token"}' >&2
    exit 1
fi

# Fetch usage from API
RESPONSE=$(curl -sf \
    --max-time 5 \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -H "anthropic-beta: oauth-2025-04-20" \
    "$API_URL")

if [[ $? -ne 0 ]] || [[ -z "$RESPONSE" ]]; then
    # On failure, return stale cache if available rather than nothing
    if [[ -f "$CACHE_FILE" ]]; then
        cat "$CACHE_FILE"
    fi
    exit 1
fi

# Validate it looks like the expected shape before caching
if echo "$RESPONSE" | jq -e '.five_hour' > /dev/null 2>&1; then
    mkdir -p "$(dirname "$CACHE_FILE")"
    echo "$RESPONSE" > "$CACHE_FILE"
    echo "$RESPONSE"
else
    echo '{"error":"unexpected response"}' >&2
    exit 1
fi