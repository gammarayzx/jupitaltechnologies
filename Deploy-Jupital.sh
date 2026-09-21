#!/bin/bash
# Jupital Technologies - Git Bash Auto-Deploy
# Store ID: abracadabra0a-20 | Established 2009

set -e

echo "========================================="
echo " JUPITAL TECHNOLOGIES - Git Bash Deployer"
echo " Established 2009 | abracadabra0a-20"
echo "========================================="

# Check git
if ! command -v git &> /dev/null; then
    echo "ERROR: git not found. Install Git for Windows"
    exit 1
fi

# Check index.html
if [ ! -f "index.html" ]; then
    echo "ERROR: index.html not found in this folder!"
    echo "Download index.html from Meta AI into this same folder:"
    pwd
    exit 1
fi

# Get username
if [ -z "$1" ]; then
    read -p "Enter your GitHub username: " USERNAME
else
    USERNAME=$1
fi

REPO=${2:-jupitaltechnologies}

echo ""
echo "Deploying to https://github.com/$USERNAME/$REPO"

# Init if needed
if [ ! -d ".git" ]; then
    git init
    git add index.html
    git commit -m "Jupital Technologies - Established 2009 - Drone/PC/Ebike - abracadabra0a-20"
    git branch -M main
    git remote add origin "https://github.com/$USERNAME/$REPO.git" 2>/dev/null || echo "Remote exists"
else
    git add index.html
    git commit -m "Update Jupital store" || echo "Nothing to commit"
fi

# Push
echo "Pushing..."
if command -v gh &> /dev/null; then
    # Use gh to create repo if needed
    gh repo create "$USERNAME/$REPO" --public --source=. --remote=origin --push 2>/dev/null || git push -u origin main
    # Enable Pages
    gh api -X POST "/repos/$USERNAME/$REPO/pages" -f source.branch="main" -f source.path="/" 2>/dev/null && echo "Pages enabled!" || echo "Enable Pages manually in Settings > Pages"
else
    git push -u origin main
    echo ""
    echo "Now enable GitHub Pages manually:"
    echo "1. Go to https://github.com/$USERNAME/$REPO/settings/pages"
    echo "2. Source: Deploy from a branch -> main -> / (root) -> Save"
fi

echo ""
echo "========================================="
echo " LIVE SOON AT:"
echo " https://$USERNAME.github.io/$REPO/"
echo "========================================="
echo "Add this URL to Amazon Associates website list"
