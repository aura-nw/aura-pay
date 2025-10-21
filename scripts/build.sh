#!/bin/bash

# Build script for Pyxis Mobile
# Usage: ./scripts/build.sh [environment] [platform] [build-type]
# Example: ./scripts/build.sh production android release

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENV=${1:-development}
PLATFORM=${2:-android}
BUILD_TYPE=${3:-debug}

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Pyxis Mobile Build Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${YELLOW}Environment:${NC} $ENV"
echo -e "${YELLOW}Platform:${NC} $PLATFORM"
echo -e "${YELLOW}Build Type:${NC} $BUILD_TYPE"
echo ""

# Validate environment
if [[ ! "$ENV" =~ ^(development|dev|serenity|staging|production)$ ]]; then
    echo -e "${RED}Error: Invalid environment. Use 'development', 'staging', or 'production'${NC}"
    exit 1
fi

# Validate platform
if [[ ! "$PLATFORM" =~ ^(android|ios|web)$ ]]; then
    echo -e "${RED}Error: Invalid platform. Use 'android', 'ios', or 'web'${NC}"
    exit 1
fi

# Clean and get dependencies
echo -e "${BLUE}Step 1: Cleaning previous builds...${NC}"
flutter clean

echo -e "${BLUE}Step 2: Getting dependencies...${NC}"
flutter pub get

# Build based on platform
echo -e "${BLUE}Step 3: Building $PLATFORM for $ENV...${NC}"

if [ "$PLATFORM" = "android" ]; then
    if [ "$BUILD_TYPE" = "release" ]; then
        echo -e "${YELLOW}Building release APK...${NC}"
        flutter build apk --dart-define=ENV=$ENV --release
        
        echo -e "${GREEN}✓ Build successful!${NC}"
        echo -e "${YELLOW}APK location:${NC} build/app/outputs/flutter-apk/app-release.apk"
    else
        echo -e "${YELLOW}Building debug APK...${NC}"
        flutter build apk --dart-define=ENV=$ENV --debug
        
        echo -e "${GREEN}✓ Build successful!${NC}"
        echo -e "${YELLOW}APK location:${NC} build/app/outputs/flutter-apk/app-debug.apk"
    fi
    
elif [ "$PLATFORM" = "ios" ]; then
    if [ "$BUILD_TYPE" = "release" ]; then
        echo -e "${YELLOW}Building release iOS...${NC}"
        flutter build ios --dart-define=ENV=$ENV --release
    else
        echo -e "${YELLOW}Building debug iOS...${NC}"
        flutter build ios --dart-define=ENV=$ENV --debug
    fi
    
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo -e "${YELLOW}iOS build location:${NC} build/ios/iphoneos/"
    
elif [ "$PLATFORM" = "web" ]; then
    echo -e "${YELLOW}Building web app...${NC}"
    flutter build web --dart-define=ENV=$ENV
    
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo -e "${YELLOW}Web build location:${NC} build/web/"
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}================================${NC}"

