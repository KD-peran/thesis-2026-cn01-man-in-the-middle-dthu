#!/usr/bin/env python3
"""PreToolUse hook: chan ghi vao nhung cho khong duoc ghi, va nhac quy tac khoa luan.

Ba muc do:
  deny     - chan han (bi mat, du lieu thuc nghiem tho)
  ask      - hoi xac nhan (danh muc tai lieu tham khao)
  canh bao - chi nhac, khong chan (chuan Markdown)
"""
import json
import re
import sys
from pathlib import Path

# Windows mac dinh khong dung UTF-8 cho stdin/stdout -> hong tieng Viet co dau.
for _luong in (sys.stdin, sys.stdout):
    if hasattr(_luong, "reconfigure"):
        _luong.reconfigure(encoding="utf-8", errors="replace")

# --- Chan han ----------------------------------------------------------------
CHAN = [
    (
        re.compile(r"(^|/)\.env(\.|$)"),
        "Tep .env chua bi mat (khoa API, mat khau, chuoi ket noi) va khong bao gio duoc "
        "dua vao repo. Khai bao TEN bien trong code/.env.example, gia tri that de o may "
        "cuc bo.",
    ),
    (
        re.compile(r"^thuc-nghiem/du-lieu/(?!\.gitkeep$)"),
        "thuc-nghiem/du-lieu/ chi chua du lieu tho, khong theo doi bang git (xem "
        ".gitignore) va co the chua du lieu cua doanh nghiep. Mo ta bo du lieu trong "
        "thuc-nghiem/README.md thay vi tao tep o day.",
    ),
    (
        re.compile(r"(^|/)(id_rsa|id_ed25519|.*\.pem|.*\.pfx|.*\.p12)$"),
        "Day la tep khoa rieng. Khong dua khoa vao repo.",
    ),
]

# --- Hoi xac nhan ------------------------------------------------------------
HOI = [
    (
        re.compile(r"^latex/tai-lieu-tham-khao\.bib$"),
        "Dang ghi vao danh muc tai lieu tham khao.\n"
        "Moi muc phai la cong trinh CO THAT, da doc va kiem chung duoc, co du "
        "author, title, year va doi hoac url.\n"
        "Khong duoc bia ten tac gia, nam, hay DOI. Mot trich dan sai lam hong tieu chi "
        "trinh bay khi cham, va la loi liem chinh hoc thuat.\n"
        "Da kiem chung moi muc sap ghi chua?",
    ),
]

# --- Mien tru kiem tra chuan Markdown ---------------------------------------
MIEN_TRU_TEN = {"README.md", "CLAUDE.md", "AGENTS.md", "CONTRIBUTING.md"}
MIEN_TRU_TIEN_TO = (".claude/", ".github/")


def tra_loi(quyet_dinh, ly_do):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": quyet_dinh,
            "permissionDecisionReason": ly_do,
        }
    }))
    sys.exit(0)


def canh_bao(noi_dung):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "additionalContext": noi_dung,
        }
    }))
    sys.exit(0)


def main():
    try:
        du_lieu = json.load(sys.stdin)
    except Exception:
        sys.exit(0)

    tool_input = du_lieu.get("tool_input") or {}
    duong_dan = tool_input.get("file_path")
    if not duong_dan:
        sys.exit(0)

    goc = Path.cwd()
    try:
        tuong_doi = Path(duong_dan).resolve().relative_to(goc.resolve()).as_posix()
    except ValueError:
        sys.exit(0)  # ngoai repo, khong quan ly

    for mau, ly_do in CHAN:
        if mau.search(tuong_doi):
            tra_loi("deny", "CHAN GHI: %s\n%s" % (tuong_doi, ly_do))

    for mau, ly_do in HOI:
        if mau.search(tuong_doi):
            tra_loi("ask", ly_do)

    ten = Path(tuong_doi).name

    if ten in MIEN_TRU_TEN or tuong_doi.startswith(MIEN_TRU_TIEN_TO):
        sys.exit(0)

    # Chuan Markdown: mot H1 va co muc Muc dich. Chi nhac, khong chan.
    if ten.endswith(".md"):
        noi_dung = tool_input.get("content")
        if noi_dung:
            so_h1 = len(re.findall(r"^# ", noi_dung, re.MULTILINE))
            thieu = []
            if so_h1 != 1:
                thieu.append("phai co dung mot tieu de cap mot (dang thay %d)" % so_h1)
            if "## Mục đích" not in noi_dung and "## Muc dich" not in noi_dung:
                thieu.append("thieu muc '## Mục đích' ngay sau tieu de")
            if thieu:
                canh_bao("[chuan tai lieu] %s: %s. Xem CLAUDE.md." % (ten, "; ".join(thieu)))

    sys.exit(0)


if __name__ == "__main__":
    main()
