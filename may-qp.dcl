may_qp : dialog {
 label = "QP 批量打印";
 : text { label = "框选本次要导出的图框，仅打印选中图框。"; }
 : edit_box { key="folder"; label="输出文件夹"; edit_width=52; value="$FOLDER$"; }
 : row {
  : popup_list { key="format"; label="格式"; list="PDF\nJPG（同时保留PDF）"; value="$FORMAT$"; width=23; }
  : popup_list { key="paper"; label="纸张"; list="A4\nA3\nA2\nA1"; value="$PAPER$"; width=15; }
 }
 : popup_list { key="ctb"; label="打印样式"; list="$CTBS$"; value="$CTB$"; width=54; }
 : row {
  : edit_box { key="scale"; label="比例 1:"; value="$SCALE$"; edit_width=9; }
  : text { label="填0＝布满图纸"; }
  : edit_box { key="pad"; label="框外留白(mm)"; value="$PAD$"; edit_width=8; }
 }
 : text { label="保留不打印图层设置；不保存页面设置，不改图形。"; }
 : text { key="error"; label=""; width=68; }
 ok_cancel;
}
