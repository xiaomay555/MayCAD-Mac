may_cabinet : dialog {
 label = "GZZ 柜子平面";
 : edit_box { key = "depth"; label = "柜深（mm）"; edit_width = 12; allow_accept = true; value = "$DEPTH$"; }
 : popup_list { key = "kind"; label = "柜型"; list = "高柜（到顶）\n半高柜（不到顶）"; value = "$KIND$"; width = 48; }
 : popup_list { key = "layer"; label = "生成图层"; width = 48; value = "$LAYER$"; list = "按柜型自动匹配\n$LAYERS$"; }
 : text { key = "error"; value = ""; width = 48; }
 ok_cancel;
}
