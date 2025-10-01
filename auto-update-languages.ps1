# Script to auto-update all language index.html files with SEO optimizations
# This script updates the structure while preserving translations

Write-Host "🌍 Auto-Updating All Language Files with SEO & Animations" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# Language configurations
$languages = @{
    "de" = @{ name = "Deutsch"; locale = "de_DE"; currency = "EUR" }
    "es" = @{ name = "Español"; locale = "es_ES"; currency = "EUR" }
    "it" = @{ name = "Italiano"; locale = "it_IT"; currency = "EUR" }
    "pt" = @{ name = "Português"; locale = "pt_PT"; currency = "EUR" }
    "ar" = @{ name = "العربية"; locale = "ar_AR"; currency = "USD" }
    "ja" = @{ name = "日本語"; locale = "ja_JP"; currency = "JPY" }
    "ru" = @{ name = "Русский"; locale = "ru_RU"; currency = "RUB" }
    "pl" = @{ name = "Polski"; locale = "pl_PL"; currency = "PLN" }
    "ko" = @{ name = "한국어"; locale = "ko_KR"; currency = "KRW" }
    "zh" = @{ name = "中文"; locale = "zh_CN"; currency = "CNY" }
}

$scriptBlock = @'
// Intersection Observer for scroll animations
const observerOptions = {
  threshold: 0.1,
  rootMargin: '0px 0px -50px 0px'
};

const scrollObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const delay = entry.target.dataset.delay || 0;
      setTimeout(() => {
        entry.target.classList.add('visible');
      }, delay);
      scrollObserver.unobserve(entry.target);
    }
  });
}, observerOptions);

document.addEventListener('DOMContentLoaded', () => {
  const animatedElements = document.querySelectorAll('.scroll-reveal, .fade-in-up');
  animatedElements.forEach(el => scrollObserver.observe(el));

  const header = document.querySelector('.site-header');
  let lastScroll = 0;
  
  window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    if (currentScroll > 50) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
    lastScroll = currentScroll;
  });

  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (href !== '#' && href !== '') {
        e.preventDefault();
        const target = document.querySelector(href);
        if (target) {
          const headerHeight = header.offsetHeight;
          const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - headerHeight;
          window.scrollTo({ top: targetPosition, behavior: 'smooth' });
          const navToggle = document.querySelector('.nav-toggle');
          if (navToggle && navToggle.checked) { navToggle.checked = false; }
        }
      }
    });
  });

  const menuToggle = document.querySelector('.menu-toggle');
  if (menuToggle) {
    menuToggle.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        const navToggle = document.querySelector('.nav-toggle');
        navToggle.checked = !navToggle.checked;
      }
    });
  }

  document.addEventListener('keydown', (e) => {
    const navToggle = document.querySelector('.nav-toggle');
    if (e.key === 'Escape' && navToggle && navToggle.checked) {
      navToggle.checked = false;
    }
  });

  const heroSection = document.querySelector('.hero');
  const heroCircles = document.querySelectorAll('.hero-bg .circle');
  if (heroSection && window.innerWidth > 768) {
    window.addEventListener('scroll', () => {
      const scrolled = window.pageYOffset;
      const heroHeight = heroSection.offsetHeight;
      if (scrolled < heroHeight) {
        heroCircles.forEach((circle, index) => {
          const speed = 0.3 + (index * 0.1);
          circle.style.transform = `translateY(${scrolled * speed}px)`;
        });
      }
    });
  }

  document.querySelectorAll('img').forEach(img => {
    if (!img.hasAttribute('loading')) {
      img.setAttribute('loading', 'lazy');
    }
  });

  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (prefersReducedMotion) {
    document.documentElement.style.setProperty('scroll-behavior', 'auto');
    document.querySelectorAll('.scroll-reveal, .fade-in-up').forEach(el => {
      el.classList.add('visible');
    });
  }
});
'@

