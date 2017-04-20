(require 'chinese-pyim)
(require 'chinese-pyim-basedict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
(chinese-pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(require 'chinese-pyim-greatdict) ; 大词库，可能会导致启动缓慢
(chinese-pyim-greatdict-enable)

(setq pyim-page-style 'one-line)
(setq pyim-page-tooltip 'popup)
;; (setq pyim-page-tooltip 'pos-tip)
;; (if linuxp
;;     (setq pyim-page-tooltip 'pos-tip))
;; (if linuxp
;;     (setq x-gtk-use-system-tooltips t))

(setq pyim-page-length 5)
(setq default-input-method "chinese-pyim")


(setq pyim-default-scheme 'quanpin)

;; (setq-default pyim-english-input-switch-functions
;;                 '(pyim-probe-dynamic-english
;;                   pyim-probe-isearch-mode))

(provide 'my-im)
