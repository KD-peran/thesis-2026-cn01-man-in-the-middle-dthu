const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const toolDir = __dirname;
const parentDir = path.resolve(toolDir, '..');

// 1. Nhận tham số đường dẫn file
let inputArg = process.argv[2];
let customOutputHtml = process.argv[3];
let inputPath = null;

if (inputArg) {
  if (path.isAbsolute(inputArg)) {
    inputPath = inputArg;
  } else if (fs.existsSync(path.resolve(process.cwd(), inputArg))) {
    inputPath = path.resolve(process.cwd(), inputArg);
  } else if (fs.existsSync(path.resolve(parentDir, 'new', inputArg))) {
    inputPath = path.resolve(parentDir, 'new', inputArg);
  } else if (fs.existsSync(path.resolve(parentDir, inputArg))) {
    inputPath = path.resolve(parentDir, inputArg);
  } else if (fs.existsSync(path.resolve(toolDir, inputArg))) {
    inputPath = path.resolve(toolDir, inputArg);
  }
} else {
  // Mặc định tìm file .md trong thư mục new
  const newDir = path.resolve(parentDir, 'new');
  if (fs.existsSync(newDir)) {
    const files = fs.readdirSync(newDir).filter(f => f.endsWith('.md'));
    if (files.length > 0) {
      inputPath = path.resolve(newDir, files[0]);
    }
  }
}

if (!inputPath || !fs.existsSync(inputPath)) {
  console.error(`[LỖI] Không tìm thấy file Markdown: ${inputArg || 'chưa chỉ định'}`);
  process.exit(1);
}

const baseName = path.basename(inputPath, path.extname(inputPath)).replace(/^\.temp_/, '').replace(/_with_images$/, '');
const outputHtmlPath = customOutputHtml ? path.resolve(process.cwd(), customOutputHtml) : path.resolve(toolDir, `${baseName.replace(/\s+/g, '_')}.html`);

console.log(`[1/3] Đang đọc và tối ưu hóa nội dung liền mạch: ${path.basename(inputPath)}...`);
let mdContent = fs.readFileSync(inputPath, 'utf-8');

// Tiền xử lý các công thức toán LaTeX sang dạng HTML/Unicode đẹp mắt
mdContent = mdContent.replace(/\$\\rightarrow\$/g, ' → ');
mdContent = mdContent.replace(/\$\\approx\$/g, ' ≈ ');
mdContent = mdContent.replace(/\$\\le\$/g, ' ≤ ');
mdContent = mdContent.replace(/\$\\ge\$/g, ' ≥ ');
mdContent = mdContent.replace(/\$\\ne\$/g, ' ≠ ');
mdContent = mdContent.replace(/\$\\pm\s*30\\text\{s\}\$/g, '±30 giây');
mdContent = mdContent.replace(/\$>\s*0\.5\\%\$/g, '> 0.5%');
mdContent = mdContent.replace(/\$\\text\{LossRate\}\s*\\le\s*0\.5\\%\$/g, '<strong>LossRate ≤ 0.5%</strong>');
mdContent = mdContent.replace(/\$\\text\{LossRate\}\s*>\s*0\.5\\%\$/g, '<strong>LossRate > 0.5%</strong>');
mdContent = mdContent.replace(/\$\\Delta V_\{?\\text\{thực\}?\}\s*=\s*\\Delta h\s*\\times\s*S\$/g, '<strong>ΔV<sub>thực</sub> = Δh × S</strong>');
mdContent = mdContent.replace(/\$\\text\{ComputedHash\}\s*==\s*\\text\{onChainBatchHash\}\$/g, '<code>ComputedHash == onChainBatchHash</code>');
mdContent = mdContent.replace(/\$\\text\{ComputedHash\}\s*\\ne\s*\\text\{onChainBatchHash\}\$/g, '<code>ComputedHash ≠ onChainBatchHash</code>');

