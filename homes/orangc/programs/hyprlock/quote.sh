#!/bin/bash

username="orangc"
client_id="$MYANIMELIST_AUTH_TOKEN"

# Check for Client ID
if [[ -z "$client_id" ]]; then
    echo "Missing MYANIMELIST_AUTH_TOKEN env var."
    exit 1
fi

url="https://api.myanimelist.net/v2/users/$username/animelist?status=completed&limit=100&fields=anime.title,anime.alternative_titles"

response=$(curl -s -H "X-MAL-CLIENT-ID: $client_id" "$url")

# Validate response
if ! echo "$response" | jq -e '.data' >/dev/null 2>&1; then
    echo "Failed to fetch or parse anime list."
    exit 1
fi

# Extract English title if exists, else fallback to original title
titles=$(echo "$response" | jq -r '
  .data[].node | 
  if .alternative_titles.en != null and .alternative_titles.en != "" then 
    .alternative_titles.en 
  else 
    .title 
  end
')

# Read into an array
IFS=$'\n' read -rd '' -a title_array <<< "$titles"

# Check that we have titles
if [[ ${#title_array[@]} -eq 0 ]]; then
    echo "No anime titles found."
    exit 1
fi

random_title="${title_array[RANDOM % ${#title_array[@]}]}"
echo "$random_title"