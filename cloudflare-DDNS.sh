#!/bin/bash

echo "[$(date)]: Update Cloudflare DDNS started."
echo ""  # Add an empty line for better readability

# Use curl to get the IP address from icanhazip.com
IP=$(curl icanhazip.com)

# Validate that we got an IP address
if [[ -z "$IP" ]]; then
  echo "Failed to obtain a valid IP from icanhazip.com."
  exit 1
fi

echo ""
echo "Using IP: $IP for Cloudflare DDNS update."
echo ""  # Add an empty line for better readability

# New Cloudflare API endpoint for the updated DNS record
# Zone ID can be fetched from your site dashboard in Cloudflare,for dns_record identifer, /
# I just used GET method on the url "https://api.cloudflare.com/client/v4/zones/{zone_ID}/dns_records" to fetch the idnetifer value
CLOUDFLARE_URL="https://api.cloudflare.com/client/v4/zones/{zone_ID}/dns_records/{identifier}"
AUTH_EMAIL="" # Account Email
AUTH_KEY="" # API Key

# Construct the new JSON payload with updated data
# This will create a subdomain on your domain with DDNS, i.e ddns.example.com
JSON_DATA=$(cat <<EOF
{
    "type": "A",
    "content": "$IP",
    "proxied": false,
    "ttl": 300,
    "name": "ddns",
    "comment": "DDNS update script"
}
EOF
)

echo ""
echo "JSON Payload: $JSON_DATA"
echo ""  # Add an empty line for better readability

# Make the API PUT request to Cloudflare to update the DNS record
RESPONSE=$(curl --request PUT \
  --url "$CLOUDFLARE_URL" \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $AUTH_EMAIL" \
  --header "X-Auth-Key: $AUTH_KEY" \
  --data "$JSON_DATA")

echo ""
echo "Response from Cloudflare:"
echo "$RESPONSE"
echo ""  # Add an empty line for better readability

echo "[$(date)]: Update Cloudflare DDNS finished."
