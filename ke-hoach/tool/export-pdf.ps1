param(
    [string]$File = ""
)

$ErrorActionPreference = "Stop"

# Thư mục chứa script (ke-hoach/tool) và thư mục gốc (ke-hoach)
$toolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $toolDir) { $toolDir = (Get-Location).Path }
$rootDir = Split-Path -Parent $toolDir
$newDir = Join-Path $rootDir "new"

# 1. Tìm trình duyệt Chrome hoặc Edge
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
$browserName = [System.IO.Path]::GetFileNameWithoutExtension($browser)

# 2. Xác định danh sách các file Markdown cần xử lý
$filesToProcess = @()

if ($File) {
    # Nếu người dùng truyền tên file cụ thể
    $targetFile = $null
    if ([System.IO.Path]::IsPathRooted($File) -and (Test-Path $File)) {
        $targetFile = $File
    } else {
        $candidates = @(
            (Join-Path (Get-Location).Path $File),
            (Join-Path $newDir $File),
            (Join-Path $rootDir $File)
        )
        foreach ($c in $candidates) {
            if (Test-Path $c) { $targetFile = $c; break }
        }
    }
    if ($targetFile) {
        $filesToProcess += (Get-Item $targetFile)
    } else {
        Write-Host ("[LOI] Khong tim thay file: {0}" -f $File) -ForegroundColor Red
        exit 1
    }
} else {
    # Chế độ tự động: Quét toàn bộ file .md trong thư mục ke-hoach/new
    if (Test-Path $newDir) {
        $filesToProcess = @(Get-ChildItem -Path $newDir -Filter "*.md")
    }
    
    # Nếu trong new/ không có, quét thử thư mục cha ke-hoach
    if ($filesToProcess.Count -eq 0) {
        $filesToProcess = @(Get-ChildItem -Path $rootDir -Filter "Weekly*.md")
    }
}

if ($filesToProcess.Count -eq 0) {
    Write-Host "[THONG BAO] Khong tim thay file .md nao trong thu muc 'new' de xuat PDF!" -ForegroundColor Yellow
    exit 0
}

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host (" TIM THAY {0} FILE TRONG THU MUC 'new':" -f $filesToProcess.Count) -ForegroundColor Green
foreach ($f in $filesToProcess) {
    Write-Host ("  + {0}" -f $f.Name) -ForegroundColor White
}
Write-Host "=================================================" -ForegroundColor Cyan

$successCount = 0

foreach ($mdFile in $filesToProcess) {
    $fileName = $mdFile.Name
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($mdFile.FullName)
    
    # HTML trung gian đặt trong thư mục tool
    $htmlName = ($baseName -replace '\s+', '_') + ".html"
    $htmlPath = Join-Path $toolDir $htmlName
    
    # PDF xuất đưa ra thư mục bên ngoài (ke-hoach)
    $pdfName = $baseName + ".pdf"
    $pdfPath = Join-Path $rootDir $pdfName

    Write-Host ""
    Write-Host ("--> Dang xu ly: {0}" -f $fileName) -ForegroundColor Yellow
    Write-Host "    [1/2] Bien dich Markdown sang HTML..." -ForegroundColor Gray

    node (Join-Path $toolDir "convert_to_pdf.js") "$($mdFile.FullName)"

    if (-not (Test-Path $htmlPath)) {
        Write-Host ("    [LOI] Khong tao duoc HTML cho {0}" -f $fileName) -ForegroundColor Red
        continue
    }

    Write-Host "    [2/2] Dang xuat PDF qua $browserName Headless..." -ForegroundColor Gray

    Start-Process -FilePath $browser -ArgumentList @(
        '--headless=new',
        '--disable-gpu',
        '--no-pdf-header-footer',
        "--print-to-pdf=`"$pdfPath`"",
        "`"$htmlPath`""
    ) -Wait

    if (Test-Path $pdfPath) {
        # Xóa file HTML trung gian
        if (Test-Path $htmlPath) {
            Remove-Item -Path $htmlPath -Force
        }
        $sizeKb = [Math]::Round((Get-Item $pdfPath).Length / 1024, 1)
        Write-Host "    [OK] XUAT THANH CONG!" -ForegroundColor Green
        Write-Host ("         File PDF: {0} ({1} KB)" -f $pdfName, $sizeKb) -ForegroundColor Yellow
        Write-Host ("         Luu tai : {0}" -f $pdfPath) -ForegroundColor Gray
        $successCount++
    } else {
        Write-Host ("    [LOI] Khong the tao file PDF cho {0}" -f $fileName) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Green
Write-Host (" HOAN TAT: Da xuat {0}/{1} file PDF ra thu muc 'ke-hoach'!" -f $successCount, $filesToProcess.Count) -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green
