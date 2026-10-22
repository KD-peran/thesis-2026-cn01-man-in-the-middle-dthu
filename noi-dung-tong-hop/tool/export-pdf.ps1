<#
.SYNOPSIS
    Script xuất tài liệu Markdown sang PDF (Tích hợp Pipeline Tool Trồng Tool).
#>

[CmdletBinding()]
param(
    [Alias("f")]
    [string]$File = "",

    [Alias("s")]
    [int]$Scale = 2,

    [switch]$DirectOnly
)

$ErrorActionPreference = "Stop"

$toolDir = $PSScriptRoot
if (-not $toolDir) { $toolDir = (Get-Location).Path }
$rootDir = Split-Path -Parent $toolDir
$pipelinePy = Join-Path $toolDir "pipeline.py"

# Nếu không chỉ định DirectOnly, mặc định chạy qua Pipeline Tool Trồng Tool để tự vẽ sơ đồ
if (-not $DirectOnly -and (Test-Path $pipelinePy)) {
    $pyArgs = @($pipelinePy, "--scale", $Scale)
    if ($File) { $pyArgs += @("--file", $File) }
    python @pyArgs
    exit $LASTEXITCODE
}

# Chế độ xuất PDF trực tiếp (dành cho file không có Mermaid hoặc đã có ảnh)
$newDir = Join-Path $rootDir "new"

$browser = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $browser) {
    Write-Host "[LOI] Khong tim thay Google Chrome hoac Microsoft Edge!" -ForegroundColor Red
    exit 1
}

$filesToProcess = @()
if ($File) {
    if (Test-Path $File) { $filesToProcess += (Get-Item $File) }
    elseif (Test-Path (Join-Path $newDir $File)) { $filesToProcess += (Get-Item (Join-Path $newDir $File)) }
} else {
    if (Test-Path $newDir) {
        $filesToProcess = @(Get-ChildItem -Path $newDir -Filter "*.md")
    }
}

foreach ($mdFile in $filesToProcess) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($mdFile.FullName)
    $htmlPath = Join-Path $toolDir ($baseName + ".html")
    $pdfPath = Join-Path $rootDir ($baseName + ".pdf")

    Write-Host "--> Dang xu ly: $($mdFile.Name)" -ForegroundColor Yellow
    node (Join-Path $toolDir "convert_to_pdf.js") "$($mdFile.FullName)" "$htmlPath"

    if (Test-Path $htmlPath) {
        Start-Process -FilePath $browser -ArgumentList @(
            '--headless=new',
            '--disable-gpu',
            '--no-pdf-header-footer',
            "--print-to-pdf=`"$pdfPath`"",
            "`"$htmlPath`""
        ) -Wait

        Remove-Item -Path $htmlPath -Force -ErrorAction SilentlyContinue
        Write-Host "    [OK] Xuat PDF thanh cong: $pdfPath" -ForegroundColor Green
    }
}
