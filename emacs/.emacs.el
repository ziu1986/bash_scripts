;;;;
;;;; Re-organized 9.11.99.
;;;;

;;;
;;; Auto compilation of the .emacs.el file
;;;

;;
;; If the file .emacs.el is newer than the byte compiled version 
;; (called .emacs) .emacs.el is byte compiled and the byte compiled 
;; file .emacs.elc is replacing the .emacs file and  reloaded 
;; so the changes can take effect. 
;; This part of my .emacs file is stolen from Travis Corcoran.
;;
;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq debug-on-error t)

;;
;; switch off annoying beeps 
;;
(setq ring-bell-function '(lambda ()))

;; detabify for Darko
(setq-default indent-tabs-mode nil)

;; change default behavior when opening windows to side-by-side
;;(split-window-horizontally)
;;
;; recompile if needed
;;
(if (file-newer-than-file-p "~/.emacs.el" "~/.emacs")
    (progn;; if the .emacs file is out of date then recompile and load.
      (message "*** recompiling .emacs.el ***")
      (sit-for 1)
      (byte-compile-file "~/.emacs.el")
      (rename-file "~/.emacs.elc" "~/.emacs" t)
      (message "*** loading the new .emacs ***")
      (sit-for 3)
      (load "~/.emacs" t t t)
      (message "*** .emacs recompiled and loaded ***")
      (sit-for 1))

  (progn
    ;; the else part of the statement, this is the actual .emacs file.

;;;
;;; Misc. configuration options.
;;;
    (global-set-key [select] 'end-of-buffer)
    (global-set-key "\C-x\C-a" 'beginning-of-buffer)
    (global-set-key "\C-x\C-e" 'end-of-buffer)
    (global-set-key "\C-x\C-y" 'copy-region-as-kill)
    (global-set-key "\C-o" 'dabbrev-expand)
    (global-set-key "\C-c\C-c" 'comment-region)
    (global-set-key "\C-c\C-v" 'compile)
    (setq-default c-basic-offset 2)
;;;
;;; Misc. configuration options.
;;;

;;    (global-set-key "\C-o" 'insert-o-umlaut)
;;    (global-set-key "\C-a" 'insert-a-umlaut)
;;    (global-set-key "\C-u" 'insert-u-umlaut)

    (global-set-key "\C-g" 'goto-line)
    (global-set-key "\C-v" 'set-mark-command)
    (global-set-key "\C-q" 'query-replace)
;
    (setq auto-save-timeout 3000)
    
    (setq inhibit-startup-message t)

;;    (require 'psvn)
    ;;
    ;; Set the search paths of Emacs.
    ;;
    (setq load-path (cons (expand-file-name 
			   "~/.emacs_modes") load-path))
    (setq load-path (cons (expand-file-name 
			   "/usr/share/emacs/25.2/") load-path))  

    (setq load-path (cons (expand-file-name 
			   "~/bin/emacs") load-path))  
    ;;
    ;; Load some additional modes
    ;;
    ;;(require 'csh-mode2)
    ;;(autoload 'csh-mode2 "csh-mode2" "Mode for editing csh scripts." t)
    ;;(require 'sh-mode)
    ;;(autoload 'sh-mode "sh-mode" "Mode for editing sh scripts." t)
    ;;
    ;; Set the default mode to text-mode break the line after 80 characters.
    ;;
    (setq major-mode 'indented-text-mode)
    ;;(setq major-mode 'text-mode)
;;    (setq fill-column 80)
;    (setq text-mode-hook 'turn-on-auto-fill)
    ;;
    ;; Configure Emacs for european use.
    ;;
;;    (standard-display-european 1)
;;    (setq european-calendar-style t)
    ;;
    ;; Show the time and the line number at the bottom bar.
    ;;
    (setq display-time-24hr-format t)
    (display-time)
    (setq line-number-mode t)
    ;;
    ;; Ispell keybindings.
    ;;
    (setq require-final-newline t);; Silently ensure newline at end of file
    ;;(setq require-final-newline 'ask) ;; Make Emacs ask about missing newline

    ;; Automatic (un)compression on loading/saving files (gzip(1) & compress(1))
    ;; I should look at crypt++ some day... (not yet included with Emacs).
    (if (fboundp 'auto-compression-mode) ; Emacs 19.30+
	(auto-compression-mode 1)
      (require 'jka-compr))

    ;; Garbage collection happens after at most this number of bytes of cons'ing.
    (setq gc-cons-threshold 800000);; Default in 19.3[01]; in 19.27 it's only 100k.

    ;; Automatically resize minibuffer as necessary
    ;;(resize-minibuffer-mode 1)

    ;; Color theme
    (require 'color-theme)
    (color-theme-initialize)
    (setq color-theme-is-global t)
    ;(color-theme-goldenrod)
    (color-theme-charcoal-black)
    (color-theme-jsc-dark)
    ;; Curser shape
    (setq x-pointer-shape 68)
    ;;(set-mouse-color "BLUE")
    (set-face-attribute 'default nil :height 100)
    ;;(set-default-font "-adobe-courier-medium-r-normal--14-100-100-100-m-90-iso8859-1")


    ;;disable backup files
    (setq make-backup-files nil)
    (setq use-file-dialog nil)

;;; end Misc. configuration options
;;;


;;;
;;; AUC TeX and (La)TeX 
;;;

    ;;(require 'tex-site)
    ;;(setq TeX-style-global "/afs/uni-c.dk/export/common/lib/tex/inputs/")
    (setq TeX-parse-self t);; Enable parse on load.
    (setq TeX-auto-save nil);; Enable parse on save.
    (setq TeX-master nil);; Query for master file.
    (setq LaTeX-version "latex2e")
    (setq LaTeX-item-indent  -1);; at least one space of indentation
    ;;(setq LaTeX-figure-label "fig:")
    ;;(setq LaTeX-table-label  "tab:")
    (setq LaTeX-float        "h")
    ;;
    ;; Highlight AMSLaTeX and Babel commands (used by hilit-LaTeX).
    ;;
    (setq hilit-AmSLaTeX-commands t)
    ;;(setq hilit-multilingual-strings t)
    ;;
    ;; Load the ISO-TeX package
    ;;
    (autoload 'iso-tex-minor-mode
      "iso-tex"
      "Translate TeX to ISO 8859/1 while visiting a file"
      t)
    ;;
    ;; Things to run when (La)TeX-mode is started.
    ;;
    (setq TeX-mode-hook
	  (function (lambda () 
		      (interactive)
;;;		      (setq TeX-command-default "LaTeX2e")
		      (setq TeX-command-default "LaTeX")
		      (setq TeX-dvi-view-command "/usr/local/bin/xdvi") ; Default: undefined
		      (setq TeX-file-recurse "~/tex/") ; Why does this not work?
		      (iso-tex-minor-mode 1) ; Enable ISO-TeX minor mode
		      (local-set-key [return] 'hilit-return)
		      )))

;;;
;;; end AUC TeX and (LA)TeX 
;;;


;;;
;;; perl-mode
;;;

    ;;
    ;; Load files with extension .perl into Perl mode
    ;;
    (setq auto-mode-alist (cons '("\\.perl\$" . perl-mode) auto-mode-alist))

;;;
;;; end perl-mode
;;;

    
;;;
;;; fortran-mode
;;;

    ;;
    ;; Load files with extension .car, .for, .f and .F into Fortran mode
    ;;
    (setq auto-mode-alist (cons '("\\.car\$"   . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.for\$"   . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.f\$"     . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.inc\$"     . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.ftn\$"     . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("\\.F\$"     . fortran-mode) auto-mode-alist))
    (setq auto-mode-alist (cons '("cmedt.edt*" . fortran-mode) auto-mode-alist)); CMZ
;;    (setq fill-column 80)

;;;;;;;;;;
;;;;;From .emacs.nbi
;;;;;;;;;;
;    (defun fortran-reindent-then-newline-and-indent ()
;      "Does what help for fortran-indent-new-line describes,
; without any restrictions on contents of current line."
;      (interactive)
;      (if (equal "^\\+") 
;	  nil
;	fortran-indent-line)      does not indet pacthy stuff
;      (hilit-return)
;      );
;
;    (add-hook 'fortran-mode-hook
;	      '(lambda ()
;		 (local-set-key [return] 'fortran-reindent-then-newline-and-indent)
;		 (setq fortran-continuation-string ">"
;		       comment-line-start "*" ; Default "c", for auto-made comments
;		       comment-line-start-skip "^[Cc*+]\\(\\([^         \n]\\)\\2\\2*\\)?[      ]*\\|^#.*"
;		       fortran-do-indent 2 ; Indentation in DO loops  (default 3)
;		       fortran-if-indent 2 ; Indentation in IF blocks (default 3)
;		       fortran-comment-region "C$MU$" ; Default "c$$$", when C-c ;
;		       fortran-comment-indent-style nil ; nil = don't touch comments
;		       fortran-blink-matching-if 1) ; Show if/endif match when TAB pressed
;		 (fortran-auto-fill-mode 1) ; Autosplit long lines when TAB/RET/SPC
;		 )) ; Fold the file
;;;
;;; end fortran-mode
;;;

;;;
;;; c-mode
;;;

    ;;
    ;; Load files with extension .cc, .h, and . into c mode
    ;;

    (setq auto-mode-alist (cons '("\\.cc\$"   . c++-mode) auto-mode-alist)) 
    (setq auto-mode-alist (cons '("\\.h\$"   . c++-mode) auto-mode-alist)) 
    (setq auto-mode-alist (cons '("\\.C\$"   . c++-mode) auto-mode-alist)) 

    ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Makefile mode stuff
    ;;   From .emacs.nbi
    ;;(add-hook 'makefile-mode-hook
    ;;	  '(lambda () (...)))
    ;;
    ;; These two are already in 19.30+.  `add-to-list' avoids doubling them.
    ;;(setq auto-mode-alist '("[Mm]akefile\\(.in\\)?\\'" . makefile-mode))
    ;;(setq auto-mode-alist '("\\.mk\\'" . makefile-mode))

;;;
;;; end c-mode
;;;

;;;
    (setq emacs-lisp-hook 'turn-on-auto-fill)

;;;
;;; web-mode
;;;

    (autoload 'web-mode "web-mode.el"
      "WEB major mode." t)
    ;;
    ;; Load files with extension .html into WEB mode
    ;;
    (setq auto-mode-alist (cons '("\\.html$" . web-mode)
				auto-mode-alist))

;;;
;;; end web-mode
;;;

;;;
;;; cython-mode
;;;

    (autoload 'cython-mode "cython-mode.el"
      "CYTHON major mode." t)
    ;;
    ;; Load files with extension .pyx into CYTHON mode
    ;;
    (setq auto-mode-alist (cons '("\\.pyx$" . cython-mode)
				auto-mode-alist))

;;;
;;; end cython-mode
;;;

    ;; =======================================================
    ;; NOTE on using emacs in a VT* window: C-s and C-q may still result
    ;; in terminal flow control. I don't know how to change this, but the
    ;; command M-x enable-flow-control binds the corresponding emacs
    ;; commands to keys C-\ and C-^ respectively:
    ;; =======================================================

    (if (not window-system)
	(enable-flow-control))

;;;
;;; Windows configuration.
;;;

    ;; Function which Turns on auto-coloration at <CR>\n
    ;;
    (defun hilit-return ()
      "Hilit a line when the return key is hit!!!!"
      (interactive)
      (cond
       ( (equal mode-name "Text")
	 (newline) 
	 )
       ( (equal mode-name "Fortran")
	 (setq current-point (point))
	 (beginning-of-line 0)
	 (setq b (point))
	 (goto-char current-point)
	 (fortran-indent-new-line)
	 (hilit-rehighlight-region b (point)) 
	 )
       ( t ;; TRUE
	 (setq current-point (point))
	 (beginning-of-line 0)
	 (setq b (point))
	 (goto-char current-point)
	 (newline)
	 (hilit-rehighlight-region b (point)) 
	 ) 
       )
      )

;
;;; End of progn
;
    ) 
;
;;; End of if
;
  )















(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


     (setq lpr-switches '("-Php5si4d"))


;; zone out after 60 seconds
;;(require 'zone)
;;(setq zone-idle 120)
;;(setq zone-program '(zone-pgm-drip zone-pgm-drip-fretfully))
;;(zone-when-idle zone-program)

;; Load packages
;; for markdown language support
;; https://jblevins.org/projects/markdown-mode/
;; Need to install external processor pandoc
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
  "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

