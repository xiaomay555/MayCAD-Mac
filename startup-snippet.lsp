; MAYCAD-MANAGED-STARTUP-BEGIN
(setq may:root(strcat(getenv "HOME")"/Library/Application Support/MayCAD/"))
(if(findfile(strcat may:root "maycad.lsp"))(progn(if(not(vl-string-search may:root(getvar "TRUSTEDPATHS")))(setvar "TRUSTEDPATHS"(strcat(getvar "TRUSTEDPATHS")";" may:root)))(load(strcat may:root "maycad.lsp"))))
; MAYCAD-MANAGED-STARTUP-END
