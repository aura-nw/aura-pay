#!/bin/bash

# Script to generate config files from environment variables
# Usage: ./scripts/generate-config.sh [environment]

set -e

ENV=${1:-development}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_ROOT/assets/config"

echo "🔧 Generating config for environment: $ENV"

# Map environment names to template names
case $ENV in
    development|dev)
        TEMPLATE_ENV="dev"
        ;;
    staging)
        TEMPLATE_ENV="staging"
        ;;
    production|prod)
        TEMPLATE_ENV="production"
        ;;
    *)
        TEMPLATE_ENV="$ENV"
        ;;
esac

# Check if template exists
TEMPLATE_FILE="$CONFIG_DIR/config.$TEMPLATE_ENV.template.json"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Template file not found: $TEMPLATE_FILE"
    echo "Available templates:"
    ls -la "$CONFIG_DIR"/*.template.json 2>/dev/null || echo "No templates found"
    exit 1
fi

# Load environment variables if .env exists
if [ -f ".env" ]; then
    echo "📄 Loading environment variables from .env..."
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check if required env vars are set
if [ -z "$WEB3AUTH_CLIENT_ID" ]; then
    echo "⚠️  Warning: WEB3AUTH_CLIENT_ID not set, using placeholder"
    export WEB3AUTH_CLIENT_ID="YOUR_WEB3AUTH_CLIENT_ID_HERE"
fi

# Generate config file (use template environment name for output)
OUTPUT_FILE="$CONFIG_DIR/config.$TEMPLATE_ENV.json"
echo "📝 Generating: $OUTPUT_FILE"

# Use envsubst to replace environment variables
envsubst < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "✅ Config generated successfully!"
echo "📁 Output: $OUTPUT_FILE"
echo ""
echo "🔍 Generated config preview:"
echo "----------------------------------------"
cat "$OUTPUT_FILE" | jq '.WEB_3_AUTH.client_id' 2>/dev/null || echo "WEB3AUTH_CLIENT_ID: $(grep -o 'client_id.*' "$OUTPUT_FILE")"
echo "----------------------------------------"
