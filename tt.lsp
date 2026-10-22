; MayCAD Mac portable public module.
(defun c:TT (/ ss)
  (setq ss (ssget))
  (if ss
    (command "_.HIDEOBJECTS" ss "")
    (command "_.UNISOLATEOBJECTS")
  )
  (princ)
)
(princ)