// Xử lý các khối công thức toán hiển thị nổi bật ($$ ... $$)
mdContent = mdContent.replace(/\$\$\\text\{LossRate \(\\\%\)\}\s*=\s*\\frac\{.*?\}\{.*?\}\s*\\times\s*100\\%\$\$/g, `
<div class="math-card">
  <div class="math-label">CÔNG THỨC TÍNH TỶ LỆ HAO HỤT MẺ NHẬP (LOSS RATE):</div>
  <div class="math-equation">
    <span class="math-var">LossRate (%)</span> = 
    <span class="math-fraction">
      <span class="math-num">| ΔV<sub>thực</sub> − V<sub>hóa_đơn</sub> |</span>
      <span class="math-den">V<sub>hóa_đơn</sub></span>
    </span> × 100%
  </div>
</div>
`);

mdContent = mdContent.replace(/\$\$\\sum V_\{?\\text\{vòi\_bơm\}?\}\s*\\approx\s*\\Delta V_\{?\\text\{bồn\_giảm\}?\}\$\$/g, `
<div class="math-card">
  <div class="math-label">PHƯƠNG TRÌNH CÂN BẰNG ĐỐI SOÁT CA TRỰC VÒI BƠM:</div>
  <div class="math-equation">
    <span class="math-symbol">∑</span> V<sub>vòi_bơm</sub> ≈ ΔV<sub>bồn_giảm</sub>
  </div>
</div>
`);

mdContent = mdContent.replace(/\$\$\\text\{ComputedHash\}\s*=\s*\\text\{SHA256\}\(\\text\{Canonical JSON\}\)\$\$/g, `
<div class="math-card">
  <div class="math-label">GIẢI THUẬT BĂM TÍNH TOÀN VẸN MẬT MÃ:</div>
  <div class="math-equation">
    <span class="math-var">ComputedHash</span> = <strong>SHA-256</strong>( Canonical_JSON )
  </div>
</div>
`);

// Ghi file tạm để npx marked biên dịch
const tempMd = path.resolve(toolDir, `.temp_compile_${Date.now()}.md`);
fs.writeFileSync(tempMd, mdContent, 'utf-8');

console.log(`[2/3] Biên dịch Markdown sang cấu trúc HTML liền mạch...`);
const tempHtml = path.resolve(toolDir, `.temp_parsed_${Date.now()}.html`);
execSync(`npx -y marked -i "${tempMd}" -o "${tempHtml}"`, { cwd: toolDir });
let htmlBody = fs.readFileSync(tempHtml, 'utf-8');

// Dọn dẹp file tạm
try {
  fs.unlinkSync(tempMd);
  fs.unlinkSync(tempHtml);
} catch (e) {}

// Tinh chỉnh định dạng
htmlBody = htmlBody.replace(/\(\s*<code>/g, '(<code>');
htmlBody = htmlBody.replace(/<\/code>\s*\)/g, '</code>)');

// Huy hiệu trạng thái trong bảng
htmlBody = htmlBody.replace(/<strong>Hoàn thành<\/strong>/g, '<span class="badge badge-success">Hoàn thành</span>');
htmlBody = htmlBody.replace(/<strong>Hoàn thành vượt mức<\/strong>/g, '<span class="badge badge-exceed">Hoàn thành vượt mức</span>');
htmlBody = htmlBody.replace(/<td align="center">Cao<\/td>/g, '<td align="center"><span class="priority-high">Cao</span></td>');
htmlBody = htmlBody.replace(/<td align="center">Trung bình<\/td>/g, '<td align="center"><span class="priority-med">Trung bình</span></td>');

// 1. TRANG BÌA & HEADER HỌC THUẬT CAO CẤP CHO ĐỀ TÀI TỔNG HỢP
const docHeaderRegex = /<h1>(.*?(?:MẠNG KHÔNG DÂY|HẠ TẦNG MẠNG|IoT - BLOCKCHAIN).*?)<\/h1>(?:\s*<h2>(.*?)<\/h2>)?/is;

