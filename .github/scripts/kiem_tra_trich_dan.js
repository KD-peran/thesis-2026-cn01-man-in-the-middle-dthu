const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const latexDir = path.join(repoRoot, 'latex');
const bibFile = path.join(latexDir, 'tai-lieu-tham-khao.bib');

console.log('==> Bắt đầu kiểm tra tính nhất quán trích dẫn...');

if (!fs.existsSync(bibFile)) {
    console.error(`[LỖI] Không tìm thấy tệp .bib tại: ${bibFile}`);
    process.exit(1);
}

const bibContent = fs.readFileSync(bibFile, 'utf8');
const bibKeys = new Set();
const bibRegex = /@\w+\s*\{\s*([^,\s]+)/g;
let match;
while ((match = bibRegex.exec(bibContent)) !== null) {
    bibKeys.add(match[1].trim());
}

const texFiles = [path.join(latexDir, 'khoa-luan.tex'), path.join(latexDir, 'slide-bao-ve.tex')];
const chuongDir = path.join(latexDir, 'chuong');
if (fs.existsSync(chuongDir)) {
    fs.readdirSync(chuongDir).forEach(f => {
        if (f.endsWith('.tex')) {
            texFiles.push(path.join(chuongDir, f));
        }
    });
}

const citedKeys = new Set();
const citeRegex = /\\cite\{([^}]+)\}/g;

texFiles.forEach(file => {
    if (fs.existsSync(file)) {
        const content = fs.readFileSync(file, 'utf8');
        while ((match = citeRegex.exec(content)) !== null) {
            match[1].split(',').forEach(k => citedKeys.add(k.trim()));
        }
    }
});

console.log(`[*] Tổng số trích dẫn trong các tệp LaTeX: ${citedKeys.size}`);
console.log(`[*] Tổng số mục trong file .bib: ${bibKeys.size}`);

const missingKeys = [];
citedKeys.forEach(k => {
    if (!bibKeys.has(k)) {
        missingKeys.push(k);
    }
});

if (missingKeys.length > 0) {
    console.error(`[LỖI] Tìm thấy ${missingKeys.length} khóa trích dẫn trong LaTeX nhưng KHÔNG CÓ trong .bib:`);
    missingKeys.forEach(k => console.error(`  - ${k}`));
    process.exit(1);
}

console.log('\n[CHÚC MỪNG] Tất cả các trích dẫn đều hợp lệ và nhất quán 100%!');
