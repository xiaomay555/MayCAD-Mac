; MayCAD Mac portable public module.
(defun c:TY (/ ss)
  (setq ss (ssget))
  (if ss
    (command "_.ISOLATEOBJECTS" ss "")
    (command "_.UNISOLATEOBJECTS")
  )
  (princ)
)
(princ)