if (docHeaderRegex.test(htmlBody)) {
  const match = htmlBody.match(docHeaderRegex);
  const mainTitle = match[1] ? match[1].replace(/<[^>]+>/g, '').trim() : "THIẾT KẾ KIẾN TRÚC TỔNG THỂ HẠ TẦNG MẠNG KHÔNG DÂY TẠI TRƯỜNG ĐẠI HỌC ĐỒNG THÁP";
  const subTitle = match[2] ? match[2].replace(/<[^>]+>/g, '').trim() : "Khảo sát hiện trạng, Mô hình hóa trên Cisco Packet Tracer, Chuẩn hóa Wi-Fi 6, Fast Roaming và Quy hoạch Hạ tầng";

  const academicHeaderHtml = `
<div class="thesis-header-banner">
  <div class="inst-top">
    <div class="inst-uni">TRƯỜNG ĐẠI HỌC ĐỒNG THÁP</div>
    <div class="inst-faculty">KHOA CÔNG NGHỆ VÀ KỸ THUẬT</div>
  </div>
  <div class="thesis-type-badge">TÀI LIỆU ĐẶC TẢ &amp; KIẾN TRÚC TOÀN DIỆN ĐỀ TÀI TỐT NGHIỆP</div>
  <h1 class="thesis-title">${mainTitle.toUpperCase()}</h1>
  <div class="thesis-subtitle">${subTitle}</div>
  
  <div class="thesis-meta-grid">
    <div class="meta-item"><span class="meta-k">Sinh viên thực hiện:</span> <span class="meta-v"><strong>Nguyễn Thị Kỳ Duyên</strong> (MSSV: <strong>0023410647</strong> — Lớp: <strong>ĐHCNTT23B-CS</strong>)</span></div>
    <div class="meta-item"><span class="meta-k">Giảng viên hướng dẫn:</span> <span class="meta-v"><strong>TS. Lương Thái Ngọc</strong></span></div>
    <div class="meta-item"><span class="meta-k">Ngành / Chuyên ngành:</span> <span class="meta-v">Khoa học máy tính / Mạng máy tính và An ninh</span></div>
    <div class="meta-item"><span class="meta-k">Khóa đào tạo:</span> <span class="meta-v">2023 – 2027</span></div>
    <div class="meta-item"><span class="meta-k">Thời gian thực hiện:</span> <span class="meta-v">Tháng 09/2026 – Tháng 04/2027</span></div>
    <div class="meta-item"><span class="meta-k">Cơ sở đào tạo:</span> <span class="meta-v">Trường Đại học Đồng Tháp (DTHU)</span></div>
  </div>
</div>
`;
  htmlBody = htmlBody.replace(docHeaderRegex, academicHeaderHtml);
}

// 2. TẠO KHUNG MỤC LỤC CHUYÊN NGHIỆP (CHẢY LIỀN MẠCH, KHÔNG ÉP NGẮT TRANG)
const tocRegex = /<h2>MỤC LỤC<\/h2>\s*(<ol>.*?<\/ol>)/is;
if (tocRegex.test(htmlBody)) {
  htmlBody = htmlBody.replace(tocRegex, (match, olContent) => {
    return `
<div class="toc-card">
  <div class="toc-header">
    <span class="toc-icon">📑</span>
    <span class="toc-title">MỤC LỤC NỘI DUNG TÀI LIỆU</span>
  </div>
  ${olContent}
</div>
`;
  });
}

// 3. TẠO BANNER CHO TỪNG PHẦN LỚN (CHẢY LIỀN MẠCH THEO NỘI DUNG, KHÔNG TẠO TRANG TRẮNG)
htmlBody = htmlBody.replace(
  /<h1[^>]*>\s*PHẦN\s+(\d+)\s*[:\-–]\s*(.*?)\s*<\/h1>/gi,
  `
<div class="chapter-banner">
  <div class="chapter-badge">PHẦN $1</div>
  <div class="chapter-title">$2</div>
</div>
`
);

// Gắn nhãn ngôn ngữ lập trình cho các khối code block
htmlBody = htmlBody.replace(/<pre><code class="language-([a-zA-Z0-9_\-]+)">/g, (m, lang) => {
  const upper = lang.toUpperCase();
  const labelMap = {
    'CPP': 'C++ / mbedTLS (Firmware ESP32)',
    'SOLIDITY': 'Solidity (Smart Contract EVM)',
    'TYPESCRIPT': 'TypeScript / Node.js (Ingestion Relayer)',
    'SQL': 'PostgreSQL DDL / Schema',
    'CONF': 'Mosquitto Configuration (mosquitto.conf)',
    'JSON': 'Canonical JSON Payload',
    'BASH': 'Shell / CLI Command'
  };
  const label = labelMap[upper] || upper;
  return `<div class="code-wrapper"><div class="code-header"><span class="code-dot red"></span><span class="code-dot yellow"></span><span class="code-dot green"></span><span class="code-lang">${label}</span></div><pre><code class="language-${lang}">`;
});
htmlBody = htmlBody.replace(/<\/code><\/pre>/g, '</code></pre></div>');

