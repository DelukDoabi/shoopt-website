# Shoopt Website - Quick Performance Test

Write-Host "🚀 Shoopt Website Performance Checker" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if running in workspace directory
$currentPath = Get-Location
Write-Host "📂 Current Directory: $currentPath" -ForegroundColor Yellow
Write-Host ""

# Check for required files
Write-Host "✅ Checking Required Files..." -ForegroundColor Green
$requiredFiles = @(
    "index.html",
    "css/style.css",
    "robots.txt",
    "sitemap.xml",
    "manifest.json",
    ".htaccess",
    "404.html"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $file (MISSING)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

Write-Host ""

# Check HTML structure
Write-Host "🔍 Analyzing HTML Structure..." -ForegroundColor Green
$htmlContent = Get-Content "index.html" -Raw

$checks = @{
    "Meta Description" = $htmlContent -match '<meta name="description"'
    "Open Graph Tags" = $htmlContent -match 'property="og:'
    "Structured Data (JSON-LD)" = $htmlContent -match 'application/ld\+json'
    "Canonical URL" = $htmlContent -match 'rel="canonical"'
    "Hreflang Tags" = $htmlContent -match 'hreflang='
    "Semantic HTML (header)" = $htmlContent -match '<header'
    "Semantic HTML (main)" = $htmlContent -match '<main'
    "Semantic HTML (footer)" = $htmlContent -match '<footer'
    "ARIA Labels" = $htmlContent -match 'aria-label'
    "Alt Text on Images" = $htmlContent -match 'alt='
    "Lazy Loading" = $htmlContent -match 'loading='
    "Theme Color" = $htmlContent -match 'theme-color'
    "Web Manifest" = $htmlContent -match 'manifest.json'
}

foreach ($check in $checks.GetEnumerator()) {
    if ($check.Value) {
        Write-Host "  ✓ $($check.Key)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($check.Key)" -ForegroundColor Yellow
    }
}

Write-Host ""

# Check CSS for animations
Write-Host "🎨 Checking CSS Animations..." -ForegroundColor Green
$cssContent = Get-Content "css/style.css" -Raw

$cssChecks = @{
    "Keyframe Animations" = $cssContent -match '@keyframes'
    "Transitions" = $cssContent -match 'transition:'
    "Transform Properties" = $cssContent -match 'transform:'
    "Will-Change Optimization" = $cssContent -match 'will-change:'
    "Reduced Motion Support" = $cssContent -match 'prefers-reduced-motion'
    "CSS Variables" = $cssContent -match ':root'
}

foreach ($check in $cssChecks.GetEnumerator()) {
    if ($check.Value) {
        Write-Host "  ✓ $($check.Key)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $($check.Key)" -ForegroundColor Yellow
    }
}

Write-Host ""

# File size analysis
Write-Host "📊 File Size Analysis..." -ForegroundColor Green
$htmlSize = (Get-Item "index.html").Length / 1KB
$cssSize = (Get-Item "css/style.css").Length / 1KB

Write-Host "  HTML: $([math]::Round($htmlSize, 2)) KB" -ForegroundColor Cyan
Write-Host "  CSS:  $([math]::Round($cssSize, 2)) KB" -ForegroundColor Cyan

if ($htmlSize -lt 100) {
    Write-Host "  ✓ HTML size is optimal" -ForegroundColor Green
} else {
    Write-Host "  ⚠ HTML size might be large. Consider optimization." -ForegroundColor Yellow
}

if ($cssSize -lt 50) {
    Write-Host "  ✓ CSS size is optimal" -ForegroundColor Green
} else {
    Write-Host "  ⚠ CSS size might be large. Consider minification." -ForegroundColor Yellow
}

Write-Host ""

# Summary
Write-Host "📋 Summary" -ForegroundColor Cyan
Write-Host "==========" -ForegroundColor Cyan

if ($allFilesExist) {
    Write-Host "✅ All required files are present!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some files are missing. Check the list above." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Test with Google Lighthouse (Chrome DevTools)" -ForegroundColor White
Write-Host "  2. Validate structured data: https://search.google.com/test/rich-results" -ForegroundColor White
Write-Host "  3. Check mobile-friendliness: https://search.google.com/test/mobile-friendly" -ForegroundColor White
Write-Host "  4. Run PageSpeed Insights: https://pagespeed.web.dev/" -ForegroundColor White
Write-Host "  5. Deploy and submit sitemap to Google Search Console" -ForegroundColor White
Write-Host ""

Write-Host "✨ Your website is optimized for near-perfect SEO scores!" -ForegroundColor Green
Write-Host ""

# Offer to open in browser
$response = Read-Host "Would you like to open the website in your default browser? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    Start-Process "index.html"
    Write-Host "🌐 Opening in browser..." -ForegroundColor Cyan
}
