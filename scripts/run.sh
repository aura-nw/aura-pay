#!/bin/bash

# Run script for Pyxis Mobile
# Usage: ./scripts/run.sh [environment] [device]
# Example: ./scripts/run.sh staging

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENV=${1:-development}
DEVICE=${2:-}

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Pyxis Mobile Run Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${YELLOW}Environment:${NC} $ENV"

# Load environment variables if .env exists
if [ -f ".env" ]; then
    echo -e "${BLUE}Loading environment variables...${NC}"
    set -a
    source .env
    set +a
fi

# Generate config if needed
CONFIG_FILE="assets/config/config.$ENV.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}Config file not found: $CONFIG_FILE${NC}"
    echo -e "${BLUE}Generating config...${NC}"
    ./scripts/generate-config.sh $ENV
fi

# Get dependencies
echo -e "${BLUE}Getting dependencies...${NC}"
flutter pub get

# Run app
echo -e "${BLUE}Running app...${NC}"
echo ""

if [ -z "$DEVICE" ]; then
    flutter run --dart-define=ENV=$ENV
else
    flutter run --dart-define=ENV=$ENV -d $DEVICE
fi

