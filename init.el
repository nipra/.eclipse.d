(setq mac? (eq system-type 'darwin))
(setq nipra-home (getenv "HOME"))

(when mac? ;; mac specific settings
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta))

(require 'cl)

;; -----------------------------
;; General Display Customisation
;; -----------------------------

(setq inhibit-startup-message t)
(setq font-lock-maximum-decoration t)
(setq visible-bell t)
(setq require-final-newline t)
(setq resize-minibuffer-frame t)
(setq column-number-mode t)
(setq line-number-mode t)
(setq-default transient-mark-mode t)
(setq next-line-add-newlines nil)
(setq blink-matching-paren t)
(setq blink-matching-delay .25)
(setq size-indication-mode t)
(global-font-lock-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(show-paren-mode t)
(set-scroll-bar-mode 'nil)
(savehist-mode 1)
;; (setq cursor-type "box")
;; (set-cursor-color "red")
(setq frame-title-format "%b")
(setq icon-title-format  "%b")
(setq query-replace-highlight t)
(setq search-highlight t)
(setq mouse-avoidance-mode 'banish)
(if mac?
    (set-frame-font "DejaVu Sans Mono-14")
  (set-frame-font "DejaVu Sans Mono-11"))

;; X11 Copy & Paste to/from Emacs
(setq x-select-enable-clipboard t)

;; 'y' for 'yes', 'n' for 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; ;; ----------------------
;; ;; Final newline handling
;; ;; ----------------------
(setq require-final-newline t)
(setq next-line-extends-end-of-buffer nil)
(setq next-line-add-newlines nil)

;; ;; ;; -------------------
;; ;; ;; Everything in UTF-8
;; ;; ;; -------------------
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-default-coding-systems             'utf-8)
(setq file-name-coding-system           'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq coding-system-for-write           'utf-8)
(set-keyboard-coding-system             'utf-8)
(set-terminal-coding-system             'utf-8)
(set-clipboard-coding-system            'utf-8)
(set-selection-coding-system            'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; (add-to-list 'auto-coding-alist '("." . utf-8))

;; ;; ;; ---------
;; ;; ;; TAB Setup
;; ;; ;; ---------
;; (setq-default tab-width 8
;; 	      standard-indent 4
;; 	      indent-tabs-mode nil)

(setq-default tab-width 4
              indent-tabs-mode nil)

;; http://www.emacswiki.org/emacs/TransparentEmacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(transparency 100)

;;; If the value of the variable confirm-kill-emacs is non-nil, C-x C-c assumes
;;; that its value is a predicate function, and calls that function.
(setq confirm-kill-emacs 'y-or-n-p)

;; http://stable.melpa.org/#/getting-started
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Color themes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'custom-theme-load-path (concat nipra-home "/.emacs.d/color-themes"))

(unless (package-installed-p 'solarized-theme)
  (package-install 'solarized-theme))
(require 'solarized)

(unless (package-installed-p 'color-theme-sanityinc-tomorrow)
  (package-install 'color-theme-sanityinc-tomorrow))
(require 'color-theme-sanityinc-tomorrow)

(unless (package-installed-p 'monokai-theme)
  (package-install 'monokai-theme))
(load-theme 'monokai t)

;; ;; ;; -----------------
;; ;; ;; Insert time stamp
;; ;; ;; -----------------
(defun insert-date ()
  "Insert current date and time."
  (interactive "*")
  (insert (current-time-string)))

(add-hook 'before-save-hook 'time-stamp)


;; ;; ;; ----------------------------------------
;; ;; ;; kill current buffer without confirmation
;; ;; ;; ----------------------------------------
(global-set-key "\C-xk" 'kill-current-buffer)
(defun kill-current-buffer ()
  "Kill the current buffer, without confirmation."
  (interactive)
  (kill-buffer (current-buffer)))


;; ;; ;; ---------
;; ;; ;; Automodes
;; ;; ;; ---------
(setq auto-mode-alist (append '(("\\.conf$" . conf-mode)
                                ("\\.sh$" . shell-script-mode)
                                ("\\.txt$" . text-mode)
                                ("\\.lisp" . lisp-mode)
                                ("\\.textile\\'" . textile-mode)
                                ("\\.rnc$" . rnc-mode))
                              auto-mode-alist))


;; ;; ;; ------------
;; ;; ;; General Info
;; ;; ;; ------------
(setq user-mail-address "prabhakar.nikhil@gmail.com")
(setq user-full-name "Nikhil Prabhakar")

;;; Snippet for full screen toggling
(defun toggle-fullscreen () 
  (interactive) 
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen) 
                                           nil 
                                         'fullboth)))
(global-set-key [(meta return)] 'toggle-fullscreen) 

(when (executable-find "wmctrl")        ; apt-get install wmctrl
  (defun full-screen-toggle ()
    (interactive)
    (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))
  (global-set-key (kbd "<f11>")  'full-screen-toggle))


;;; Magit
(unless (package-installed-p 'magit)
  (package-install 'magit))
(require 'magit)
(setq magit-auto-revert-mode nil)
;;; https://raw.githubusercontent.com/magit/magit/next/Documentation/RelNotes/1.4.0.txt
(setq magit-last-seen-setup-instructions "1.4.0")

;; Set the name of the host and current path/file in title bar:
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; http://web.archive.org/web/20061025212623/http://www.cs.utexas.edu/users/hllu/EmacsSmoothScrolling.html
(setq truncate-lines t)

(defun point-of-beginning-of-bottom-line ()
  (save-excursion
    (move-to-window-line -1)
    (point)))

(defun point-of-beginning-of-line ()
  (save-excursion
    (beginning-of-line)
    (point)))

(defun next-one-line () (interactive)
       (if (= (point-of-beginning-of-bottom-line) (point-of-beginning-of-line))
           (progn (scroll-up 1)
                  (next-line 1))
         (next-line 1)))

(defun point-of-beginning-of-top-line ()
  (save-excursion
    (move-to-window-line 0)
    (point)))

(defun previous-one-line () (interactive)
       (if (= (point-of-beginning-of-top-line) (point-of-beginning-of-line))
           (progn (scroll-down 1)
                  (previous-line 1))
         (previous-line 1)))

(global-set-key (kbd "C-n") 'next-one-line)
(global-set-key (kbd "C-p") 'previous-one-line)


(defun rename-buffer* ()
  (interactive)
  (let* ((buffer-name (buffer-name))
         (file-name (buffer-file-name))
         (directory (file-name-directory file-name))
         (new-buffer-name (format "%s %s" buffer-name directory)))
    (rename-buffer new-buffer-name)))

;; starter-kit-defuns.el
(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;; starter-kit-bindings.el

;; Turn on the menu bar for exploring new modes
(global-set-key (kbd "C-<f10>") 'menu-bar-mode)
;; Help should search more than just commands
(global-set-key (kbd "C-h a") 'apropos)


;; starter-kit-misc.el
;; ido-mode is like magic pixie dust!
(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10))

;; Cosmetics
(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green3")
     (set-face-foreground 'magit-diff-del "red3")))

;;; someday might want to rotate windows if more than 2 of them
;;; http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2))
         (message "You need exactly 2 windows to do this."))
        
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.emacswiki.org/emacs/TransposeWindows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; When working with multiple windows it can be annoying if they get out of order. With this function it’s easy
;;; to fix that. This is a slight rewrite of an original written by ThomasBellman.

(defun transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))


(define-key ctl-x-4-map (kbd "t") 'transpose-windows)

;;; And because diversity is a good thing, here is Stephen Gildea’s version of the same:
(defun swap-window-positions ()         ; Stephen Gildea
  "*Swap the positions of this window and the next one."
  (interactive)
  (let ((other-window (next-window (selected-window) 'no-minibuf)))
    (let ((other-window-buffer (window-buffer other-window))
          (other-window-hscroll (window-hscroll other-window))
          (other-window-point (window-point other-window))
          (other-window-start (window-start other-window)))
      (set-window-buffer other-window (current-buffer))
      (set-window-hscroll other-window (window-hscroll (selected-window)))
      (set-window-point other-window (point))
      (set-window-start other-window (window-start (selected-window)))
      (set-window-buffer (selected-window) other-window-buffer)
      (set-window-hscroll (selected-window) other-window-hscroll)
      (set-window-point (selected-window) other-window-point)
      (set-window-start (selected-window) other-window-start))
    (select-window other-window)))


(setq swapping-buffer nil)
(setq swapping-window nil)

;;; ChrisWebber provides a similar function, but this one allows you to select which two you want to swap
;;; (perhaps if you have 3 or more windows open)

(defun swap-buffers-in-windows ()
  "Swap buffers between two windows"
  (interactive)
  (if (and swapping-window
           swapping-buffer)
      (let ((this-buffer (current-buffer))
            (this-window (selected-window)))
        (if (and (window-live-p swapping-window)
                 (buffer-live-p swapping-buffer))
            (progn (switch-to-buffer swapping-buffer)
                   (select-window swapping-window)
                   (switch-to-buffer this-buffer)
                   (select-window this-window)
                   (message "Swapped buffers."))
          (message "Old buffer/window killed.  Aborting."))
        (setq swapping-buffer nil)
        (setq swapping-window nil))
    (progn
      (setq swapping-buffer (current-buffer))
      (setq swapping-window (selected-window))
      (message "Buffer and window marked for swapping."))))

(global-set-key (kbd "C-c p") 'swap-buffers-in-windows)

;;; Yet another window-altering function by Robert Bost slightly based on Steve Yegge’s swap-windows. This one
;;; will handle > 1 windows.
(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows) 1)) (message "You can't rotate a sinlge window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))


;;; http://www.emacswiki.org/emacs/RevertBuffer
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files.") )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global key bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-set-key (kbd "C-x M-k") 'kill-some-buffers)
                                        ;(global-set-key (kbd "C-c C-l") 'move-to-window-line)
(global-set-key (kbd "<f2>") 'select-frame-by-name)
(global-set-key (kbd "<f3>") 'set-frame-name)
(global-set-key (kbd "C-x M-r") 'rename-buffer)
(global-set-key (kbd "C-x M-b") 'rename-buffer*)
(global-set-key (kbd "<f6>") 'advertised-undo)
                                        ;(global-set-key "\C-xs" 'kill-some-buffers)
(global-set-key (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "C-M-y") 'scroll-other-down-full-screen)
(global-set-key (kbd "C-M-z") 'scroll-other-up-1)
(global-set-key (kbd "C-M-c") 'scroll-other-down-1)

(global-set-key (kbd "C-x M-s") 'swap-windows)
(global-set-key (kbd  "C-x O") 'other-window-minus)
(global-set-key (kbd  "C-x o") 'other-window)

;; http://www.emacswiki.org/emacs/EmacsNiftyTricks
;; Use cursor-chg.el to ChangingCursorDynamically. If you sometimes find
;; yourself inadvertently overwriting some text because you are in overwrite
;; mode but you didn’t expect so, this might prove useful. It changes cursor
;; color and shape to indicate read-only and overwrite modes. And here is
;; another way:

(setq hcz-set-cursor-color-color "")
(setq hcz-set-cursor-color-buffer "")
(defun hcz-set-cursor-color-according-to-mode ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
         (if buffer-read-only
             "green"
           (if overwrite-mode
               "blue"
             "red"))))
    (unless (and
             (string= color hcz-set-cursor-color-color)
             (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))
(add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)

;; Keyboard Macros Tricks
;; http://www.emacswiki.org/emacs/KeyboardMacrosTricks
(defun save-macro (name)                  
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "SName of the macro :")  ; ask for the name of the macro    
  (kmacro-name-last-macro name)         ; use this name for the macro    
  (find-file "~/.emacs.d/init.el")                ; open the .emacs file 
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro 
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer

(setq black-star "★")
(setq white-star "☆")

(defun star-rating (movie n comment)
  (interactive "MMovie: \nnRating: \nMComment: ")
  (let ((n-white-stars (make-string (- 10 n) ?☆))
        (n-black-stars (make-string n ?★)))
    (insert movie ": " (concat n-black-stars n-white-stars) ". " comment ".")))

;;; Via #emacs
(defun lnap ()
  (interactive)
  (message "%s" (line-number-at-pos)))

;;; https://github.com/auto-complete/auto-complete
(unless (package-installed-p 'auto-complete)
  (package-install 'auto-complete))

;;; http://trey-jackson.blogspot.com/2008/01/emacs-tip-11-uniquify.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
;; (setq uniquify-after-kill-buffer-p t)
                                        ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; <<START>>
;; Eclim
;; https://github.com/senny/emacs-eclim
;; This project brings some of the great eclipse features to emacs
;; developers. It is based on the eclim project, which provides
;; eclipse features for vim.
(unless (package-installed-p 'emacs-eclim)
  (package-install 'emacs-eclim))

(require 'eclim)
(global-eclim-mode)

(if mac?
   (setq eclim-executable "/Applications/eclipse/eclim")
  (setq eclim-executable (concat nipra-home "/.eclipse/org.eclipse.platform_4.4.1_1873933799_linux_gtk_x86_64/eclim")))

(setq eclimd-executable nil)
(setq eclim-auto-save nil)              ; Turn off auto save

;; Displaying compilation error messages in the echo area
(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

;; add the emacs-eclim source
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)

;; Emacs-eclim can integrate with company-mode to provide pop-up
;; dialogs for auto-completion.
(unless (package-installed-p 'company)
  (package-install 'company))
(require 'company)
(global-company-mode t)

(require 'company-emacs-eclim)
(company-emacs-eclim-setup)

;; Keymap
;; C-c C-e m r => eclim-maven-run (Goal: install)
(define-key eclim-mode-map (kbd "C-c C-e r") 'eclim-run-class)

;; <<END>>

;; YAML
(unless (package-installed-p 'yaml-mode)
  (package-install 'yaml-mode))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;; SQL
(unless (package-installed-p 'sql-indent)
  (package-install 'sql-indent))
;; (require 'sql-indent)
(eval-after-load "sql"
  (load-library "sql-indent"))

;;; http://www.emacswiki.org/emacs/SmoothScrolling
;;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; http://www.emacswiki.org/emacs/TransparentEmacs
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(85 50))
(add-to-list 'default-frame-alist '(alpha 85 50))

;; You can use the following snippet after you’ve set the alpha as above to assign a toggle to “C-c t”:

(eval-when-compile (require 'cl))
(defun toggle-transparency ()
  (interactive)
  (if (/=
       (cadr (frame-parameter nil 'alpha))
       100)
      (set-frame-parameter nil 'alpha '(100 100))
    (set-frame-parameter nil 'alpha '(85 50))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;; A general transparency function:
;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

;; http://emacs-fu.blogspot.in/2009/02/transparent-emacs.html
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
         (oldalpha (if alpha-or-nil alpha-or-nil 100))
         (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

;; C-8 will increase opacity (== decrease transparency)
;; C-9 will decrease opacity (== increase transparency
;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; https://github.com/clojure-emacs/cider/wiki/Installation
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)
(unless (package-installed-p 'cider)
  (package-install 'cider))

(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-buffer-name-show-port t)

(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
(add-hook 'cider-repl-mode-hook #'paredit-mode)

;; Paredit mode
(add-to-list 'package-pinned-packages '(paredit . "melpa-stable") t)
(unless (package-installed-p 'paredit)
  (package-install 'paredit))

(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)

(eval-after-load 'paredit
  '(progn (define-key paredit-mode-map (kbd "(")       'paredit-open-parenthesis)
          (define-key paredit-mode-map (kbd ")")       'paredit-close-parenthesis)
          (define-key paredit-mode-map (kbd "{")       'paredit-open-curly)
          (define-key paredit-mode-map (kbd "}")       'paredit-close-curly)
          (define-key paredit-mode-map (kbd "[")       'paredit-open-square)
          (define-key paredit-mode-map (kbd "]")       'paredit-close-square)
          (define-key paredit-mode-map (kbd "M-(")     (lambda () (interactive) (insert "(")))
          (define-key paredit-mode-map (kbd "M-)")     (lambda () (interactive) (insert ")")))
          (define-key paredit-mode-map (kbd "M-j")     'paredit-newline)
          (define-key paredit-mode-map (kbd "RET")     nil)
          (define-key paredit-mode-map (kbd "C-t")     'transpose-sexps)
          (define-key paredit-mode-map (kbd "C-M-t")   'transpose-chars)
          (define-key paredit-mode-map (kbd "C-b")     'backward-sexp)
          (define-key paredit-mode-map (kbd "C-M-b")   'backward-char)
          (define-key paredit-mode-map (kbd "C-f")     'forward-sexp)
          (define-key paredit-mode-map (kbd "C-M-f")   'forward-char)
          (define-key paredit-mode-map (kbd "C-c b")   'backward-kill-sexp)
          (define-key paredit-mode-map (kbd "C-c C-j") 'paredit-join-sexps)
          ;; (define-key paredit-mode-map (kbd "C-i") 'slime-indent-and-complete-symbol)
          (define-key paredit-mode-map (kbd "C-c C-1") 'paredit-backward-barf-sexp)
          (define-key paredit-mode-map (kbd "C-c C-2") 'paredit-forward-barf-sexp)
          (define-key paredit-mode-map (kbd "C-c C-3") 'paredit-backward-slurp-sexp)
          (define-key paredit-mode-map (kbd "C-c C-4") 'paredit-forward-slurp-sexp)
          (define-key paredit-mode-map (kbd "C-c x") 'paredit-backward-slurp-sexp)
          (define-key paredit-mode-map (kbd "C-c z") 'paredit-forward-slurp-sexp)
          (define-key paredit-mode-map (kbd "C-c c") 'paredit-splice-sexp-killing-backward)
          (define-key paredit-mode-map (kbd "C-c v") 'paredit-splice-sexp-killing-forward)))

;; Pig
(unless (package-installed-p 'pig-mode)
  (package-install 'pig-mode))

(require 'pig-mode)

