#!/bin/sh

if [ -z "$AWS_BUCKET_NAME" ]; then
  echo "AWS_BUCKET_NAME is not set. Exiting..."
  exit 1
fi

CONTENT_CONFIG="/etc/nginx/includes/content/$AWS_BUCKET_NAME.conf"
STUDIO_UPSTREAM="${STUDIO_UPSTREAM:-127.0.0.1:8081}"

# if content proxy config with the same name as the bucket does not exist, use the default one
if [ ! -f "$CONTENT_CONFIG" ]; then
  CONTENT_CONFIG="/etc/nginx/includes/content/default.conf"
fi

echo "Using content proxy config: $CONTENT_CONFIG"
echo "Using Studio upstream: $STUDIO_UPSTREAM"
cp "$CONTENT_CONFIG" /etc/nginx/includes/content.conf

sed -i "s|__STUDIO_UPSTREAM__|$STUDIO_UPSTREAM|g" /etc/nginx/nginx.conf

nginx -c /etc/nginx/nginx.conf
