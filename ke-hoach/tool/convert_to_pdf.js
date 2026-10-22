const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const toolDir = __dirname;
const parentDir = path.resolve(toolDir, '..');

// Tìm file markdown đầu vào
let inputArg = process.argv[2];
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

const baseName = path.basename(inputPath, path.extname(inputPath));
const outputHtmlPath = path.resolve(toolDir, `${baseName.replace(/\s+/g, '_')}.html`);

console.log(`[1/3] Đang đọc và phân tích dữ liệu động từ: ${path.basename(inputPath)}...`);
let mdContent = fs.readFileSync(inputPath, 'utf-8');

// Hàm format markdown inline
function formatMarkdownInline(str) {
  if (!str) return '';
  return str
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/`([^`]+)`/g, '<code>$1</code>');
}

// 1. TRÍCH XUẤT ĐỘNG PHẦN HEADER TỪ MARKDOWN (ĐỘNG THEO NỘI DUNG MD)
const headerDelimiterRegex = /(^#\s+[^\n]+[\s\S]*?)(?=\n---\s*\n|\n##\s+)/;
const headerMatch = mdContent.match(headerDelimiterRegex);

let dynamicHeaderHtml = '';

if (headerMatch) {
  const headerBlock = headerMatch[1].trim();
  const headerLines = headerBlock.split('\n').map(l => l.trim()).filter(Boolean);

  let docTitle = '';
  let instUni = '';
  let instFaculty = '';
  let topicVal = '';
  const metaItems = [];

  for (const line of headerLines) {
    if (line.startsWith('# ')) {
      docTitle = line.replace(/^#\s+/, '').trim();
    } else {
      const kvMatch = line.match(/^\*\*(.*?):\*\*\s*(.*)$/);
      if (kvMatch) {
        const k = kvMatch[1].trim();
        const v = kvMatch[2].trim();
        if (k.toLowerCase().includes('cơ sở đào tạo') || k.toLowerCase().includes('trường')) {
          const parts = v.split(/[—–-]/);
          instUni = parts[0].trim();
          instFaculty = parts.length > 1 ? parts.slice(1).join('—').trim() : '';
        } else if (k.toLowerCase().includes('đề tài')) {
          topicVal = v;
        } else {
          metaItems.push({ key: k, val: v });
        }
      }
    }
  }

  // Tạo banner động hoàn toàn theo những gì viết trong Markdown
  const instBlock = instUni ? `
  <div class="inst-top">
    <div class="inst-uni">${instUni}</div>
    ${instFaculty ? `<div class="inst-faculty">${instFaculty}</div>` : ''}
  </div>` : '';

  const topicBlock = topicVal ? `
  <div class="report-topic">${topicVal}</div>` : '';

  const gridItems = metaItems.map(item => {
    const isWide = item.key.toLowerCase().includes('sinh viên') || item.key.toLowerCase().includes('kính gửi');
    const spanStyle = isWide ? ' style="grid-column: span 2;"' : '';
    return `<div class="meta-item"${spanStyle}><span class="meta-k">${item.key}:</span> <span class="meta-v">${formatMarkdownInline(item.val)}</span></div>`;
  }).join('\n    ');

  dynamicHeaderHtml = `
<div class="report-header-banner">
  ${instBlock}
  ${docTitle ? `<div class="report-type-badge">${docTitle.toUpperCase()}</div>` : ''}
  ${topicBlock}
  ${gridItems ? `<div class="meta-grid">\n    ${gridItems}\n  </div>` : ''}
</div>
`;

  // Thay thế khối header bằng placeholder đặc biệt
  mdContent = mdContent.replace(headerMatch[1], '<!-- DYNAMIC_HEADER_PLACEHOLDER -->\n');
}

// 2. KHUNG KÝ TÊN CỐ ĐỊNH TRONG JS (THEO YÊU CẦU ĐƯA CỨNG VÀO JS, KHÔNG CẦN VIẾT TRONG MD)
const signatureHtml = `
<div class="closing-section">
  <p class="closing-note">Em kính gửi Thầy theo dõi tiến độ ạ. Em xin trân trọng cảm ơn Thầy!</p>
  <div class="signature-container">
    <div class="signature-box">
      <p><strong>Sinh viên thực hiện</strong></p>
      <p><em>(Ký và ghi rõ họ tên)</em></p>
      <p style="margin-top: 2.5cm; font-style: italic; font-weight: normal;">Nguyễn Thị Kỳ Duyên</p>    </div>
  </div>
