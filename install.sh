#!/bin/bash
set -euo pipefail

RED=$'\e[31m'
GREEN=$'\e[32m'
BLUE=$'\e[34m'
YELLOW=$'\e[33m'
RESET=$'\e[0m'

REPO_URL="https://github.com/Reingl/Media-Server-Starter-Pack"
INSTALL_DIR="${HOME}/.local/bin"
SCRIPT_NAME="start-server"

echo "${BLUE}========================================${RESET}"
echo "${GREEN}Media Server Starter Pack Installer${RESET}"
echo "${BLUE}========================================${RESET}"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "${RED}Error: git is not installed${RESET}"
    echo "Please install git and try again"
    exit 1
fi

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

echo "${YELLOW}Downloading start-server script...${RESET}"

# Download the start-server.sh script
if ! curl -fsSL "$REPO_URL/raw/main/start-server.sh" -o "$INSTALL_DIR/$SCRIPT_NAME"; then
    echo "${RED}Error: Failed to download the script${RESET}"
    exit 1
fi

# Make it executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "${GREEN}✓ Successfully installed${RESET}"
echo ""
echo "${BLUE}Installation Details:${RESET}"
echo "  Script location: ${GREEN}$INSTALL_DIR/$SCRIPT_NAME${RESET}"
echo ""

# Check if $INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "${YELLOW}⚠ Warning: $INSTALL_DIR is not in your PATH${RESET}"
    echo "Add this line to your shell profile (~/.bashrc, ~/.zshrc, etc):"
    echo ""
    echo "  ${BLUE}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    echo "Then run: ${GREEN}source ~/.bashrc${RESET} (or ~/.zshrc)"
    echo ""
fi

echo "${GREEN}To start the server, run:${RESET}"
echo "  ${BLUE}$SCRIPT_NAME${RESET}"
echo ""
echo "${BLUE}========================================${RESET}"
