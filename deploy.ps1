# Simple deployment script for portfolio site
Write-Host "🚀 Deploying Portfolio Site..." -ForegroundColor Green

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Not a git repository. Please initialize git first." -ForegroundColor Red
    exit 1
}

# Add all files
Write-Host "📦 Adding files to git..." -ForegroundColor Yellow
git add .

# Commit changes
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$commitMessage = "Deploy portfolio site $timestamp"
Write-Host "💾 Committing changes..." -ForegroundColor Yellow
git commit -m $commitMessage

# Push to main branch
Write-Host "⬆️ Pushing to GitHub..." -ForegroundColor Yellow
git push origin main

Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "🌐 Netlify will build from main (build: npm run build, publish: dist)" -ForegroundColor Cyan
