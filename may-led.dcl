may_led : dialog {
 label = "EDD 灯带平面";
 : edit_box { key="offset"; label="灯带离基线（mm）"; value="$OFFSET$"; edit_width=10; }
 : popup_list { key="kind"; label="灯带线型"; list="点划线  M-DASHDOT\nLED字样  LED_LINE"; value="$KIND$"; width=34; }
 : text { label="自动图层：通用灯带图层，颜色和线宽随图层。"; }
 : text { key="error"; value=""; width=48; }
 ok_cancel;
}