</div>
`;

// 3. TIỀN XỬ LÝ CÔNG THỨC TOÁN & KÝ HIỆU
mdContent = mdContent.replace(/\$\\rightarrow\$/g, ' → ');
mdContent = mdContent.replace(/\$\\approx\$/g, ' ≈ ');
mdContent = mdContent.replace(/\$\\le\$/g, ' ≤ ');
mdContent = mdContent.replace(/\$\\ge\$/g, ' ≥ ');
mdContent = mdContent.replace(/\$\\ne\$/g, ' ≠ ');
mdContent = mdContent.replace(/\$\\pm\s*30\\text\{s\}\$/g, '±30s');
mdContent = mdContent.replace(/\$>\s*0\.5\\%\$/g, '> 0.5%');

// File tạm markdown
const tempMd = path.resolve(toolDir, `.temp_cleaned_${Date.now()}.md`);
fs.writeFileSync(tempMd, mdContent, 'utf-8');

// Parse markdown sang HTML bằng marked
console.log(`[2/3] Biên dịch Markdown sang HTML với npx marked...`);
const tempHtml = path.resolve(toolDir, `.temp_parsed_${Date.now()}.html`);
execSync(`npx -y marked -i "${tempMd}" -o "${tempHtml}"`, { cwd: toolDir });
let htmlBody = fs.readFileSync(tempHtml, 'utf-8');

// Xóa file tạm
try {
  fs.unlinkSync(tempMd);
  fs.unlinkSync(tempHtml);
} catch (e) { }

// Đưa khối Header động vào vị trí placeholder
if (dynamicHeaderHtml) {
  htmlBody = htmlBody.replace('<!-- DYNAMIC_HEADER_PLACEHOLDER -->', dynamicHeaderHtml);
}

// Tinh chỉnh định dạng mã và ký tự
htmlBody = htmlBody.replace(/\(\s*<code>/g, '(<code>');
htmlBody = htmlBody.replace(/<\/code>\s*\)/g, '</code>)');

// Định dạng badge trạng thái trong bảng
htmlBody = htmlBody.replace(/<strong>Hoàn thành<\/strong>/g, '<span class="badge badge-success">Hoàn thành</span>');
htmlBody = htmlBody.replace(/<strong>Hoàn thành vượt mức<\/strong>/g, '<span class="badge badge-exceed">Hoàn thành vượt mức</span>');

// Trọng số Cao / Trung bình
htmlBody = htmlBody.replace(/<td align="center">Cao<\/td>/g, '<td align="center"><span class="priority-high">Cao</span></td>');
htmlBody = htmlBody.replace(/<td align="center">Trung bình<\/td>/g, '<td align="center"><span class="priority-med">Trung bình</span></td>');

// Gắn cố định khung chữ ký vào khối liền mạch .section-plan-block cùng Mục 3 để chống tách trang
if (/(<h2>\s*3\.\s*Kế hoạch Tuần Tiếp theo[\s\S]*?<\/table>)/i.test(htmlBody)) {
  htmlBody = htmlBody.replace(
    /(<h2>\s*3\.\s*Kế hoạch Tuần Tiếp theo[\s\S]*?<\/table>)/i,
    '<div class="section-plan-block">\n$1\n' + signatureHtml + '\n</div>'
  );
} else {
  htmlBody += '\n' + signatureHtml;
}

console.log(`[3/3] Áp dụng CSS Liền Mạch Tối Ưu (Seamless Compact Flow)...`);

// File HTML hoàn chỉnh LIỀN MẠCH, KHÔNG TÁCH TRANG MỤC 3
const fullHtml = `<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>${baseName}</title>
<style>
  @page {
    size: A4 portrait;
    margin: 8mm 12mm 8mm 12mm;
  }

  * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
    font-size: 9.2pt;
    line-height: 1.42;
    color: #1e293b;
    background: #ffffff;
    padding: 0;
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;
  }

  .page-break {
    display: none !important;
  }

  /* BANNER HEADER HIỆN ĐẠI TỰ ĐỘNG THEO DỮ LIỆU MD */
  .report-header-banner {
    border: 1.5px solid #1e3a8a;
    border-radius: 6px;
    padding: 10px 14px;
    background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
    margin-bottom: 8px;
    box-shadow: 0 1px 4px rgba(30, 58, 138, 0.06);
  }

  .inst-top {
    text-align: center;
    border-bottom: 1px solid #cbd5e1;
    padding-bottom: 4px;
    margin-bottom: 6px;
  }

  .inst-uni {
    font-size: 10.5pt;
    font-weight: 800;
    color: #1e3a8a;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }

  .inst-faculty {
    font-size: 8.5pt;
    font-weight: 600;
    color: #475569;
    margin-top: 1px;
  }

  .report-type-badge {
    display: inline-block;
    background-color: #dbeafe;
    color: #1e40af;
    font-size: 8pt;
    font-weight: 800;
    padding: 2px 8px;
    border-radius: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 5px;
    border: 1px solid #bfdbfe;
  }

  .report-topic {
    font-size: 10.5pt;
    font-weight: 800;
    color: #0f172a;
    line-height: 1.35;
    text-transform: uppercase;
    margin-bottom: 8px;
    letter-spacing: 0.2px;
  }

  .meta-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 3px 10px;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 5px;
    padding: 6px 10px;
    font-size: 8.5pt;
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

  /* TIÊU ĐỀ PHÂN MỤC */
  h2 {
    font-size: 10.8pt;
    font-weight: 700;
    color: #1e40af;
    margin-top: 10px;
    margin-bottom: 4px;
    padding-bottom: 2px;
    border-bottom: 1px solid #dbeafe;
    page-break-after: avoid;
    break-after: avoid;
  }

  h3 {
    font-size: 9.8pt;
    font-weight: 700;
    color: #0f172a;
    margin-top: 7px;
    margin-bottom: 3px;
    page-break-after: avoid;
    break-after: avoid;
  }

  p {
    margin-bottom: 4px;
    text-align: justify;
    line-height: 1.45;
  }

  ul, ol {
    margin-left: 18px;
    margin-bottom: 5px;
  }

  li {
    margin-bottom: 2.5px;
    text-align: justify;
    line-height: 1.42;
  }

  li ul, li ol {
    margin-top: 1px;
    margin-bottom: 1px;
    margin-left: 14px;
  }

  hr {
    display: none;
  }

  /* BẢNG BIỂU HỌC THUẬT: ĐỘ RỘNG VÀ PADDING GỌN GÀNG, LIỀN MẠCH */
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 4px;
    margin-bottom: 8px;
    font-size: 8.4pt;
  }

  /* KHỐI MỤC 3: GIỮ NGUYÊN KHỐI LIỀN MẠCH, KHÔNG BỊ TÁCH TRANG */
  .section-plan-block {
    page-break-inside: avoid;
    break-inside: avoid;
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
    padding: 3.5px 6px;
    vertical-align: middle;
    font-size: 8.4pt;
  }

  td {
    border: 1px solid #cbd5e1;
    padding: 3px 6px;
    vertical-align: middle;
    line-height: 1.32;
    color: #1e293b;
  }

  tbody tr:nth-child(even) {
    background-color: #f8fafc;
  }

  /* Định dạng cột bảng */
  table:nth-of-type(1) th:nth-child(1), table:nth-of-type(1) td:nth-child(1) { width: 32px; text-align: center; }
  table:nth-of-type(1) th:nth-child(3), table:nth-of-type(1) td:nth-child(3) { width: 85px; text-align: center; white-space: nowrap; }
  table:nth-of-type(1) th:nth-child(4), table:nth-of-type(1) td:nth-child(4) { width: 120px; text-align: center; white-space: nowrap; }

  table:nth-of-type(2) th:nth-child(1), table:nth-of-type(2) td:nth-child(1) { width: 32px; text-align: center; }
  table:nth-of-type(2) th:nth-child(3), table:nth-of-type(2) td:nth-child(3) { width: 105px; text-align: center; white-space: nowrap; }
  table:nth-of-type(2) th:nth-child(4), table:nth-of-type(2) td:nth-child(4) { width: 85px; text-align: center; white-space: nowrap; }

  .badge {
    display: inline-block;
    padding: 1px 5px;
    border-radius: 3px;
    font-size: 7.5pt;
    font-weight: 700;
    white-space: nowrap;
  }

  .badge-success { background-color: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
  .badge-exceed { background-color: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
  .priority-high { font-weight: 700; color: #dc2626; }
  .priority-med { font-weight: 700; color: #d97706; }

  code {
    font-family: Consolas, "Courier New", monospace;
    font-size: 8.2pt;
    background-color: #f1f5f9;
    border: 1px solid #e2e8f0;
    border-radius: 3px;
    padding: 1px 3.5px;
    color: #0f172a;
    font-weight: 600;
  }

  .closing-section {
    margin-top: 10px;
    page-break-inside: avoid;
    break-inside: avoid;
  }

  .closing-note {
    font-style: italic;
    margin-bottom: 4px;
    text-align: left;
    font-size: 8.8pt;
  }

  .signature-container {
    display: flex;
    justify-content: flex-end;
    margin-top: 4px;
  }

  .signature-box {
    text-align: center;
    min-width: 200px;
  }

  .sig-title { font-size: 10pt; margin-bottom: 1px; }
  .sig-sub { font-size: 8.5pt; color: #64748b; margin-bottom: 30px; }
  .sig-name { font-size: 10.5pt; font-weight: 700; color: #0f172a; }
</style>
</head>
<body>
${htmlBody}
</body>
</html>`;

fs.writeFileSync(outputHtmlPath, fullHtml, 'utf-8');
console.log(`[OK] Đã biên dịch HTML liền mạch (khung chữ ký cố định): ${path.basename(outputHtmlPath)}`);
