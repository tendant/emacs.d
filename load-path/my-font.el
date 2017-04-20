;; Font configuration when using Emacs 
(add-hook 'after-make-window-system-frame-hooks
          (lambda ()
            (my-font-config)))

(when (display-graphic-p)
  (setq my-font-options
        (cond ((eq system-type 'darwin)     '("Monaco"     "STHeiti"))
              ((eq system-type 'gnu/linux)  '("Menlo"     "WenQuanYi Zen Hei"))
              ((eq system-type 'windows-nt) '("Consolas"  "Microsoft Yahei")))))

;; I don't know why I need these two.
;; (setq face-font-rescale-alist '(("STHeiti" . 1) ("Microsoft Yahei" . 1) ("WenQuanYi Zen Hei" . 1)))
;; (set-face-attribute 'default nil :font
;;                    (format "%s:pixelsize=%d" (car my-font-options) 12))

(defun fix-mac-osx-issue ()
  "Fix mac osx Chinese font issue"
  (if (and mac-osx-x-p (>= emacs-major-version 23))
      ;; this is good for all
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family (car (cdr my-font-options)))))))

(defun my-font-config ()
  "Configure font for Linux."
  (if (and linuxp (>= emacs-major-version 23))
      (progn
        ;; (set-default-font "Bitstream Vera Sans Mono-8")
        ;; (set-default-font "DejaVu Sans Mono-8")
        (set-default-font "Inconsolata-11") ; sudo apt-get install fonts-inconsolata
        ;; set the default font for chinese.
        (set-fontset-font "fontset-default"
                          'unicode '("Microsoft YaHei" . "unicode-bmp")) 
        (message "my-font.el: configured font for emacs 23")
        ))
  (fix-mac-osx-issue)
  (if (and linuxp (< emacs-major-version 23))
      (progn 
        ;;       (create-fontset-from-fontset-spec
        ;;        "-*-courier-medium-R-normal--14-*-*-*-*-*-fontset-mymono,
        ;;         chinese-gb2312:-*-wenquanyi bitmap song-medium-*-normal--14-*-*-*-*-*-iso10646-1,
        ;;         chinese-gbk:-*-wenquanyi bitmap song-medium-*-normal--14-*-*-*-*-*-iso10646-1,
        ;;         chinese-gb18030:-*-wenquanyi bitmap song-medium-*-normal--14-*-*-*-*-*-iso10646-1"
        ;;        )
        (create-fontset-from-fontset-spec
         "-bitstream-bitstream vera sans mono-medium-r-normal--*-*-*-*-*-*-fontset-bitstreammono,
        ascii:-bitstream-bitstream vera sans mono-medium-r-normal-*-*-*-100-100-*-*-iso8859-1,
        latin-iso8859-1:-bitstream-bitstream vera sans mono-medium-r-normal-*-*-*-100-100-*-*-iso8859-1,
        chinese-gb2312:-*-wenquanyi bitmap song-medium-*-normal--9-*-*-*-*-*-iso10646-1,
        chinese-gbk:-*-wenquanyi bitmap song-medium-*-normal--9-*-*-*-*-*-iso10646-1,
        chinese-gb18030:-*-wenquanyi bitmap song-medium-*-normal--9-*-*-*-*-*-iso10646-1")
        (setq default-frame-alist
              (append '((font . "fontset-bitstreammono"))
                      default-frame-alist))
        (set-default-font "fontset-bitstreammono")
        (message "*** Configure font done.")
        )))



;; configure font, if current process is not daemon.
(if (or
     (not (boundp 'daemonp))
     (not (daemonp)))
    (progn
      (my-font-config)
      (message "Loaded my-font.el")))

(require 'chinese-fonts-setup)
(chinese-fonts-setup-enable) ; enable setup
(cfs-set-spacemacs-fallback-fonts) ; fix unicode icon display in spacemacs mode-line
(setq cfs-profiles
    '("program" "org-mode" "read-book"))

(defun zoom-font (n)
  "with positive N, increase the font size, otherwise decrease it"
  (set-face-attribute 'default (selected-frame) :height 
    (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10)))
  ;; need this for mac osx Chinese font issue after zooming 
  (fix-mac-osx-issue))

(global-set-key (kbd "C-=")      '(lambda nil (interactive) (if linuxp
                                                                (cfs-increase-fontsize)
                                                              (zoom-font 1))))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (if linuxp
                                                                (cfs-increase-fontsize)
                                                              (zoom-font 1))))
(global-set-key (kbd "C--")      '(lambda nil (interactive) (if linuxp
                                                                (cfs-decrease-fontsize)
                                                              (zoom-font -1))))
(global-set-key [C-kp-subtract]  '(lambda nil (interactive) (if linuxp
                                                                (cfs-decrease-fontsize)
                                                              (zoom-font -1))))


(provide 'my-font)
