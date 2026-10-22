#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
PIPELINE CHỨC NĂNG "TOOL TRỒNG TOOL" (TOOL-CHAINING ORCHESTRATOR)
----------------------------------------------------------------
Quy trình thực thi liên hoàn trong duy nhất 1 thư mục 'tool/':
  [1] Quét file Markdown nguồn trong thư mục new/ (ví dụ: tong-hop-lan-1.md)
  [2] Tra từ trên xuống dưới, bóc tách tất cả các khối ```mermaid ... ```
  [3] Tách mỗi sơ đồ thành file .md độc lập trong tool/new/
      -> Đặt tên: <tên-gốc>-1.md, <tên-gốc>-2.md, ...
  [4] Kích hoạt Tool vẽ sơ đồ (tool/export_png.py)
      -> Xuất ảnh PNG độ nét cao (HD 2x) vào tool/images/: <tên-gốc>-1.png, ...
  [5] Tự động thế chỗ khối Mermaid bằng thẻ hình ảnh PNG đã vẽ
      kèm khung viền học thuật & chú thích (Caption)
  [6] Kích hoạt Tool xuất PDF (tool/convert_to_pdf.js + Chrome/Edge Headless)
      -> Xuất ra file PDF hoàn chỉnh trong thư mục noi-dung-tong-hop/<tên-gốc>.pdf
