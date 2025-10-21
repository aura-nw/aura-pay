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

