# Build ban LaTeX cua khoa luan (bao cao hoac slide bao ve) bang PowerShell tren Windows.
# Dung pdflatex + biber truc tiep.
# Cach dung (chay tu trong thu muc latex/):
#   .\scripts\build.ps1 khoa-luan.tex
#   .\scripts\build.ps1 slide-bao-ve.tex
#   .\scripts\build.ps1 khoa-luan.tex slide-bao-ve.tex

param(
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$TexFiles
)

$ErrorActionPreference = "Stop"

# Them MiKTeX vao PATH neu co
$MiktexPath = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"
if (Test-Path $MiktexPath) {
    if ($env:PATH -notmatch [regex]::Escape($MiktexPath)) {
        $env:PATH = "$MiktexPath;$env:PATH"
    }
}

# Tao thu muc outputs neu chua co
if (!(Test-Path "outputs")) {
    New-Item -ItemType Directory -Path "outputs" | Out-Null
}

foreach ($tex in $TexFiles) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($tex)
    Write-Host "==> Build: $tex" -ForegroundColor Cyan

    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Loi bien dich pdflatex cho $tex"
        exit 1
    }

    if (Test-Path "$base.bcf") {
        Write-Host "==> Chay biber: $base" -ForegroundColor Yellow
        try {
            & biber "$base"
        } catch {
            Write-Warning "biber bao loi. Danh muc tai lieu tham khao co the trong neu .bib chua co muc nao."
        }
    }

    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"
    & pdflatex -interaction=nonstopmode -halt-on-error "$tex"

    if (Test-Path "$base.pdf") {
        Move-Item "$base.pdf" -Destination "outputs\" -Force
        Write-Host "==> Da chuyen $base.pdf -> outputs/" -ForegroundColor Green
    }

    # Xoa cac file trung gian
    $exts = @("aux", "bbl", "bcf", "blg", "fdb_latexmk", "fls", "log", "nav", "out", "run.xml", "snm", "synctex.gz", "toc", "lof", "lot")
    foreach ($ext in $exts) {
        if (Test-Path "$base.$ext") {
            Remove-Item "$base.$ext" -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "Xong. PDF nam trong outputs/." -ForegroundColor Green