function Add-AnimationClasses {
    param($content)
    
    # Add animation classes to key elements
    $content = $content -replace '<span class="badge">', '<span class="badge fade-in-up" data-delay="0">'
    $content = $content -replace '<h1>', '<h1 id="hero-title" class="fade-in-up" data-delay="100">'
    $content = $content -replace '(<div class="container hero-content">[\s\S]*?)<p>', '$1<p class="fade-in-up" data-delay="200">'
    $content = $content -replace '<div class="hero-buttons">', '<div class="hero-buttons fade-in-up" data-delay="300">'
    
    # Add scroll-reveal to sections
    $content = $content -replace '(<section id="features"[^>]*>[\s\S]*?)<h2>', '$1<h2 id="features-title" class="scroll-reveal">'
    $content = $content -replace '(<section id="how-it-works"[^>]*>[\s\S]*?)<h2>', '$1<h2 id="how-it-works-title" class="scroll-reveal">'
    $content = $content -replace '(<section id="download"[^>]*>[\s\S]*?)<h2>', '$1<h2 id="cta-title" class="scroll-reveal">'
    
    # Add semantic HTML
    $content = $content -replace '<header class="site-header">', '<header class="site-header" role="banner">'
    $content = $content -replace '<footer class="site-footer">', '<footer class="site-footer" role="contentinfo">'
    $content = $content -replace 'aria-hidden="false"', 'aria-label="Toggle navigation menu" role="button" tabindex="0"'
    $content = $content -replace 'aria-label="Primary"', 'aria-label="Navigation principale"'
    
    # Add aria-hidden to decorative elements
    $content = $content -replace '(<div class="hero-bg")>', '$1 aria-hidden="true">'
    $content = $content -replace '(<span class="icon">)', '$1aria-hidden="true">'
    
    # Add rel attributes to external links
    $content = $content -replace '(href="https://play\.google\.com[^"]*" target="_blank")', '$1 rel="noopener noreferrer"'
    
    # Add image dimensions
    $content = $content -replace '(<img[^>]*shoopt-logo\.png"[^>]*)(>)', '$1 width="44" height="44"$2'
    $content = $content -replace '(class="footer-logo"[^>]*)(>)', '$1 width="80" height="80"$2'
    
    return $content
}

foreach ($langCode in $languages.Keys) {
    $filePath = "$langCode\index.html"
    
    if (-not (Test-Path $filePath)) {
        Write-Host "⚠️  Skipping $langCode - file not found" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "🔄 Processing $($languages[$langCode].name) ($langCode)..." -ForegroundColor Cyan
    
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        
        # Check if already has modern features
        if ($content -match 'application/ld\+json' -and $content -match 'scroll-reveal') {
            Write-Host "   ✓ Already updated" -ForegroundColor Green
            continue
        }
        
        # Add animation classes
        $content = Add-AnimationClasses $content
        
        # Add JavaScript before </body>
        if ($content -notmatch 'Intersection Observer') {
            $content = $content -replace '</body>', "<script>`n$scriptBlock`n</script>`n</body>"
        }
        
        # Add meta theme-color if missing or update it
        $content = $content -replace '<meta name="theme-color" content="[^"]*">', '<meta name="theme-color" content="#f59e0b">'
        if ($content -notmatch 'theme-color') {
            $content = $content -replace '(<meta name="viewport"[^>]*>)', "`$1`n<meta name=`"theme-color`" content=`"#f59e0b`">"
        }
        
        # Save the updated content
        $content | Set-Content $filePath -Encoding UTF8 -NoNewline
        
        Write-Host "   ✅ Updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "   ❌ Error: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✨ Update Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Summary:" -ForegroundColor Cyan
Write-Host "- All language files have been updated with animation classes" -ForegroundColor White
Write-Host "- JavaScript for scroll animations has been added" -ForegroundColor White
Write-Host "- Semantic HTML and ARIA labels improved" -ForegroundColor White
Write-Host "- External links now have rel='noopener noreferrer'" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Note: Full SEO meta tags need manual review for each language" -ForegroundColor Yellow
Write-Host "   to ensure translations are accurate." -ForegroundColor Yellow
Write-Host ""