"""

import sys
import os
import re
import subprocess
import shutil

# Đảm bảo mã hóa UTF-8 chuẩn trên Windows Terminal
if sys.platform.startswith('win'):
    try:
        sys.stdout.reconfigure(encoding='utf-8')
        sys.stderr.reconfigure(encoding='utf-8')
    except Exception:
        pass

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(SCRIPT_DIR)
NEW_DIR = os.path.join(ROOT_DIR, "new")
TOOL_DIR = SCRIPT_DIR
TOOL_NEW_DIR = os.path.join(TOOL_DIR, "new")
TOOL_IMAGES_DIR = os.path.join(TOOL_DIR, "images")
EXPORT_PNG_PY = os.path.join(TOOL_DIR, "export_png.py")
CONVERT_PDF_JS = os.path.join(TOOL_DIR, "convert_to_pdf.js")

# Nạp hàm render_mermaid_to_png trực tiếp hoặc dự phòng qua importlib
try:
    from export_png import render_mermaid_to_png
except ImportError:
    import importlib.util
    def _load_render_fn():
        if os.path.exists(EXPORT_PNG_PY):
            try:
                spec = importlib.util.spec_from_file_location("export_png_module", EXPORT_PNG_PY)
                if spec and spec.loader:
                    mod = importlib.util.module_from_spec(spec)
                    spec.loader.exec_module(mod)
                    return getattr(mod, "render_mermaid_to_png", None)
            except Exception:
                pass
        return None
    render_mermaid_to_png = _load_render_fn()

def find_browser():
    """Tìm Chrome hoặc Edge headless trên Windows"""
    candidates = [
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    ]
    for c in candidates:
        if os.path.exists(c):
            return c
    return None

def extract_caption(text_before, idx):
    """Trích xuất tiêu đề gần nhất trước khối Mermaid để làm chú thích hình"""
    lines = [l.strip() for l in text_before.strip().split("\n") if l.strip()]
    for line in reversed(lines[-8:]):
        # Kiểm tra tiêu đề markdown (# ## ### ####) hoặc chữ đậm (**...**)
        m = re.match(r"^(?:#{1,6}|\*\*)\s*(?:[0-9]+(?:\.[0-9]+)*\.?\s*)?(.*?)(?:\*\*|#)*$", line)
        if m:
            title = m.group(1).strip()
            title = re.sub(r"^[:\-–—\s]+", "", title)
            title = re.sub(r"[`*]", "", title)
            if len(title) > 3:
                return title
    return f"Sơ đồ quy trình kỹ thuật hệ thống {idx}"

def process_markdown_file(md_path, scale=2):
    base_name = os.path.splitext(os.path.basename(md_path))[0]
    print("=" * 65)
    print(f"[*] BẮT ĐẦU XỬ LÝ TÀI LIỆU: {os.path.basename(md_path)}")
    print(f"    Thư mục nguồn: {md_path}")
    print("=" * 65)

    with open(md_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Tạo thư mục đích trong tool
    os.makedirs(TOOL_NEW_DIR, exist_ok=True)
    os.makedirs(TOOL_IMAGES_DIR, exist_ok=True)

    # Tìm các khối ```mermaid ... ```
    pattern = re.compile(r"```mermaid\s*(.*?)\s*```", re.DOTALL)
    matches = list(pattern.finditer(content))
    total_diagrams = len(matches)

    print(f"[+] Tìm thấy {total_diagrams} sơ đồ Mermaid trong tài liệu.")

    extracted_images = []
    transformed_content = ""
    last_end = 0

    for idx, match in enumerate(matches, 1):
        start, end = match.span()
        diagram_code = match.group(1).strip()
        
        # Phần nội dung trước khối mermaid
        text_before = content[last_end:start]
        caption = extract_caption(text_before, idx)

        # 1. Tách ra file .md riêng trong tool/new/
        sub_md_name = f"{base_name}-{idx}.md"
        sub_md_path = os.path.join(TOOL_NEW_DIR, sub_md_name)
        
        with open(sub_md_path, "w", encoding="utf-8") as smf:
            smf.write(f"# Sơ đồ {idx}: {caption}\n\n```mermaid\n{diagram_code}\n```\n")

        print(f"  -> [{idx}/{total_diagrams}] Đã tách: {os.path.relpath(sub_md_path, ROOT_DIR)}")

        # 2. Vẽ sơ đồ sang PNG trong tool/images/
        sub_png_name = f"{base_name}-{idx}.png"
        sub_png_path = os.path.join(TOOL_IMAGES_DIR, sub_png_name)
        
        print(f"     Render ảnh HD (scale={scale}): {sub_png_name}...", flush=True)
        success = False
        if render_mermaid_to_png:
            success = render_mermaid_to_png(sub_md_path, sub_png_path, scale=scale)
        else:
            # Fallback gọi qua CLI
            res = subprocess.run([sys.executable, EXPORT_PNG_PY, sub_md_path, sub_png_path, str(scale)],
                                 capture_output=True, text=True, encoding="utf-8", errors="replace")
            success = (res.returncode == 0 and os.path.exists(sub_png_path))

        if success and os.path.exists(sub_png_path):
            extracted_images.append(sub_png_path)
            
            # 3. Tạo thẻ chèn hình ảnh chuẩn học thuật vào tài liệu
            # Sử dụng absolute file URI dạng forward slash để Chrome/Edge render chuẩn xác tuyệt đối
            abs_png_uri = sub_png_path.replace("\\", "/")
            if not abs_png_uri.startswith("/"):
                abs_png_uri = "/" + abs_png_uri
            file_url = f"file://{abs_png_uri}"

            replacement_html = f"""
<div class="diagram-figure">
  <div class="diagram-img-wrapper">
    <img src="{file_url}" alt="Hình {idx}: {caption}" />
  </div>
  <div class="diagram-caption"><strong>Hình {idx}:</strong> {caption}</div>