console.log(`[3/3] Áp dụng CSS Liền Mạch (Continuous Seamless Flow)...`);

// Toàn bộ Template HTML hoàn chỉnh - CHẢY LIỀN MẠCH, KHÔNG ÉP CÁCH TRANG
const fullHtml = `<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>${baseName}</title>
<style>
  @page {
    size: A4 portrait;
    margin: 12mm 15mm 12mm 15mm;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  /* TYPOGRAPHY NỀN TẢNG LIỀN MẠCH */
  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
    font-size: 10pt;
    line-height: 1.65;
    color: #1e293b;
    background: #ffffff;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
  }

  /* BỎ HOÀN TOÀN CÁC LỆNH ÉP CÁCH TRANG GÂY KHOẢNG TRẮNG */
  .page-break {
    display: none !important;
  }

  /* BANNER TRANG BÌA ĐỀ TÀI */
  .thesis-header-banner {
    border: 2px solid #1e3a8a;
    border-radius: 8px;
    padding: 18px 22px;
    background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
    margin-bottom: 20px;
    box-shadow: 0 3px 10px rgba(30, 58, 138, 0.08);
  }

  .inst-top {
    text-align: center;
    border-bottom: 1.5px solid #cbd5e1;
    padding-bottom: 8px;
    margin-bottom: 12px;
  }

  .inst-uni {
    font-size: 11.5pt;
    font-weight: 800;
    color: #1e3a8a;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }

  .inst-faculty {
    font-size: 9pt;
    font-weight: 600;
    color: #475569;
    margin-top: 2px;
  }

  .thesis-type-badge {
    display: inline-block;
    background-color: #dbeafe;
    color: #1e40af;
    font-size: 8pt;
    font-weight: 700;
    padding: 3px 9px;
    border-radius: 20px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 8px;
    border: 1px solid #bfdbfe;
  }

  .thesis-title {
    font-size: 14pt;
    font-weight: 800;
    color: #0f172a;
    line-height: 1.35;
    text-transform: uppercase;
    margin-bottom: 6px;
    letter-spacing: 0.3px;
  }

  .thesis-subtitle {
    font-size: 9.5pt;
    font-style: italic;
    color: #475569;
    line-height: 1.45;
    margin-bottom: 14px;
  }

  .thesis-meta-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 6px 14px;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    padding: 8px 12px;
    font-size: 9pt;
  }

  .meta-item {
    color: #334155;
  }

  .meta-k {
    font-weight: 600;
    color: #475569;
  }

  .meta-v {
    color: #0f172a;
  }

  /* KHUNG MỤC LỤC NỘI DUNG - LIỀN MẠCH */
  .toc-card {
    background: #f8fafc;
    border: 1.5px solid #cbd5e1;
    border-radius: 8px;
    padding: 14px 20px;
    margin-bottom: 20px;
  }

  .toc-header {
    display: flex;
    align-items: center;
    gap: 8px;
    border-bottom: 1.5px solid #94a3b8;
    padding-bottom: 6px;
    margin-bottom: 10px;
  }

  .toc-icon {
    font-size: 13pt;
  }

  .toc-title {
    font-size: 11pt;
    font-weight: 800;
    color: #1e3a8a;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .toc-card ol {
    margin-left: 20px;
    line-height: 1.55;
  }

  .toc-card ol li {
    margin-bottom: 5px;
    font-size: 9pt;
    color: #1e293b;
  }

  .toc-card ol li a {
    color: #1e40af;
    text-decoration: none;
    font-weight: 600;
  }

  .toc-card ol li a:hover {
    text-decoration: underline;
  }

  .toc-card ol li ul {
    margin-top: 3px;
    margin-left: 16px;
  }

  .toc-card ol li ul li {
    font-weight: normal;
    font-size: 8.5pt;
    color: #475569;
    margin-bottom: 2px;
  }

  /* BANNER CÁC PHẦN LỚN - CHẢY TỰ NHIÊN, KHÔNG TỰ NHẢY TRANG MỚI */
  .chapter-banner {
    background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 60%, #2563eb 100%);
    color: #ffffff;
    border-radius: 6px;
    padding: 12px 18px;
    margin-top: 22px;
    margin-bottom: 14px;
    box-shadow: 0 3px 8px rgba(30, 58, 138, 0.15);
    page-break-after: avoid;
    break-after: avoid;
  }

  .chapter-badge {
    font-size: 9pt;
    font-weight: 800;
    letter-spacing: 1.5px;
    color: #93c5fd;
    text-transform: uppercase;
    margin-bottom: 3px;
  }

  .chapter-title {
    font-size: 12.5pt;
    font-weight: 800;
    text-transform: uppercase;
    line-height: 1.35;
    letter-spacing: 0.3px;
  }

  /* TIÊU ĐỀ PHÂN MỤC H2, H3, H4 */
  h2 {
    font-size: 12pt;
    font-weight: 700;
    color: #1e40af;
    margin-top: 18px;
    margin-bottom: 6px;
    padding-bottom: 3px;
    border-bottom: 1.5px solid #dbeafe;
    page-break-after: avoid;
    break-after: avoid;
  }

  h3 {
    font-size: 10.5pt;
    font-weight: 700;
    color: #0f172a;
    margin-top: 12px;
    margin-bottom: 4px;
    page-break-after: avoid;
    break-after: avoid;
  }

  h4 {
    font-size: 9.8pt;
    font-weight: 600;
    color: #334155;
    margin-top: 9px;
    margin-bottom: 3px;
    page-break-after: avoid;
    break-after: avoid;
  }

  p {
    margin-bottom: 7px;
    text-align: justify;
    text-justify: inter-word;
    line-height: 1.65;
  }

  ul, ol {
    margin-left: 22px;
    margin-bottom: 7px;
  }

  li {
    margin-bottom: 3.5px;
    text-align: justify;
    line-height: 1.55;
  }

  li ul, li ol {
    margin-top: 2px;
    margin-bottom: 2px;
    margin-left: 18px;
  }

  hr {
    border: none;
    border-top: 1px solid #e2e8f0;
    margin: 14px 0;
  }

  /* CÔNG THỨC TOÁN HỌC NỔI BẬT */
  .math-card {
    background-color: #f8fafc;
    border: 1px solid #cbd5e1;
    border-left: 4px solid #2563eb;
    border-radius: 0 6px 6px 0;
    padding: 8px 16px;
    margin: 10px 0 14px 0;
  }

  .math-label {
    font-size: 8pt;
    font-weight: 700;
    color: #475569;
    letter-spacing: 0.5px;
    margin-bottom: 3px;
  }

  .math-equation {
    font-size: 10.5pt;
    font-weight: 600;
    color: #1e3a8a;
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 3px 0;
  }

  .math-fraction {
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    vertical-align: middle;
    padding: 0 4px;
  }

  .math-num {
    border-bottom: 1.5px solid #1e3a8a;
    padding-bottom: 2px;
    font-size: 9.5pt;
  }

  .math-den {
    padding-top: 2px;
    font-size: 9.5pt;
  }

  .math-symbol {
    font-size: 13pt;
    line-height: 1;
  }

  /* KHUNG SƠ ĐỒ THIẾT KẾ ĐỈNH CAO - CHẢY TỰ NHIÊN */
  .diagram-figure {
    margin: 14px auto 18px auto;
    text-align: center;
    width: 100%;
  }

  .diagram-img-wrapper {
    display: inline-block;
    max-width: 100%;
    background: #ffffff;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    padding: 8px;
    box-shadow: 0 3px 10px rgba(15, 23, 42, 0.05);
  }

  .diagram-figure img {
    max-width: 100%;
    max-height: 200mm;
    height: auto;
    display: block;
    margin: 0 auto;
  }

  .diagram-caption {
    margin-top: 6px;
    font-size: 9pt;
    font-weight: 500;
    color: #334155;
    text-align: center;
    line-height: 1.35;
  }

  .diagram-caption strong {
    color: #1e3a8a;
    font-weight: 700;
  }

  /* BẢNG BIỂU HỌC THUẬT CHUẨN MỰC - CHẢY LIỀN MẠCH */
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 6px;
    margin-bottom: 12px;
    font-size: 8.8pt;
  }

  tr {
    page-break-inside: avoid;
    break-inside: avoid;
  }

  th {
    background-color: #1e3a8a;
    color: #ffffff;
    font-weight: 700;
    text-align: center;
    border: 1px solid #1e3a8a;
    padding: 5px 8px;
    vertical-align: middle;
    font-size: 8.8pt;
    letter-spacing: 0.2px;
  }

  td {
    border: 1px solid #cbd5e1;
    padding: 4.5px 8px;
    vertical-align: middle;
    line-height: 1.35;
    color: #1e293b;
  }

  tbody tr:nth-child(even) {
    background-color: #f8fafc;
  }

  /* KHỐI MÃ NGUỒN MAC-STYLE - CHO PHÉP TỰ ĐỘNG CHẢY QUA TRANG (KHÔNG ÉP TẠO TRANG TRẮNG) */
  .code-wrapper {
    margin: 10px 0 14px 0;
    border-radius: 6px;
    overflow: hidden;
    border: 1px solid #334155;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  }

  .code-header {
    background: #1e293b;
    padding: 5px 12px;
    display: flex;
    align-items: center;
    border-bottom: 1px solid #334155;
  }

  .code-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    margin-right: 5px;
    display: inline-block;
  }
  .code-dot.red { background: #ef4444; }
  .code-dot.yellow { background: #f59e0b; }
  .code-dot.green { background: #10b981; }

  .code-lang {
    margin-left: 8px;
    font-family: Consolas, monospace;
    font-size: 7.8pt;
    font-weight: 600;
    color: #94a3b8;
    letter-spacing: 0.5px;
  }

  pre {
    background-color: #0f172a;
    color: #f8fafc;
    padding: 10px 14px;
    font-family: Consolas, "Cascadia Code", "Fira Code", monospace;
    font-size: 8.2pt;
    line-height: 1.48;
    overflow-x: auto;
    white-space: pre-wrap;
    word-break: break-word;
    margin: 0;
  }

  pre code {
    background: transparent !important;
    border: none !important;
    padding: 0 !important;
    color: #f8fafc !important;
    font-size: inherit !important;
  }

  /* CODE NỘI DÒNG */
  code {
    font-family: Consolas, "Courier New", monospace;
    font-size: 8.2pt;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 3px;
    padding: 1px 4.5px;
    color: #0f172a;
    font-weight: 600;
  }

  /* KHỐI TRÍCH DẪN & CHÚ Ý */
  blockquote {
    border-left: 4px solid #3b82f6;
    padding: 7px 14px;
    background-color: #eff6ff;
    color: #1e3a8a;
    font-style: italic;
    margin: 8px 0;
    border-radius: 0 5px 5px 0;
  }

  /* BADGE TRẠNG THÁI */
  .badge {
    display: inline-block;
    padding: 1.5px 6px;
    border-radius: 4px;
    font-size: 7.8pt;
    font-weight: 700;
    white-space: nowrap;
  }

  .badge-success {
    background-color: #dcfce7;
    color: #15803d;
    border: 1px solid #bbf7d0;
  }

  .badge-exceed {
    background-color: #e0f2fe;
    color: #0369a1;
    border: 1px solid #bae6fd;
  }

  .priority-high {
    font-weight: 700;
    color: #dc2626;
  }

  .priority-med {
    font-weight: 700;
    color: #d97706;
  }
</style>
</head>
<body>
${htmlBody}
</body>
</html>`;

fs.writeFileSync(outputHtmlPath, fullHtml, 'utf-8');
console.log(`[OK] Đã biên dịch HTML liền mạch thành công: ${path.basename(outputHtmlPath)}`);
