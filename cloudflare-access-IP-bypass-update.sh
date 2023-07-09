#!/bin/bash

echo "[$(date)]: Update Cloudflare DDNS started."

# Use dig to get the IP address of ddns.example.com
IP=$(dig +short ddns.example.com) # Add the domain of your ddns to fetch your new IP

# Validate that we got an IP address
if [[ -z "$IP" ]]; then
  echo "Failed to obtain a valid IP for ddns.example.com."
  exit 1
fi

echo "Using IP: $IP for Cloudflare DDNS update."

# Cloudflare API credentials and endpoint
# Zone ID can be fetched from your site dashboard in Cloudflare, and uuid for access group can be fetched from one.dash.cloudflare.com of the given site
CLOUDFLARE_URL="https://api.cloudflare.com/client/v4/zones/{identifier}/access/groups/{uuid}" 
AUTH_EMAIL="" # Account Email
AUTH_KEY="" # API Key

# Construct the JSON payload
JSON_DATA=$(cat <<EOF
{
  "include": [
    {
      "ip": {
        "ip": "$IP"
      }
    }
  ]
}
EOF
)

echo "JSON Payload: $JSON_DATA"

# Make the API request to Cloudflare
RESPONSE=$(curl --request PUT \
  --url "$CLOUDFLARE_URL" \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $AUTH_EMAIL" \
  --header "X-Auth-Key: $AUTH_KEY" \
  --data "$JSON_DATA")

echo "Response from Cloudflare:"
echo "$RESPONSE"

echo "[$(date)]: Update Cloudflare DDNS finished."
