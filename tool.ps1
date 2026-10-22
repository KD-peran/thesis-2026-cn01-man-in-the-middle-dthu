<#
.SYNOPSIS
    Trung Tam Dieu Khien & Khoi Chay Cong Cu (Tool Launcher Hub)
    De tai: Nghien cuu ky thuat khai thac va phong chong tan cong Man-in-the-Middle
    Sinh vien: Nguyen Thi Ky Duyen (0023410647) - GVHD: TS. Luong Thai Ngoc
.DESCRIPTION
    Menu tuong tac 1-cham giup xem tai lieu Docsify, bien dich LaTeX, kiem tra trich dan va mo thu muc PDF.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Target = ""
)

$ErrorActionPreference = "Continue"

$rootDir = $PSScriptRoot
if (-not $rootDir) { $rootDir = (Get-Location).Path }

function Show-Header {
    Clear-Host
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "   TRUNG TAM DIEU KHIEN & KHOI CHAY CONG CU (TOOL LAUNCHER HUB)       " -ForegroundColor Yellow
    Write-Host "   Nghien cuu Ky thuat Khai thac & Phong chong Tan cong MitM (2026)   " -ForegroundColor White
    Write-Host "   SV: Nguyen Thi Ky Duyen (0023410647) - GVHD: TS. Luong Thai Ngoc   " -ForegroundColor Green
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Write-Host "--- [ CHUC NANG CHINH ] ---" -ForegroundColor Green
    Write-Host "  [1]  [DOCS DASHBOARD] Khoi chay may chu xem Docsify tren localhost:3000" -ForegroundColor White
    Write-Host "  [2]  [LATEX BAO CAO]  Bien dich Bao cao Khoa luan (khoa-luan.tex -> outputs/)" -ForegroundColor White
    Write-Host "  [3]  [LATEX SLIDE]    Bien dich Slide thuyet trinh bao ve (slide-bao-ve.tex)" -ForegroundColor White
    Write-Host "  [4]  [KIEM TRA CITATION] Doi chieu trich dan trong LaTeX voi file .bib" -ForegroundColor White
    Write-Host "  [5] hoac [A] [BIEN DICH TAT CA] Build toan bo PDF va cap nhat vao docs/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "--- [ TIEN ICH ] ---" -ForegroundColor Green
    Write-Host "  [O]  Mo thu muc chua file PDF (latex/outputs) trong Windows Explorer" -ForegroundColor Cyan
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [0] hoac [Q] : Thoat chuong trinh" -ForegroundColor DarkYellow
    Write-Host "======================================================================" -ForegroundColor Cyan
}

function Invoke-Task {
    param([string]$c)
    $choice = $c.Trim().ToUpper()

    if ($choice -eq "1") {
        Write-Host "Dang dong bo tai lieu moi nhat vao docs/..." -ForegroundColor Cyan
        Copy-Item -Path (Join-Path $rootDir "thu-tuc-khoa") -Destination (Join-Path $rootDir "docs\thu-tuc-khoa") -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item -Path (Join-Path $rootDir "huong-dan") -Destination (Join-Path $rootDir "docs\huong-dan") -Recurse -Force -ErrorAction SilentlyContinue
        Copy-Item -Path (Join-Path $rootDir "Cau-truc-toan-repo.md") -Destination (Join-Path $rootDir "docs\Cau-truc-toan-repo.md") -Force -ErrorAction SilentlyContinue
        
        Write-Host "Khoi chay may chu Docsify xem tai lieu tren trinh duyet..." -ForegroundColor Yellow
        $docsDir = Join-Path $rootDir "docs"
        Start-Process "http://localhost:3000"
        npx -y serve -l 3000 "$docsDir"
    }
    elseif ($choice -eq "2") {
        Write-Host "Bien dich Bao cao Khoa luan (khoa-luan.tex)..." -ForegroundColor Yellow
        $scriptPath = Join-Path $rootDir "build.ps1"
        powershell -ExecutionPolicy Bypass -File $scriptPath "khoa-luan.tex"
    }
    elseif ($choice -eq "3") {
        Write-Host "Bien dich Slide thuyet trinh bao ve (slide-bao-ve.tex)..." -ForegroundColor Yellow
        $scriptPath = Join-Path $rootDir "build.ps1"
        powershell -ExecutionPolicy Bypass -File $scriptPath "slide-bao-ve.tex"
    }
    elseif ($choice -eq "4") {
        Write-Host "Dang kiem tra tinh nhat quan cua tai lieu tham khao..." -ForegroundColor Yellow
        $nodeScript = Join-Path $rootDir ".github\scripts\kiem_tra_trich_dan.js"
        if (Test-Path $nodeScript) {
            node $nodeScript
        } else {
            $checkScript = Join-Path $rootDir ".github\scripts\kiem_tra_trich_dan.py"
            python $checkScript
        }
    }
    elseif ($choice -in @("5", "A")) {
        Write-Host "Bien dich toan bo he thong an pham (Bao cao + Slide)..." -ForegroundColor Yellow
        $scriptPath = Join-Path $rootDir "build.ps1"
        powershell -ExecutionPolicy Bypass -File $scriptPath "khoa-luan.tex" "slide-bao-ve.tex"
        
        $srcDir = Join-Path $rootDir "latex\outputs"
        $dstDir = Join-Path $rootDir "docs\downloads"
        if (!(Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir | Out-Null }
        Copy-Item "$srcDir\*.pdf" -Destination $dstDir -Force
        Write-Host "Da dong bo PDF sang docs/downloads/ thanh cong!" -ForegroundColor Green
    }
    elseif ($choice -eq "O") {
        $pdfFolder = Join-Path $rootDir "latex\outputs"
        if (Test-Path $pdfFolder) { Start-Process explorer.exe $pdfFolder }
        else { Write-Host "Chua co thu muc outputs/." -ForegroundColor Red }
    }
    else {
        Write-Host "Lua chon khong hop le: $c" -ForegroundColor Red
    }
}

if ($Target -ne "") {
    Invoke-Task $Target
    exit 0
}

while ($true) {
    Show-Header
    Show-Menu
    Write-Host ""
    $inputVal = Read-Host "Nhap lua chon cua ban (vi du: 1, 2, 3, 4, 5, A, O, Q)"
    if ($inputVal -in @("0", "Q", "q", "exit", "quit")) {
        Write-Host "Tam biet va chuc ban hoan thanh xuat sac khoa luan!" -ForegroundColor Cyan
        break
    }
    Invoke-Task $inputVal
    Write-Host "`nNhan Enter de tiep tuc..." -ForegroundColor Gray
    [void][System.Console]::ReadLine()
}
