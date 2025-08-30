#!/bin/bash

# Simple deployment script for portfolio site
echo "🚀 Deploying Portfolio Site..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please initialize git first."
    exit 1
fi

# Add all files
echo "📦 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Deploy portfolio site $(date +%Y-%m-%d_%H-%M-%S)"

# Push to main branch
echo "⬆️ Pushing to GitHub..."
git push origin main

echo "✅ Deployment complete!"
echo "🌐 Your site will be live at your configured hosting platform (Netlify/Vercel/GitHub Pages)"
