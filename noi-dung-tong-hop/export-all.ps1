<#
.SYNOPSIS
    Pipeline Tự Động Toàn Diện (Tool Trồng Tool):
    Tách Mermaid -> Render PNG HD -> Nhúng vào Tài Liệu -> Xuất PDF Chuẩn Học Thuật.
.DESCRIPTION
    Tự động hóa toàn bộ quy trình trong duy nhất 1 thư mục 'tool/':
    1. Đọc file Markdown (.md) trong thư mục new/ (Ví dụ: tong-hop-lan-1.md)
    2. Tra từ trên xuống dưới các khối ```mermaid ... ```
    3. Tách từng khối ra file riêng trong tool/new/ (<tên-gốc>-1.md, <tên-gốc>-2.md, ...)
    4. Kích hoạt Tool vẽ sơ đồ (export_png.py) xuất ảnh PNG HD vào tool/images/ (<tên-gốc>-1.png, ...)
    5. Thay thế khối mã trong tài liệu bằng thẻ ảnh có khung viền & chú thích (Caption)
    6. Kích hoạt Tool xuất PDF (convert_to_pdf.js + Chrome/Edge Headless) xuất ra file PDF hoàn chỉnh
.EXAMPLE
    .\export-all.ps1
.EXAMPLE
    .\export-all.ps1 -File "new\tong-hop-lan-1.md"
.EXAMPLE
    .\export-all.ps1 -Scale 3
#>

[CmdletBinding()]
param(
    [Alias("f", "InputFile")]
    [string]$File = "",

    [Alias("s")]
    [int]$Scale = 2
)

$ErrorActionPreference = "Stop"

# Thiết lập UTF-8 Console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Xác định đường dẫn thư mục gốc noi-dung-tong-hop
$rootDir = $PSScriptRoot
if (-not $rootDir) { $rootDir = (Get-Location).Path }
$toolDir = Join-Path $rootDir "tool"
$pipelinePy = Join-Path $toolDir "pipeline.py"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   PIPELINE TU DONG 'TOOL TRONG TOOL' - KHOA LUAN TOT NGHIEP     " -ForegroundColor Yellow
Write-Host "   Mermaid -> Tach File -> Ve Anh PNG -> Nhung Tai Lieu -> PDF   " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan

# Kiểm tra Python
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    Write-Host "[LOI] Khong tim thay Python trong he thong PATH!" -ForegroundColor Red
    exit 1
}

# Kiểm tra Node.js
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) {
    Write-Host "[LOI] Khong tim thay Node.js trong he thong PATH!" -ForegroundColor Red
    exit 1
}

# Chuẩn bị tham số chạy pipeline.py
$pyArgs = @($pipelinePy, "--scale", $Scale)
if ($File) {
    $pyArgs += @("--file", $File)
}

# Thực thi pipeline Python
python @pyArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host ">>> [HOAN TAT] Pipeline da thuc thi thanh cong xuat sac! <<<" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host ">>> [CANH BAO] Pipeline ket thuc voi ma loi: $LASTEXITCODE" -ForegroundColor Red
}
