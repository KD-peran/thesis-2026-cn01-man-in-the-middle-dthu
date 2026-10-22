# Script ho tro build nhanh tu thu muc goc cua repo bang PowerShell tren Windows.
#
# Cach dung tu thu muc goc:
#   .\build.ps1                           # Mac dinh build khoa-luan.tex
#   .\build.ps1 slide-bao-ve.tex          # Build slide bao ve
#   .\build.ps1 khoa-luan.tex slide-bao-ve.tex # Build ca hai

param(
    [string[]]$TexFiles = @("khoa-luan.tex")
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$latexDir = Join-Path $PSScriptRoot "latex"

if (!(Test-Path $latexDir)) {
    Write-Error "Khong tim thay thu muc latex/."
    exit 1
}

Write-Host "==> Chuyen vao thu muc latex de thuc hien bien dich..." -ForegroundColor Cyan
Push-Location $latexDir
try {
    .\scripts\build.ps1 @TexFiles
} finally {
    Pop-Location
}

Write-Host "`n==> Hoan tat! File PDF dau ra nam tai:" -ForegroundColor Green
foreach ($tex in $TexFiles) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($tex)
    $pdfPath = Join-Path $latexDir "outputs\$base.pdf"
    if (Test-Path $pdfPath) {
        Write-Host "    -> $pdfPath" -ForegroundColor Yellow
    }
}
