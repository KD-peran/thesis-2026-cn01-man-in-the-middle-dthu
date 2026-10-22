/**
 * Script dong goi ho so nien luan theo quy dinh cua Khoa CN&KT - Truong DH Dong Thap
 * Sinh vien: Nguyen Thi Ky Duyen (MSSV: 0023410647)
 * Giang vien huong dan: ThS. Trinh Le Hoang Tuan
 * Thoi gian thuc hien: 19/10/2026 - 19/12/2026 | Han nop: Truoc 21/12/2026
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const rootDir = path.resolve(__dirname, '..', '..');
const packageDirName = '0023410647_NguyenThiKyDuyen';
const targetDir = path.join(rootDir, packageDirName);
const topZipPath = path.join(rootDir, `${packageDirName}.zip`);

console.log('======================================================================');
console.log('   TIEN HANH DONG GOI HO SO NIEN LUAN: ' + packageDirName);
console.log('   GVHD: ThS. Trinh Le Hoang Tuan | Han nop: Truoc 21/12/2026');
console.log('======================================================================\n');

// 1. Tao thu muc target
if (fs.existsSync(targetDir)) {
    fs.rmSync(targetDir, { recursive: true, force: true });
}
fs.mkdirSync(targetDir, { recursive: true });

// 2. Tim va copy file Bao cao PDF
const candidateReports = [
    path.join(rootDir, 'latex', 'outputs', 'khoa-luan.pdf'),
    path.join(rootDir, 'latex', 'khoa-luan.pdf'),
    path.join(rootDir, 'docs', 'downloads', 'khoa-luan.pdf')
];

let reportCopied = false;
for (const p of candidateReports) {
    if (fs.existsSync(p)) {
        const dest = path.join(targetDir, `Bao_cao_Nien_luan_${packageDirName}.pdf`);
        fs.copyFileSync(p, dest);
        console.log(`[OK] Da sao chep file Bao cao PDF: ${path.basename(dest)}`);
        reportCopied = true;
        break;
    }
}
if (!reportCopied) {
    console.warn('[CANH BAO] Khong tim thay file khoa-luan.pdf! Vui long bien dich truoc khi dong goi.');
}

// 3. Tim va copy file Slide PDF
const candidateSlides = [
    path.join(rootDir, 'latex', 'outputs', 'slide-bao-ve.pdf'),
    path.join(rootDir, 'latex', 'slide-bao-ve.pdf'),
    path.join(rootDir, 'docs', 'downloads', 'slide-bao-ve.pdf')
];

let slideCopied = false;
for (const p of candidateSlides) {
    if (fs.existsSync(p)) {
        const dest = path.join(targetDir, `Slide_Bao_cao_${packageDirName}.pdf`);
        fs.copyFileSync(p, dest);
        console.log(`[OK] Da sao chep file Slide PDF: ${path.basename(dest)}`);
        slideCopied = true;
        break;
    }
}
if (!slideCopied) {
    console.warn('[CANH BAO] Khong tim thay file slide-bao-ve.pdf!');
}

// 4. Tim va copy file Slide PowerPoint (.pptx)
const pptxCandidates = [
    path.join(rootDir, 'slide', `Slide_Bao_cao_${packageDirName}.pptx`),
    path.join(rootDir, 'slide', 'Slide_Bao_cao.pptx')
];

let pptxCopied = false;
for (const p of pptxCandidates) {
    if (fs.existsSync(p)) {
        const dest = path.join(targetDir, `Slide_Bao_cao_${packageDirName}.pptx`);
        fs.copyFileSync(p, dest);
        console.log(`[OK] Da sao chep file Slide PowerPoint: ${path.basename(dest)}`);
        pptxCopied = true;
        break;
    }
}
if (!pptxCopied) {
    console.warn('[LUU Y] Khong tim thay file Slide PPTX trong thu muc slide/.');
}

// 5. Nen Source code + CSDL thanh file zip
const srcCodeZipDest = path.join(targetDir, `SourceCode_CSDL_${packageDirName}.zip`);
console.log('\n[*] Dang dong goi Source code va CSDL thanh file zip...');

// Chuan bi thu muc tam cho source code + csdl
const tempSrcDir = path.join(rootDir, '.temp_source_csdl');
if (fs.existsSync(tempSrcDir)) {
    fs.rmSync(tempSrcDir, { recursive: true, force: true });
}
fs.mkdirSync(tempSrcDir, { recursive: true });

// Copy code/ va thuc-nghiem/
function copyRecursiveSync(src, dest) {
    const exists = fs.existsSync(src);
    const stats = exists && fs.statSync(src);
    const isDirectory = exists && stats.isDirectory();
    if (isDirectory) {
        if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
        fs.readdirSync(src).forEach((childItemName) => {
            if (['.git', 'node_modules', '__pycache__'].includes(childItemName)) return;
            copyRecursiveSync(path.join(src, childItemName), path.join(dest, childItemName));
        });
    } else if (exists) {
        fs.copyFileSync(src, dest);
    }
}

copyRecursiveSync(path.join(rootDir, 'code'), path.join(tempSrcDir, 'code'));
copyRecursiveSync(path.join(rootDir, 'thuc-nghiem'), path.join(tempSrcDir, 'thuc-nghiem'));

// Ghi huong dan khoi chay trong zip
const readmeContent = `======================================================================
GOI MA NGUON (SOURCE CODE) VA CO SO DU LIEU (CSDL) NIEN LUAN
De tai: Nghien cuu ky thuat khai thac va phong chong tan cong Man-in-the-Middle
Sinh vien thuc hien: Nguyen Thi Ky Duyen (MSSV: 0023410647)
Giang vien huong dan: ThS. Trinh Le Hoang Tuan
Truong Dai hoc Dong Thap - Khoa Cong nghe va Ky thuat
======================================================================

CAU TRUC THU MUC:
- code/attacks/        : Kich ban PoC tan cong (ARP Spoofing, DNS Spoofing, SSL Strip, Content Injection)
- code/defense/        : Cau hinh phong thu Cisco DAI, DHCP Snooping, Nginx HTTPS/HSTS, WireGuard VPN, ARP Monitor
- code/database/       : Co so du lieu mau (schema_va_du_lieu_mau.sql) gom tai khoan, phien session va log canh bao
- code/lab-setup/      : Docker Compose khoi chay moi truong phong lab 5 node
- thuc-nghiem/         : Nhat ky thu nghiem Wireshark va bang doi sanh dinh luong

HUONG DAN SU DUNG:
1. Khoi chay phong thu nghiem Testbed Lab:
   cd code/lab-setup
   docker compose up -d

2. Nap Co so du lieu mau:
   mysql -u root -p < ../database/schema_va_du_lieu_mau.sql

3. Chay kien truc phong thu:
   - Ap dung cau hinh Switch Cisco: code/defense/cisco_dai_dhcp_snooping.cfg
   - Khoi chay giam sat ARP thoi gian thuc: python code/defense/arp_monitor_detector.py
======================================================================
`;
fs.writeFileSync(path.join(tempSrcDir, 'README_HUONG_DAN.txt'), readmeContent, 'utf8');

// Thuc hien nen file zip bang he dieu hanh
function zipFolder(sourceFolder, zipFilePath) {
    if (fs.existsSync(zipFilePath)) fs.unlinkSync(zipFilePath);
    if (process.platform === 'win32') {
        const cmd = `powershell -NoProfile -Command "Compress-Archive -Path '${sourceFolder}\\*' -DestinationPath '${zipFilePath}' -Force"`;
        execSync(cmd, { stdio: 'inherit' });
    } else {
        const cmd = `cd "${sourceFolder}" && zip -r "${zipFilePath}" .`;
        execSync(cmd, { stdio: 'inherit' });
    }
}

zipFolder(tempSrcDir, srcCodeZipDest);
fs.rmSync(tempSrcDir, { recursive: true, force: true });
console.log(`[OK] Da tao thanh cong file zip Source code + CSDL: ${path.basename(srcCodeZipDest)}`);

// 6. Sao chep cac bieu mau thu tuc huong dan
const bieuMauGoc = path.join(rootDir, 'thu-tuc-khoa');
if (fs.existsSync(bieuMauGoc)) {
    const filesToCopy = [
        '03_Bao_cao_tien_do_thuc_hien_nienluan.md',
        '04_Phieu_cham_diem_nien_luan.md'
    ];
    filesToCopy.forEach(f => {
        const src = path.join(bieuMauGoc, f);
        if (fs.existsSync(src)) {
            fs.copyFileSync(src, path.join(targetDir, f));
            console.log(`[OK] Da them bieu mau: ${f}`);
        }
    });
}

// 7. Tao file Huong dan nop ho so chi tiet
const thongBaoContent = `======================================================================
TRUONG DAI HOC DONG THAP - KHOA CONG NGHE VA KY THUAT
THONG TIN HO SO NIEN LUAN CHUYEN NGANH MANG MAY TINH VA AN NINH
======================================================================
- De tai: Nghien cuu ky thuat khai thac va phong chong tan cong Man-in-the-Middle
- Sinh vien thuc hien: NGUYEN THI KY DUYEN
- Ma so sinh vien: 0023410647
- Lop: DHCNTT23B-CS
- Giang vien huong dan: ThS. TRINH LE HOANG TUAN

KE HOACH THOI GIAN:
1. Thoi gian thuc hien: Tu 19/10/2026 den 19/12/2026
2. Hoan thanh va nop quyen bao cao: Truoc ngay 21/12/2026 (nop truc tiep cho GVHD)
3. Bao cao nien luan du kien: Tu ngay 22/12/2026 den ngay 28/12/2026

QUY DINH HO SO NOP:
A. HO SO BAN IN (Nop truc tiep cho GVHD truoc 21/12/2026):
   1. In 01 quyen bao cao hoan chinh (dong bia mau cung + bia lot dung quy chuan).
   2. In 02 phieu cham diem nien luan (danh cho 2 Giang vien cham).
   3. In 01 phieu bao cao tien do thuc hien nien luan (nhac GVHD ThS. Trinh Le Hoang Tuan ky ten).

B. HO SO SO HOA (Thu muc ${packageDirName} va file nen .zip):
   1. File bao cao PDF        : Bao_cao_Nien_luan_${packageDirName}.pdf
   2. File slide bao cao PDF   : Slide_Bao_cao_${packageDirName}.pdf
   3. File slide PowerPoint    : Slide_Bao_cao_${packageDirName}.pptx
   4. File nen Source code+CSDL: SourceCode_CSDL_${packageDirName}.zip
======================================================================
`;
fs.writeFileSync(path.join(targetDir, 'THONG_TIN_NOP_HO_SO_NIEN_LUAN.txt'), thongBaoContent, 'utf8');

// 8. Nen toan bo thu muc MSSV_HoTen thanh file zip de de dang nop truc tuyen / email
console.log('\n[*] Dang dong goi toan bo thu muc thanh ' + `${packageDirName}.zip...`);
zipFolder(targetDir, topZipPath);
console.log(`[OK] Da tao thanh cong file tong: ${path.basename(topZipPath)}`);

console.log('\n======================================================================');
console.log('   HOAN TAT DONG GOI HO SO NIEN LUAN THANH CONG!');
console.log(`   Thu muc: ${targetDir}`);
console.log(`   File nen: ${topZipPath}`);
console.log('======================================================================\n');
