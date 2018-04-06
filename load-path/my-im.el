(require 'pyim)
(require 'pyim-basedict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
(pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置

(setq pyim-page-style 'one-line)
(setq pyim-page-tooltip 'popup)
;; (setq pyim-page-tooltip 'pos-tip)
;; (if linuxp
;;     (setq pyim-page-tooltip 'pos-tip))
;; (if linuxp
;;     (setq x-gtk-use-system-tooltips t))

(setq pyim-page-length 5)
(setq default-input-method "pyim")

(pyim-isearch-mode 1)

;; (setq pyim-page-tooltip 'popup)
(setq pyim-page-tooltip 'posframe) ; require manual install posframe

(setq pyim-default-scheme 'quanpin)

;; (setq-default pyim-english-input-switch-functions
;;                 '(pyim-probe-dynamic-english
;;                   pyim-probe-isearch-mode))

(provide 'my-im)
