# Script pour corriger le bug d'affichage Chrome sur toutes les versions linguistiques
# Supprime l'élément <div class="qr-shine"></div> qui perturbe le layout

$languages = @('de', 'es', 'it', 'pt', 'ar', 'ja', 'ru', 'pl', 'ko', 'zh')

Write-Host "🔧 Correction du bug Chrome pour toutes les langues..." -ForegroundColor Cyan
Write-Host ""

foreach ($lang in $languages) {
    $filePath = "$lang/index.html"
    
    if (Test-Path $filePath) {
        Write-Host "📝 Traitement de $lang/index.html..." -ForegroundColor Yellow
        
        # Lire le contenu
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Pattern à rechercher (avec l'élément qr-shine à supprimer)
        $oldPattern = @"
            <div class="qr-code-wrapper">
              <img src="../images/qrcode_play.google.com.png" alt="[^"]*" class="qr-code" width="200" height="200" loading="lazy">
              <div class="qr-shine"></div>
            </div>
"@
        
        # Nouveau pattern (sans qr-shine)
        $newPattern = @"
            <div class="qr-code-wrapper">
              <img src="../images/qrcode_play.google.com.png" alt="`$1" class="qr-code" width="200" height="200" loading="lazy">
            </div>
"@
        
        # Utiliser une regex plus flexible
        $pattern = '<div class="qr-code-wrapper">\s*<img src="../images/qrcode_play\.google\.com\.png" alt="([^"]*)" class="qr-code" width="200" height="200" loading="lazy">\s*<div class="qr-shine"></div>\s*</div>'
        $replacement = '<div class="qr-code-wrapper">' + "`n" + '              <img src="../images/qrcode_play.google.com.png" alt="$1" class="qr-code" width="200" height="200" loading="lazy">' + "`n" + '            </div>'
        
        if ($content -match $pattern) {
            $newContent = $content -replace $pattern, $replacement
            
            # Sauvegarder
            Set-Content -Path $filePath -Value $newContent -Encoding UTF8 -NoNewline
            
            Write-Host "   ✅ $lang - Élément qr-shine supprimé" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  $lang - Pattern non trouvé (peut-être déjà corrigé)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ❌ $lang - Fichier non trouvé" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "🎉 Correction terminée pour toutes les langues!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Résumé des corrections:" -ForegroundColor Cyan
Write-Host "   • Élément <div class='qr-shine'></div> supprimé de tous les fichiers" -ForegroundColor White
Write-Host "   • Layout QR code maintenant identique sur Chrome et Edge" -ForegroundColor White
Write-Host "   • Compatibilité cross-browser améliorée" -ForegroundColor White
Write-Host ""
Write-Host "🧪 Test recommandé:" -ForegroundColor Yellow
Write-Host "   Ouvrir chaque version dans Chrome et vérifier que le QR code" -ForegroundColor White
Write-Host "   apparaît bien à droite du texte 'Ready to Start Saving'" -ForegroundColor White
