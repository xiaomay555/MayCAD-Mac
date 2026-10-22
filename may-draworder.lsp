; MayCAD Mac portable public module.
(defun c:F (/ ss)
  (setq ss (ssget "_I"))
  (if (not ss) (setq ss (ssget)))
  (if ss
    (progn (sssetfirst nil nil) (command "_.DRAWORDER" ss "" "_Front"))
  )
  (princ)
)
(defun c:B (/ ss)
  (setq ss (ssget "_I"))
  (if (not ss) (setq ss (ssget)))
  (if ss
    (progn (sssetfirst nil nil) (command "_.DRAWORDER" ss "" "_Back"))
  )
  (princ)
)
(princ)
