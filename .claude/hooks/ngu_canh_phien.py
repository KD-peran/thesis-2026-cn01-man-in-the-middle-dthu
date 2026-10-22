#!/usr/bin/env python3
"""SessionStart hook: nap ngu canh de tai vao dau phien lam viec.

In ra: ma de tai, thanh vien, tien do chuc nang cam ket, bien ban gan nhat,
so o TODO con lai, va nhac cac quy tac cot loi.
"""
import re
import subprocess
import sys
from pathlib import Path

# Windows mac dinh dung cp1252 cho stdout, khong in duoc tieng Viet co dau.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

GOC = Path.cwd()


def doc(duong_dan):
    try:
        return duong_dan.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def lay_tu_bang(noi_dung, nhan):
    """Lay gia tri cot 2 cua dong bang Markdown co cot 1 khop nhan."""
    mau = re.compile(r"^\|\s*%s\s*\|\s*(.+?)\s*\|" % re.escape(nhan), re.MULTILINE)
    khop = mau.search(noi_dung)
    return khop.group(1) if khop else None


def dem_todo():
    tong = 0
    for thu_muc in ("bao-cao", "latex", "huong-dan", "code", "thuc-nghiem"):
        for p in (GOC / thu_muc).rglob("*"):
            if p.suffix in (".md", ".tex") and p.is_file():
                tong += doc(p).count("TODO")
    return tong


def bien_ban_gan_nhat():
    thu_muc = GOC / "huong-dan" / "bien-ban"
    if not thu_muc.is_dir():
        return None
    ds = sorted(p.name for p in thu_muc.glob("*.md"))
    return ds[-1] if ds else None


def commit_gan_nhat():
    try:
        kq = subprocess.run(
            ["git", "log", "-3", "--pretty=%h %s"],
            capture_output=True, text=True, timeout=10, cwd=GOC,
        )
        return kq.stdout.strip() if kq.returncode == 0 else ""
    except Exception:
        return ""


def main():
    readme = doc(GOC / "README.md")
    de_cuong = doc(GOC / "bao-cao" / "de-cuong-khoa-luan.md")

    dong = ["## Ngu canh khoa luan (tu dong nap dau phien)", ""]

    ma = lay_tu_bang(readme, "Mã đề tài")
    sv = lay_tu_bang(readme, "Sinh viên thực hiện")
    if ma:
        dong.append("**Ma de tai:** %s" % ma)
    if sv:
        dong.append("**Thanh vien:** %s" % sv)

    # Tieu de de tai = dong H1 dau tien cua README
    khop = re.search(r"^#\s+(.+)$", readme, re.MULTILINE)
    if khop:
        dong.append("**De tai:** %s" % khop.group(1).strip())

    # Tien do chuc nang cam ket: dem trang thai trong bang o de cuong
    if de_cuong:
        chua = len(re.findall(r"\|\s*Chưa bắt đầu\s*\|", de_cuong))
        dang = len(re.findall(r"\|\s*Đang làm\s*\|", de_cuong))
        xong = len(re.findall(r"\|\s*Hoàn thành\s*\|", de_cuong))
        if chua or dang or xong:
            dong.append(
                "**Chuc nang cam ket:** %d hoan thanh, %d dang lam, %d chua bat dau"
                % (xong, dang, chua)
            )

    bb = bien_ban_gan_nhat()
    dong.append("**Bien ban gan nhat:** %s" % (bb if bb else "chua co bien ban nao"))
    dong.append("**O TODO con lai:** %d" % dem_todo())

    lich_su = commit_gan_nhat()
    if lich_su:
        dong.append("")
        dong.append("**Commit gan day:**")
        for d in lich_su.splitlines():
            dong.append("- %s" % d)

    dong += [
        "",
        "**Nhac quy tac (chi tiet trong CLAUDE.md):**",
        "- Khong bia so lieu thuc nghiem, tai lieu tham khao, hay du lieu hoc vu.",
        "- Tai lieu viet tieng Viet co dau, moi tep mot H1 va co muc Mục đích.",
        "- Lam viec thang tren nhanh main, commit nho va thuong xuyen.",
        "- Build LaTeX chay tu trong thu muc latex/.",
    ]

    print("\n".join(dong))
    sys.exit(0)


if __name__ == "__main__":
    main()
