import sys
import os
import re
import json
import base64
import time
import requests

def render_mermaid_to_png(input_file_path, output_png_path=None, scale=2, retries=3):
    if not os.path.exists(input_file_path):
        print(f"[LỖI] Không tìm thấy file nguồn: {input_file_path}", file=sys.stderr)
        return False

    with open(input_file_path, "r", encoding="utf-8") as f:
        text = f.read()

    # Nếu là file markdown, tìm khối ```mermaid ... ```
    m = re.search(r"```mermaid\s*(.*?)\s*```", text, re.DOTALL)
    code = m.group(1).strip() if m else text.strip()

    if not output_png_path:
        base, _ = os.path.splitext(input_file_path)
        output_png_path = base + ".png"

    # Gửi request lên mermaid.ink với scale HD
    payload = {"code": code, "mermaid": {"theme": "default"}}
    json_bytes = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    b64 = base64.urlsafe_b64encode(json_bytes).decode("ascii")
    url = f"https://mermaid.ink/img/{b64}?type=png&scale={scale}"

    os.makedirs(os.path.dirname(os.path.abspath(output_png_path)), exist_ok=True)

    for attempt in range(1, retries + 1):
        try:
            resp = requests.get(url, timeout=20)
            if resp.status_code == 200:
                with open(output_png_path, "wb") as out:
                    out.write(resp.content)
                size_kb = round(len(resp.content) / 1024, 1)
                base = os.path.basename(output_png_path)
                print(f"[OK] Đã xuất {base} ({size_kb} KB)")
                return True
            else:
                print(f"[CẢNH BÁO] Lần {attempt}/{retries} - Lỗi HTTP {resp.status_code}: {resp.text[:150]}", file=sys.stderr)
        except Exception as e:
            print(f"[CẢNH BÁO] Lần {attempt}/{retries} - Lỗi kết nối: {e}", file=sys.stderr)

        if attempt < retries:
            time.sleep(1.5 * attempt)

    print(f"[LỖI] Không thể xuất ảnh Mermaid sau {retries} lần thử: {input_file_path}", file=sys.stderr)
    return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Sử dụng: python export_png.py <input.md|input.mmd> [output.png] [scale]")
        sys.exit(1)
    
    inp = sys.argv[1]
    out = sys.argv[2] if len(sys.argv) > 2 else None
    scale_val = int(sys.argv[3]) if len(sys.argv) > 3 else 2
    success = render_mermaid_to_png(inp, out, scale=scale_val)
    sys.exit(0 if success else 1)

