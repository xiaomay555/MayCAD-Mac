may_door : dialog {
 label="MM 门型选择";
 : popup_list { key="kind"; label="门型"; list="内齐平带门套\n外齐平带门套\n隐形门\n对开推拉门\n三扇联动门\n内齐平2（直边门套）\n外齐平2（直边门套）"; value="$MODE$"; width=40; }
 : popup_list { key="count"; label="开扇"; list="单开\n双开（等宽）"; value="$COUNT$"; width=40; }
 : popup_list { key="angle"; label="开启"; list="全开 90°\n半开 30°"; value="$ANGLE$"; width=40; }
 : text { label="带套门：第一点内墙面，第二点外墙面，第三点定洞宽。"; }
 : text { label="齐平墙面固定；鼠标决定内开或外开。隐形、推拉、联动两点定宽。"; }
 : text { label="再移动鼠标确定方向，点击生成整樘门块。"; }
 : text { key="error"; label=""; width=58; }
 ok_cancel;
}