</div>
"""
            transformed_content += text_before + replacement_html
        else:
            print(f" [LỖI] Không thể xuất ảnh {sub_png_name}. Giữ nguyên khối Mermaid gốc.")
            transformed_content += text_before + match.group(0)

        last_end = end

    # Thêm đoạn nội dung còn lại sau khối mermaid cuối cùng
    transformed_content += content[last_end:]

    # Lưu file markdown tạm thời đã nhúng hình ảnh
    temp_md_path = os.path.join(SCRIPT_DIR, f".temp_{base_name}_with_images.md")
    with open(temp_md_path, "w", encoding="utf-8") as tmf:
        tmf.write(transformed_content)

    print("-" * 65)
    print(f"[*] Đã nhúng {len(extracted_images)} hình ảnh sơ đồ vào tài liệu tạm.")
    print(f"[*] Kích hoạt Tool biên dịch HTML & Xuất PDF...")

    # Biên dịch sang HTML
    temp_html_path = os.path.join(SCRIPT_DIR, f"{base_name}.html")
    res_node = subprocess.run(["node", CONVERT_PDF_JS, temp_md_path, temp_html_path],
                              cwd=SCRIPT_DIR, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if res_node.returncode != 0:
        print(f"[LỖI] convert_to_pdf.js thất bại:\n{res_node.stderr}")
        return False

    if not os.path.exists(temp_html_path):
        print(f"[LỖI] Không tìm thấy file HTML đã biên dịch: {temp_html_path}")
        return False

    # Tìm trình duyệt để xuất PDF
    browser = find_browser()
    if not browser:
        print("[LỖI] Không tìm thấy Google Chrome hoặc Microsoft Edge trên máy!")
        return False

    browser_name = os.path.basename(browser)
    pdf_out_path = os.path.join(ROOT_DIR, f"{base_name}.pdf")

    print(f"[*] Đang xuất PDF qua {browser_name} Headless...")
    browser_args = [
        browser,
        "--headless=new",
        "--disable-gpu",
        "--no-pdf-header-footer",
        "--run-all-compositor-stages-before-draw",
        f"--print-to-pdf={pdf_out_path}",
        temp_html_path
    ]
    subprocess.run(browser_args, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # Dọn dẹp file tạm
    try:
        if os.path.exists(temp_md_path):
            os.remove(temp_md_path)
        if os.path.exists(temp_html_path):
            os.remove(temp_html_path)
    except Exception:
        pass

    if os.path.exists(pdf_out_path):
        pdf_size_kb = round(os.path.getsize(pdf_out_path) / 1024, 1)
        print("=" * 65)
        print(f"[THÀNH CÔNG] ĐÃ XUẤT XONG FILE PDF HOÀN CHỈNH!")
        print(f"  + File PDF  : {os.path.relpath(pdf_out_path, ROOT_DIR)} ({pdf_size_kb} KB)")
        print(f"  + Đường dẫn : {pdf_out_path}")
        print(f"  + Sơ đồ MD  : {TOOL_NEW_DIR}")
        print(f"  + Sơ đồ PNG : {TOOL_IMAGES_DIR}")
        print("=" * 65)
        return True
    else:
        print(f"[LỖI] Không thể tạo file PDF tại {pdf_out_path}")
        return False

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Pipeline Tool Trồng Tool: Bóc tách Mermaid -> Render PNG -> Nhúng tài liệu -> Xuất PDF")
    parser.add_argument("-f", "--file", help="Đường dẫn file .md cần xử lý (mặc định quét thư mục new/)")
    parser.add_argument("-s", "--scale", type=int, default=2, help="Độ phân giải ảnh render sơ đồ (mặc định: 2)")
    args = parser.parse_args()

    files_to_process = []
    if args.file:
        if os.path.exists(args.file):
            files_to_process.append(os.path.abspath(args.file))
        else:
            cand1 = os.path.join(NEW_DIR, args.file)
            cand2 = os.path.join(ROOT_DIR, args.file)
            if os.path.exists(cand1):
                files_to_process.append(cand1)
            elif os.path.exists(cand2):
                files_to_process.append(cand2)
            else:
                print(f"[LỖI] Không tìm thấy file: {args.file}")
                sys.exit(1)
    else:
        if os.path.exists(NEW_DIR):
            for f in os.listdir(NEW_DIR):
                if f.endswith(".md"):
                    files_to_process.append(os.path.join(NEW_DIR, f))

    if not files_to_process:
        print(f"[THÔNG BÁO] Không tìm thấy file .md nào trong thư mục '{os.path.relpath(NEW_DIR, ROOT_DIR)}'!")
        sys.exit(0)

    print(f"Tìm thấy {len(files_to_process)} file cần xử lý trong pipeline.")
    for f in files_to_process:
        process_markdown_file(f, scale=args.scale)

if __name__ == "__main__":
    main()
