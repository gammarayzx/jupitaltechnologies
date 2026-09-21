
# Jupital Technologies - GitHub Pages Auto-Deploy
# Created for Store ID: abracadabra0a-20
# Usage: Put this file AND index.html in same folder, then run: powershell -ExecutionPolicy Bypass -File .\deploy-jupital.ps1

param(
    [string]$GithubUsername = "",
    [string]$RepoName = "jupitaltechnologies"
)

Write-Host "=========================================" -ForegroundColor Yellow
Write-Host " JUPITAL TECHNOLOGIES - GitHub Deployer " -ForegroundColor Yellow
Write-Host " Established 2009 | abracadabra0a-20" -ForegroundColor DarkGray
Write-Host "=========================================" -ForegroundColor Yellow

# 1. Check git
try { git --version | Out-Null } catch {
    Write-Host "ERROR: git not installed. Install from https://git-scm.com/downloads" -ForegroundColor Red
    exit 1
}

# 2. Get username if not provided
if (-not $GithubUsername) {
    $GithubUsername = Read-Host "Enter your GitHub username"
}
if (-not $GithubUsername) { Write-Host "Username required" -ForegroundColor Red; exit 1 }

# 3. Check for index.html
$indexPath = Join-Path $PSScriptRoot "index.html"
if (-not (Test-Path $indexPath)) {
    Write-Host "ERROR: index.html not found in same folder as this script!" -ForegroundColor Red
    Write-Host "Download your site from Meta AI and save as index.html here:" -ForegroundColor Yellow
    Write-Host $PSScriptRoot
    # Try to copy from container if running in sandbox (won't work on user PC, but harmless)
    exit 1
}

# 4. Check if gh CLI exists for auto repo creation
$hasGh = $false
try { gh --version | Out-Null; $hasGh = $true } catch {}

if ($hasGh) {
    Write-Host "`nGitHub CLI found - will create repo automatically" -ForegroundColor Green
    $create = Read-Host "Create GitHub repo $RepoName? (Y/n)"
    if ($create -ne "n") {
        try {
            gh repo create "$GithubUsername/$RepoName" --public --source=. --remote=origin --push
            Write-Host "Repo created and pushed!" -ForegroundColor Green
        } catch {
            Write-Host "Repo may already exist, trying manual push..." -ForegroundColor Yellow
        }
    }
}

# 5. Manual git flow (works even without gh)
if (-not (Test-Path (Join-Path $PSScriptRoot ".git"))) {
    Write-Host "`nInitializing git repo..." -ForegroundColor Cyan
    Set-Location $PSScriptRoot
    git init
    git add index.html
    git commit -m "Jupital Technologies - Established 2009 - 3 sections Drone/PC/Ebike - abracadabra0a-20"
    git branch -M main
    try { git remote add origin "https://github.com/$GithubUsername/$RepoName.git" } catch { Write-Host "Remote already exists" -ForegroundColor Yellow }
}

# 6. Push
Write-Host "`nPushing to GitHub..." -ForegroundColor Cyan
try {
    git push -u origin main
    Write-Host "`nSUCCESS! Pushed to https://github.com/$GithubUsername/$RepoName" -ForegroundColor Green
} catch {
    Write-Host "Push failed - you may need to create the repo manually at github.com/new" -ForegroundColor Red
    Write-Host "Then run: git push -u origin main" -ForegroundColor Yellow
    exit 1
}

# 7. Enable GitHub Pages via API (if gh available)
if ($hasGh) {
    Write-Host "`nEnabling GitHub Pages..." -ForegroundColor Cyan
    try {
        gh api -X POST "/repos/$GithubUsername/$RepoName/pages" -f source.branch="main" -f source.path="/" | Out-Null
        Write-Host "GitHub Pages enabled!" -ForegroundColor Green
    } catch {
        Write-Host "Enable Pages manually: Repo > Settings > Pages > Branch: main / root" -ForegroundColor Yellow
    }
} else {
    Write-Host "`nNow enable Pages manually:" -ForegroundColor Yellow
    Write-Host "1. Go to https://github.com/$GithubUsername/$RepoName/settings/pages" -ForegroundColor White
    Write-Host "2. Source: Deploy from a branch > main > / (root) > Save" -ForegroundColor White
}

Write-Host "`n=========================================" -ForegroundColor Yellow
Write-Host " LIVE SOON AT:" -ForegroundColor Yellow
Write-Host " https://$GithubUsername.github.io/$RepoName/" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Yellow
Write-Host "Add this URL to Amazon Associates: affiliate-program.amazon.com > Edit Website List" -ForegroundColor Cyan
Write-Host "`nDone! Your Jupital store with abracadabra0a-20 is deploying." -ForegroundColor Green
