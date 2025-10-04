# Script pour ajouter le QR code à toutes les versions linguistiques
# Ce script met à jour la section CTA avec le QR code de manière cohérente

Write-Host "🎨 Ajout du QR code aux versions linguistiques..." -ForegroundColor Cyan
Write-Host ""

$languages = @{
    "de" = @{ scan="Scannen zum Download"; name="Deutsch" }
    "es" = @{ scan="Escanear para descargar"; name="Español" }
    "it" = @{ scan="Scansiona per scaricare"; name="Italiano" }
    "pt" = @{ scan="Digitalize para baixar"; name="Português" }
    "ar" = @{ scan="امسح لتحميل"; name="العربية" }
    "ja" = @{ scan="スキャンしてダウンロード"; name="日本語" }
    "ru" = @{ scan="Сканируйте для загрузки"; name="Русский" }
    "pl" = @{ scan="Zeskanuj, aby pobrać"; name="Polski" }
    "ko" = @{ scan="스캔하여 다운로드"; name="한국어" }
    "zh" = @{ scan="扫描下载"; name="中文" }
}

$qrCodeHtml = @'
        
        <div class="cta-qr scroll-reveal" data-delay="250">
          <div class="qr-card">
            <div class="qr-code-wrapper">
              <img src="../images/qrcode_play.google.com.png" alt="SCAN_TEXT" class="qr-code" width="200" height="200" loading="lazy">
              <div class="qr-shine"></div>
            </div>
            <p class="qr-text">
              <span class="qr-icon">📱</span>
              <span>QR_TEXT</span>
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
'@

foreach ($langCode in $languages.Keys) {
    $filePath = "$langCode\index.html"
    
    if (-not (Test-Path $filePath)) {
        Write-Host "⚠️  Ignoré $langCode - fichier non trouvé" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "🔄 Mise à jour $($languages[$langCode].name) ($langCode)..." -ForegroundColor Cyan
    
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Vérifier si le QR code est déjà présent
        if ($content -match 'qrcode_play.google.com') {
            Write-Host "   ✓ QR code déjà présent" -ForegroundColor Green
            continue
        }
        
        # Remplacer la structure CTA
        $qrCodeCustom = $qrCodeHtml -replace 'SCAN_TEXT', "Scan to download Shoopt from Google Play"
        $qrCodeCustom = $qrCodeCustom -replace 'QR_TEXT', $languages[$langCode].scan
        
        # Trouver et remplacer la fin de la section CTA
        $pattern = '(\s*)</div>\s*</div>\s*</section>\s*</main>'
        if ($content -match '<section[^>]*id="download"[^>]*class="cta"') {
            $content = $content -replace '(</section>\s*</main>)', "$qrCodeCustom`$1"
            
            # Ajouter les classes nécessaires
            $content = $content -replace '(<div class="container) text-center(">)', '$1$2'
            $content = $content -replace '(<div class="container">)', '$1<div class="cta-content"><div class="cta-text">'
            $content = $content -replace '(<p class="launch-note)', '</div>$1'
            
            # Ajouter btn-large et icône au bouton
            if ($content -match '<a[^>]*btn-primary[^>]*>(?!.*btn-large)') {
                $playIcon = '<svg class="btn-icon" width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M3 20.5V3.5C3 2.91 3.34 2.39 3.84 2.15L13.69 12L3.84 21.85C3.34 21.6 3 21.09 3 20.5M16.81 15.12L6.05 21.34L14.54 12.85L16.81 15.12M20.16 10.81C20.5 11.08 20.75 11.5 20.75 12C20.75 12.5 20.53 12.9 20.18 13.18L17.89 14.5L15.39 12L17.89 9.5L20.16 10.81M6.05 2.66L16.81 8.88L14.54 11.15L6.05 2.66Z" fill="currentColor"/></svg>'
                $content = $content -replace '(<a[^>]*class="btn-primary)(")', '$1 btn-large$2'
                $content = $content -replace '(<a[^>]*class="btn-primary btn-large"[^>]*>)', "`$1$playIcon "
            }
            
            # Envelopper le bouton dans cta-buttons
            $content = $content -replace '(<a[^>]*btn-primary)', '<div class="cta-buttons scroll-reveal" data-delay="200">$1'
            $content = $content -replace '(</a>\s*<p class="launch-note)', '</a></div>$1'
        }
        
        # Sauvegarder
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        Write-Host "   ✅ Mis à jour avec succès" -ForegroundColor Green
    }
    catch {
        Write-Host "   ❌ Erreur: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✨ Mise à jour terminée!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Le QR code a été ajouté à toutes les versions linguistiques" -ForegroundColor Cyan
Write-Host "🎨 Design moderne avec animations" -ForegroundColor Cyan
Write-Host "📐 Layout responsive pour mobile et desktop" -ForegroundColor Cyan
Write-Host ""
