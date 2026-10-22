---
name: kiem-tra-tai-lieu-tham-khao
description: Ra soat danh muc tai lieu tham khao - doi chieu trich dan voi danh muc, kiem tra truong bat buoc, va phat hien muc chua duoc kiem chung. Dung khi nguoi dung them tai lieu tham khao, chuan bi nop, hoac CI bao loi trich dan.
---

# Kiem Tra Tai Lieu Tham Khao

## Khi nao dung

Nguoi dung them tai lieu vao danh muc, chuan bi nop bai, hoac GitHub Actions bao loi o job
"Kiem tra tai lieu tham khao".

## Vi sao viec nay quan trong

Rubric cham o tieu chi 5: mot trich dan khong ton tai trong danh muc lam ca tieu chi rot
xuong muc "chua dat". Nghiem trong hon, tai lieu tham khao bia dat la loi liem chinh hoc
thuat, khong phai loi ky thuat.

## Buoc 1: Chay kiem tra tu dong

```bash
python .github/scripts/kiem_tra_trich_dan.py
```

Script bao ba loai loi: trich dan khong co trong danh muc, muc trong danh muc khong duoc
trich dan, va muc thieu truong bat buoc.

## Buoc 2: Xu ly tung loai loi

**Trich dan khong co trong danh muc.** Hoac tim tai lieu that va them vao, hoac bo trich
dan do khoi bai. Khong duoc tao muc gia cho khop.

**Muc khong duoc trich dan.** Tai lieu doc roi nhung khong dung den thi bo khoi danh muc.
Danh muc khong phai cho de khoe da doc bao nhieu.

**Thieu truong bat buoc.** Moi muc can `author`, `title`, `year`, va `doi` hoac `url`.
Thieu truong thuong la dau hieu muc do chua duoc kiem chung tu nguon goc.

## Buoc 3: Ra soat thu cong nhung cho may khong bat duoc

Voi moi muc trong danh muc, tu hoi:

- Cong trinh nay co that khong? Da mo duong dan hoac DOI ra xem chua?
- Ten tac gia, nam, noi cong bo co dung nhu tren ban goc khong?
- Noi dung trich dan co dung y cua tac gia khong, hay bi suy dien?
- Neu la tai lieu ve cong nghe: co con phu hop khong, hay da qua cu?

## Buoc 4: Doi chieu voi yeu cau cua de cuong

Chuong 2 yeu cau toi thieu 15 tai lieu, trong do it nhat 8 cong bo tu nam 2020 tro lai.
Dem lai va bao con thieu bao nhieu.

## Nguyen tac

Khi nguoi dung yeu cau "them vai tai lieu tham khao cho du so luong", tu choi va giai
thich: so luong khong phai muc tieu, tai lieu chua doc thi khong dua vao danh muc duoc.
