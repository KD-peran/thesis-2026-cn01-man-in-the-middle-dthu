#!/usr/bin/env bash
# Build ban LaTeX cua khoa luan (bao cao hoac slide bao ve) va copy PDF vao outputs/.
# Dung pdflatex + biber truc tiep (khong can latexmk/Perl).
# Chay lenh nay tu trong thu muc latex/.
#
#   bash scripts/build.sh khoa-luan.tex
#   bash scripts/build.sh slide-bao-ve.tex
#
# Ke thua tu: academic-os/bieu-mau/latex-slide-template/scripts/build-slide.sh
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Dung: build.sh <file.tex> [file2.tex ...]" >&2
  exit 1
fi

# Them MiKTeX vao PATH neu chua co (Windows / Git Bash)
WINUSER="${USER:-${USERNAME:-}}"
MIKTEX="/c/Users/$WINUSER/AppData/Local/Programs/MiKTeX/miktex/bin/x64"
[ -d "$MIKTEX" ] && export PATH="$MIKTEX:$PATH"

mkdir -p outputs

for tex in "$@"; do
  base="${tex%.tex}"
  echo "==> Build: $tex"
  pdflatex -interaction=nonstopmode -halt-on-error "$tex"
  # Chi chay biber khi dung biblatex. Khi danh muc tai lieu con rong, biber bao loi
  # nhung van build duoc PDF, nen o day chi canh bao chu khong dung ca script.
  if [ -f "$base.bcf" ]; then
    if ! biber "$base"; then
      echo "    [canh bao] biber bao loi. Thuong la do latex/tai-lieu-tham-khao.bib" >&2
      echo "    chua co muc nao. Danh muc tai lieu tham khao se trong trong PDF." >&2
    fi
  fi
  pdflatex -interaction=nonstopmode -halt-on-error "$tex"
  pdflatex -interaction=nonstopmode -halt-on-error "$tex"

  # Xoa file build trung gian, chi giu file .tex va .pdf
  rm -f "$base".aux "$base".bbl "$base".bcf "$base".blg "$base".fdb_latexmk \
        "$base".fls "$base".log "$base".nav "$base".out "$base".run.xml \
        "$base".snm "$base".synctex.gz "$base".toc "$base".lof "$base".lot
  mv -f "$base.pdf" outputs/

  echo "==> Da chuyen $base.pdf -> outputs/"
done

echo "Xong. PDF nam trong outputs/."
