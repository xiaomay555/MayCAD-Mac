may_curtain : dialog {
 label = "CLPM 窗帘平面";
 : popup_list { key="count"; label="窗帘"; list="单层\n双层"; value="$COUNT$"; width=42; }
 : edit_box { key="thick"; label="每层厚度（mm）"; value="$THICK$"; edit_width=10; }
 : edit_box { key="offset"; label="窗帘中心离墙（mm）"; value="$OFFSET$"; edit_width=10; }
 : edit_box { key="gap"; label="双层中心间距（mm）"; value="$GAP$"; edit_width=10; }
 : popup_list { key="curtainlayer"; label="窗帘图层"; list="$LAYERS$"; value="$CURTAINLAYER$"; width=48; }
 : text { key="error"; value=""; width=54; }
 ok_cancel;
}
