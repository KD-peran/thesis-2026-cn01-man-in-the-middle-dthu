<#
.SYNOPSIS
    Tool tự động quét thư mục new/ và xuất tất cả sơ đồ Mermaid sang ảnh PNG độ phân giải cao.
.DESCRIPTION
    Tương tự như tool export-pdf trong thư mục ke-hoach:
    - Tự động duyệt qua tất cả các file .md / .mmd trong new/
    - Bóc tách mã Mermaid và xuất trực tiếp file .png ra thư mục tool-ve-so-do/
    - Tự động xóa sạch các file thừa/trung gian (.html, .mmd) sau khi xuất xong, chỉ giữ lại file ảnh .png.
    - Nếu new/ trống, mở menu chọn các template sơ đồ chuẩn đề tài khóa luận.
.EXAMPLE
    .\tool\diagram.ps1
.EXAMPLE
    .\tool\diagram.ps1 -File "new\SO_DO_4_TANG.md"
.EXAMPLE
    .\tool\diagram.ps1 -OutputDir "..\latex\images"
#>

[CmdletBinding()]
param(
    [Alias("InputFile", "f")]
    [string]$File = "",

    [ValidateSet("flowchart", "sequence", "architecture", "c4", "erd", "state", "gantt")]
    [string]$Type = "",

    [string]$Name = "",

    [string]$OutputDir = "",

    [switch]$KeepTemp,

    [switch]$Open
)

$ErrorActionPreference = "Stop"

# Thư mục chứa script (tool) và các thư mục dữ liệu
$toolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $toolDir) { $toolDir = (Get-Location).Path }
$rootDir = Split-Path -Parent $toolDir
$newDir = Join-Path $toolDir "new"
$imagesDir = Join-Path $toolDir "images"
$HelperScript = Join-Path $toolDir "export_png.py"
$bom = New-Object System.Text.UTF8Encoding $true

# Danh sách template Mermaid chuẩn
$Templates = @{
    "flowchart" = @{
        Title = "Sơ đồ giải thuật / Luồng xử lý dữ liệu"
        Code = @"
flowchart TD
    classDef startEnd fill:#10b981,stroke:#059669,stroke-width:2px,color:#fff,rx:15px;
    classDef process fill:#3b82f6,stroke:#2563eb,stroke-width:2px,color:#fff,rx:5px;
    classDef decision fill:#f59e0b,stroke:#d97706,stroke-width:2px,color:#fff;
    classDef error fill:#ef4444,stroke:#dc2626,stroke-width:2px,color:#fff;

    Start(["Bắt đầu"]):::startEnd --> ReadData["Đọc dữ liệu từ cảm biến IoT<br/>(Nhiệt độ, Độ ẩm, RFID)"]:::process
    ReadData --> Validate{"Dữ liệu hợp lệ?"}:::decision
    
    Validate -- Không --> LogError["Ghi log cảnh báo & Huỷ mẫu"]:::error
    LogError --> ReadData
    
    Validate -- Có --> HashData["Tạo Hash SHA-256 gói tin"]:::process
    HashData --> SignTx["Ký số bằng Private Key thiết bị"]:::process
    SignTx --> SendChain["Gửi Transaction lên Smart Contract"]:::process
    
    SendChain --> CheckReceipt{"Tx hoàn tất thành công?"}:::decision
    CheckReceipt -- Không --> Retry["Thử lại (Tối đa 3 lần)"]:::error
    Retry --> SendChain
    
    CheckReceipt -- Có --> EmitEvent["Phát sự kiện Event Logged"]:::process
    EmitEvent --> UpdateUI["Cập nhật Dashboard Giám sát Kho"]:::process
    UpdateUI --> Finish(["Kết thúc"]):::startEnd
"@
    }

    "sequence" = @{
        Title = "Sơ đồ tuần tự tương tác (IoT - Gateway - Blockchain - IPFS)"
        Code = @"
sequenceDiagram
    autonumber
    actor Tech as Kỹ thuật viên / Quản kho
    participant Sensor as Thiết bị IoT (ESP32)
    participant Gateway as Edge Gateway / API
    participant SC as Smart Contract
    participant BC as Blockchain Node
    participant DB as Off-chain Storage (IPFS)

    Tech->>Sensor: Kích hoạt quét mã RFID / Cảm biến
    Sensor->>Sensor: Thu thập chỉ số (Temp, Humidity, ID)
    Sensor->>Gateway: Gửi gói tin qua MQTT / HTTPS
    activate Gateway
    Gateway->>Gateway: Kiểm tra chữ ký & Chuẩn hoá dữ liệu
    Gateway->>DB: Lưu payload chi tiết lên IPFS
    DB-->>Gateway: Trả về CID (IPFS Hash)
    
    Gateway->>SC: Gọi hàm recordSensorData(batchId, CID, hash)
    activate SC
    SC->>BC: Đóng gói giao dịch vào Block mới
    BC-->>SC: Xác nhận Block (TxHash)
    SC-->>Gateway: Event Log: DataRecorded(batchId, timestamp)
    deactivate SC
    
    Gateway-->>Tech: Thông báo ghi nhận thành công
    deactivate Gateway
"@
    }

    "architecture" = @{
        Title = "Sơ đồ kiến trúc phân tầng hệ thống (Architecture Layer)"
        Code = @"
flowchart TB
    subgraph UI_LAYER ["1. Tầng Giao diện (Presentation Layer)"]
        direction LR
        Dashboard["Web Dashboard<br/>(React / Next.js)"]
        MobileApp["Mobile App Quản kho<br/>(Flutter / React Native)"]
        AlertSys["Hệ thống Cảnh báo<br/>(Email / Telegram Bot)"]
    end

    subgraph APP_LAYER ["2. Tầng Ứng dụng & Dịch vụ (Application & Gateway Layer)"]
        direction LR
        ApiGateway["API Gateway / Backend<br/>(Node.js / Express)"]
        MqttBroker["MQTT Broker<br/>(EMQX / Mosquitto)"]
        Worker["Background Worker<br/>(Cron / Event Listener)"]
    end

    subgraph IOT_LAYER ["3. Tầng Thiết bị IoT (Perception / Hardware Layer)"]
        direction LR
        RFID["Đầu đọc RFID<br/>(RC522)"]
        DHT["Cảm biến Nhiệt Ẩm<br/>(DHT22 / SHT30)"]
        ESP["Vi điều khiển<br/>(ESP32 Gateway)"]
    end

    subgraph BC_LAYER ["4. Tầng Blockchain & Lưu trữ (Blockchain & Storage Layer)"]
        direction LR
        SmartContract["Smart Contracts<br/>(Solidity / Hardhat)"]
        EthereumNet["Mạng Blockchain<br/>(Private/Public Testnet)"]
        IPFS["Lưu trữ phân tán<br/>(IPFS / Filecoin)"]
    end

    RFID --> ESP
    DHT --> ESP
    ESP -->|MQTT / TLS| MqttBroker
    MqttBroker --> ApiGateway
    ApiGateway <--> Dashboard
    ApiGateway <--> MobileApp
    Worker --> AlertSys

    ApiGateway <-->|Web3.js / Ethers.js| SmartContract
    ApiGateway -->|Upload Metadata| IPFS
    SmartContract --- EthereumNet
"@
    }

    "c4" = @{
        Title = "Sơ đồ ngữ cảnh hệ thống (C4 Context Diagram)"
        Code = @"
C4Context
    title Sơ đồ ngữ cảnh hệ thống Quản lý Kho IoT - Blockchain

    Person(admin, "Quản lý Kho", "Giám sát lô hàng, nhiệt độ bảo quản và lịch sử giao dịch.")
    Person(auditor, "Kiểm toán viên / Khách hàng", "Tra cứu nguồn gốc xuất xứ và kiểm định tính toàn vẹn.")
    
    System(sys, "Hệ thống Quản lý Kho IoT - Blockchain", "Tiếp nhận dữ liệu cảm biến, lưu trữ bằng chứng bất biến và cảnh báo tự động.")
    
    System_Ext(iot, "Mạng cảm biến IoT", "Thu thập nhiệt độ, độ ẩm và thông tin vị trí lô hàng.")
    System_Ext(blockchain, "Mạng Blockchain", "Lưu trữ Smart Contract và xác thực giao dịch.")
    System_Ext(ipfs, "Hệ thống IPFS", "Lưu trữ hình ảnh, tài liệu hóa đơn và dữ liệu cảm biến lớn.")

    Rel(admin, sys, "Quản lý lô hàng, cấu hình ngưỡng cảnh báo", "HTTPS")
    Rel(auditor, sys, "Tra cứu lịch sử và xác thực Hash", "HTTPS")
    Rel(iot, sys, "Gửi dữ liệu quan trắc định kỳ", "MQTT / REST")
    Rel(sys, blockchain, "Ghi hash dữ liệu và thực thi logic hợp đồng", "JSON-RPC")
    Rel(sys, ipfs, "Đẩy dữ liệu chi tiết và nhận CID", "IPFS API")
"@
    }

    "erd" = @{
        Title = "Sơ đồ thực thể CSDL (Entity Relationship Diagram - ERD)"
        Code = @"
erDiagram
    WAREHOUSE ||--o{ STORAGE_LOCATION : contains
    STORAGE_LOCATION ||--o{ BATCH : stores
    BATCH ||--o{ SENSOR_LOG : generates
    BATCH ||--o{ BLOCKCHAIN_TX : recorded_in

    WAREHOUSE {
        string warehouse_id PK
        string name
        string address
        int max_capacity
    }

    STORAGE_LOCATION {
        string location_id PK
        string warehouse_id FK
        string zone_name
        string shelf_number
    }

    BATCH {
        string batch_id PK
        string product_name
        string rfid_tag UK
        datetime created_at
        string status
        float min_temp
        float max_temp
    }

    SENSOR_LOG {
        string log_id PK
        string batch_id FK
        float temperature
        float humidity
        datetime recorded_at
        string device_id
        string data_hash
    }

    BLOCKCHAIN_TX {
        string tx_hash PK
        string batch_id FK
        int block_number
        string contract_address
        string ipfs_cid
        datetime timestamp
    }
"@
    }

    "state" = @{
        Title = "Sơ đồ trạng thái lô hàng (State Machine)"
        Code = @"
stateDiagram-v2
    [*] --> KhoiTao: Tạo lô hàng mới & Gán RFID
    KhoiTao --> NhapKho: Xác nhận kiểm đếm vào kho
    
    state NhapKho {
        [*] --> LuuKhoAnToan
        LuuKhoAnToan --> CanhBaoNhietDo: Nhiệt độ vượt ngưỡng
        CanhBaoNhietDo --> LuuKhoAnToan: Điều chỉnh nhiệt độ về mức an toàn
        CanhBaoNhietDo --> HongHang: Vượt ngưỡng quá thời gian quy định
    }

    NhapKho --> XuatKho: Tạo lệnh xuất kho
    XuatKho --> DangVanChuyen: Bàn giao đơn vị vận chuyển
    
    state DangVanChuyen {
        [*] --> GiamSatHanhTrinh
        GiamSatHanhTrinh --> CanhBaoVanChuyen: Va chạm hoặc nhiệt độ sai lệch
    }

    DangVanChuyen --> GiaoThanhCong: Người nhận ký nhận Smart Contract
    DangVanChuyen --> TraHang: Sự cố vi phạm điều kiện bảo quản
    
    HongHang --> [*]
    GiaoThanhCong --> [*]
    TraHang --> [*]
"@
    }

    "gantt" = @{
        Title = "Sơ đồ tiến độ thực hiện đề tài (Gantt Chart)"
        Code = @"
gantt
    title Kế hoạch & Tiến độ Khóa luận Tốt nghiệp
    dateFormat  YYYY-MM-DD
    section Nghiên cứu & Khảo sát
    Khảo sát tài liệu & Đề cương       :done,    des1, 2026-01-05, 2026-01-20
    Nghiên cứu Blockchain & Smart Contract:done, des2, 2026-01-21, 2026-02-15
    section Thiết kế & Phát triển
    Thiết kế phần cứng & Mạch IoT     :active,  dev1, 2026-02-16, 2026-03-10
    Phát triển Smart Contract & Backend:active, dev2, 2026-03-01, 2026-03-25
    Phát triển Dashboard Giám sát     :         dev3, 2026-03-20, 2026-04-10
    section Thử nghiệm & Viết báo cáo
    Tích hợp & Đánh giá hiệu năng     :         test1, 2026-04-10, 2026-04-25
    Hoàn thiện Khóa luận & Slide      :         doc1,  2026-04-20, 2026-05-10
    Bảo vệ khóa luận tốt nghiệp       :milestone, m1, 2026-05-15, 0d
"@
    }
}

function Process-SingleDiagram {
    param (
        [string]$SourcePath,
        [string]$TargetDir,
        [string]$CustomName = ""
    )

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($SourcePath)
    if ($CustomName) { $baseName = $CustomName }

    $fileContent = [System.IO.File]::ReadAllText($SourcePath, [System.Text.Encoding]::UTF8)

    # Nếu là markdown, bóc tách khối ```mermaid ... ```
    if ($fileContent -match '(?ms)```mermaid\s*(.*?)\s*```') {
        $mermaidOnly = $matches[1].Trim()
    } else {
        $mermaidOnly = $fileContent.Trim()
    }

    # Đặt file mmd tạm trong thư mục tool để tránh làm bừa thư mục đích
    $tempMmd = Join-Path $toolDir "temp_$baseName.mmd"
    $pngOut = Join-Path $TargetDir "$baseName.png"

    # Ghi file tạm .mmd
    [System.IO.File]::WriteAllText($tempMmd, $mermaidOnly, $bom)

    Write-Host ""
    Write-Host ("--> Đang xử lý: {0}" -f [System.IO.Path]::GetFileName($SourcePath)) -ForegroundColor Yellow
    Write-Host "    [1/2] Đã bóc tách mã Mermaid..." -ForegroundColor Gray
    Write-Host "    [2/2] Đang render ảnh PNG độ nét cao (HD)..." -ForegroundColor Gray

    $pngDone = $false
    try {
        if (Test-Path $HelperScript) {
            python $HelperScript $tempMmd $pngOut | Out-Null
            if ($LASTEXITCODE -eq 0 -and (Test-Path $pngOut)) {
                $sizeKb = [Math]::Round((Get-Item $pngOut).Length / 1024, 1)
                Write-Host "    [OK] XUẤT ẢNH PNG THÀNH CÔNG!" -ForegroundColor Green
                Write-Host ("         File ảnh: {0}.png ({1} KB)" -f $baseName, $sizeKb) -ForegroundColor Yellow
                Write-Host ("         Lưu tại : {0}" -f $pngOut) -ForegroundColor Gray
                $pngDone = $true
            }
        }
    } catch { }

    # XÓA FILE TẠM/THỪA (.mmd, .html nếu có) để giữ thư mục tuyệt đối sạch đẹp
    if (-not $KeepTemp) {
        if (Test-Path $tempMmd) { Remove-Item -Path $tempMmd -Force -ErrorAction SilentlyContinue }
        
        # Xoá các file .html hoặc .mmd trung gian trong targetDir nếu có
        $junkHtml = Join-Path $TargetDir "$baseName.html"
        $junkMmd = Join-Path $TargetDir "$baseName.mmd"
        if (Test-Path $junkHtml) { Remove-Item -Path $junkHtml -Force -ErrorAction SilentlyContinue }
        if (Test-Path $junkMmd) { Remove-Item -Path $junkMmd -Force -ErrorAction SilentlyContinue }
    }

    if (-not $pngDone) {
        Write-Host "    [LOI] Không thể xuất file PNG cho $baseName" -ForegroundColor Red
        return $false
    }

    return $pngOut
}

# --- BẮT ĐẦU ĐIỀU HƯỚNG ---

# Xác định thư mục đích xuất file PNG (Mặc định: thư mục tool/images)
$destinationDir = $imagesDir
if ($OutputDir) {
    if ([System.IO.Path]::IsPathRooted($OutputDir)) {
        $destinationDir = $OutputDir
    } else {
        $destinationDir = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputDir))
    }
}
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
}

$lastPngCreated = $null

# TRƯỜNG HỢP 1: Người dùng truyền file cụ thể (-File)
if ($File) {
    $targetFile = $null
    $candidates = @(
        $File,
        (Join-Path (Get-Location) $File),
        (Join-Path $newDir $File),
        (Join-Path $rootDir $File)
    )
    foreach ($c in $candidates) {
        if (Test-Path $c) { $targetFile = (Resolve-Path $c).Path; break }
    }

    if (-not $targetFile) {
        Write-Host ("[LỖI] Không tìm thấy file nguồn: {0}" -f $File) -ForegroundColor Red
        exit 1
    }

    $lastPngCreated = Process-SingleDiagram -SourcePath $targetFile -TargetDir $destinationDir -CustomName $Name
}
# TRƯỜNG HỢP 2: Chạy theo template cụ thể (-Type)
elseif ($Type) {
    $templateData = $Templates[$Type]
    if (-not $templateData) {
        Write-Error "Loại sơ đồ '$Type' không hợp lệ."
        exit 1
    }

    if (-not $Name) { $Name = "diagram_$Type" }
    $tempFile = Join-Path $toolDir "temp_$Name.mmd"
    [System.IO.File]::WriteAllText($tempFile, $templateData.Code, $bom)
    $lastPngCreated = Process-SingleDiagram -SourcePath $tempFile -TargetDir $destinationDir -CustomName $Name
}
# TRƯỜNG HỢP 3: Mặc định quét tự động TOÀN BỘ file trong thư mục new/
else {
    $filesInNew = @()
    if (Test-Path $newDir) {
        $filesInNew = @(Get-ChildItem -Path $newDir -File -Recurse | Where-Object { $_.Extension -in '.md', '.mmd' })
    }

    if ($filesInNew.Count -gt 0) {
        Write-Host "=================================================" -ForegroundColor Cyan
        Write-Host (" TÌM THẤY {0} FILE SƠ ĐỒ TRONG THƯ MỤC 'new':" -f $filesInNew.Count) -ForegroundColor Green
        foreach ($f in $filesInNew) {
            Write-Host ("  + {0}" -f $f.Name) -ForegroundColor White
        }
        Write-Host "=================================================" -ForegroundColor Cyan

        $successCount = 0
        foreach ($f in $filesInNew) {
            $createdPng = Process-SingleDiagram -SourcePath $f.FullName -TargetDir $destinationDir
            if ($createdPng) {
                $lastPngCreated = $createdPng
                $successCount++
            }
        }

        # Dọn dẹp sạch sẽ mọi file .html và .mmd thừa còn sót lại trong thư mục đích
        if (-not $KeepTemp) {
            Get-ChildItem -Path $destinationDir -Filter "*.html" | Remove-Item -Force -ErrorAction SilentlyContinue
            Get-ChildItem -Path $destinationDir -Filter "*.mmd" | Remove-Item -Force -ErrorAction SilentlyContinue
            Get-ChildItem -Path $toolDir -Filter "temp_*.mmd" | Remove-Item -Force -ErrorAction SilentlyContinue
        }

        Write-Host ""
        Write-Host "=================================================" -ForegroundColor Green
        Write-Host (" HOÀN TẤT: Đã xuất {0}/{1} file PNG ra thư mục '{2}'!" -f $successCount, $filesInNew.Count, [System.IO.Path]::GetFileName($destinationDir)) -ForegroundColor Green
        Write-Host " (Đã tự động xóa sạch các file thừa .html, .mmd)" -ForegroundColor Gray
        Write-Host "=================================================" -ForegroundColor Green
    }
    # Nếu trong new/ không có file nào -> Hiển thị Menu template tương tác
    else {
        Clear-Host
        Write-Host "==========================================================" -ForegroundColor Cyan
        Write-Host "  🚀 CÔNG CỤ TỰ ĐỘNG XUẤT SƠ ĐỒ MERMAID SANG ẢNH PNG      " -ForegroundColor Yellow
        Write-Host "==========================================================" -ForegroundColor Cyan
        Write-Host "Không tìm thấy file nào trong thư mục 'new/'.`nChọn mẫu sơ đồ bạn muốn tạo nhanh:`n"

        Write-Host "  [1] Flowchart       - Sơ đồ thuật toán / Luồng xử lý dữ liệu" -ForegroundColor White
        Write-Host "  [2] Sequence        - Sơ đồ tuần tự (IoT -> Gateway -> Chain -> IPFS)" -ForegroundColor White
        Write-Host "  [3] Architecture    - Sơ đồ kiến trúc phân tầng (4 Tầng Hệ thống)" -ForegroundColor White
        Write-Host "  [4] C4 Context      - Sơ đồ ngữ cảnh C4 (Người dùng & Hệ thống bên ngoài)" -ForegroundColor White
        Write-Host "  [5] ERD             - Sơ đồ thực thể CSDL quan hệ / Lô hàng kho" -ForegroundColor White
        Write-Host "  [6] State Machine   - Sơ đồ trạng thái (Vòng đời lô hàng trong kho)" -ForegroundColor White
        Write-Host "  [7] Gantt Chart     - Sơ đồ tiến độ thực hiện đề tài" -ForegroundColor White
        Write-Host ""

        $choice = Read-Host "Nhập lựa chọn (1-7) [Mặc định: 1]"
        if (-not $choice) { $choice = "1" }

        $selectedType = switch ($choice) {
            "1" { "flowchart" }
            "2" { "sequence" }
            "3" { "architecture" }
            "4" { "c4" }
            "5" { "erd" }
            "6" { "state" }
            "7" { "gantt" }
            default { "flowchart" }
        }

        $templateData = $Templates[$selectedType]
        $defName = "diagram_$selectedType"
        $inName = Read-Host "Nhập tên file sơ đồ [Mặc định: $defName]"
        if ([string]::IsNullOrWhiteSpace($inName)) { $inName = $defName }

        $tempFile = Join-Path $toolDir "temp_$inName.mmd"
        [System.IO.File]::WriteAllText($tempFile, $templateData.Code, $bom)
        $lastPngCreated = Process-SingleDiagram -SourcePath $tempFile -TargetDir $destinationDir -CustomName $inName
    }
}

Write-Host "`n💡 Mẹo chèn vào LaTeX (khoa-luan.tex):" -ForegroundColor White
Write-Host "  \begin{figure}[htbp]" -ForegroundColor DarkGray
Write-Host "      \centering" -ForegroundColor DarkGray
Write-Host "      \includegraphics[width=0.95\textwidth]{images/TEN_SO_DO.png}" -ForegroundColor Yellow
Write-Host "      \caption{Mô tả chi tiết sơ đồ}" -ForegroundColor DarkGray
Write-Host "      \label{fig:TEN_SO_DO}" -ForegroundColor DarkGray
Write-Host "  \end{figure}" -ForegroundColor DarkGray

if ($Open -and $lastPngCreated -and (Test-Path $lastPngCreated)) {
    Start-Process $lastPngCreated
}
