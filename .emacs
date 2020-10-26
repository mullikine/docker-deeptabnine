;; enable mouse
(menu-bar-mode -1) "M-x menu-bar-mode"
(tool-bar-mode -1) "M-x tool-bar-mode"
(toggle-scroll-bar -1)

(mouse-avoidance-mode 'exile)

(defun my-terminal-config (&optional frame)
  "Establish settings for the current terminal."
  (if (not frame) ;; The initial call.
      (xterm-mouse-mode 1)
    ;; Otherwise called via after-make-frame-functions.
    (if xterm-mouse-mode
        ;; Re-initialise the mode in case of a new terminal.
        (xterm-mouse-mode 1))))
;; Evaluate both now (for non-daemon emacs) and upon frame creation
;; (for new terminals via emacsclient).
(my-terminal-config)
(add-hook 'after-make-frame-functions 'my-terminal-config)



(add-hook
 'after-init-hook
 (lambda ()
   (require 'helm-config)
   (helm-mode 1)))


(require 'cl-macs)

;; This doesn't work for the terminal version though
;; after copy Ctrl+c in Linux X11, you can paste by `yank' in emacs
(setq x-select-enable-clipboard t)

;; after mouse selection in X11, you can paste by `yank' in emacs
(setq x-select-enable-primary t)

;; this isn't working
;; I just want the clipboard to work
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard t)

(ignore-errors (xclip-mode 1))

(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)


;; This appears to do a much better job that simpleclip

(defun xsel-cut-function (text &optional push)
  (with-temp-buffer
    (insert text)
    (call-process-region (point-min) (point-max) "xclip" nil 0 nil "-i")))

(defun xsel-paste-function ()

  (let ((xsel-output (shell-command-to-string "xsel -o")))
    (unless (string= (car kill-ring) xsel-output)
      xsel-output)))

(setq interprogram-cut-function 'xsel-cut-function)
(setq interprogram-paste-function 'xsel-paste-function)



(provide 'my-clipboard)
(menu-bar-mode -1)

(custom-set-faces
 ;; other faces
 '(magit-diff-added ((((type tty)) (:foreground "green"))))
 '(magit-diff-added-highlight ((((type tty)) (:foreground "LimeGreen"))))
 '(magit-diff-context-highlight ((((type tty)) (:foreground "default"))))
 '(magit-diff-file-heading ((((type tty)) nil)))
 '(magit-diff-removed ((((type tty)) (:foreground "red"))))
 '(magit-diff-removed-highlight ((((type tty)) (:foreground "IndianRed"))))
 '(magit-section-highlight ((((type tty)) nil))))

(let ((gd (locate-dominating-file default-directory ".git")))
  (if gd
      (cd gd)))

(load "/my-shackle.el")

(load "/theme.el")
(enable-theme (intern "magonyx"))

(defun variable-p (s)
  (and (not (eq s nil))
       (boundp s)))

(defvar termframe nil)

(defun set-termframe (frame)
  "Frame is obtained from the method which calls this function"
  ;; (defvar-local termframe (selected-frame))
  ;; (defvar termframe (selected-frame))
  ;; (makunbound 'termframe)
  ;; (message (concat "setting " (str frame) " in " (str newtermbuf)))
  (message (concat "setting " (str frame)))
  (with-current-buffer "*scratch*"
    (setq termframe frame))
  ;; (message (concat "getting " (str termframe)))
  ;; (if (variable-p 'newtermbuf)
  ;;     ;; Sometimes newtermbuf is old
  ;;     (ignore-errors (with-current-buffer newtermbuf
  ;;                      (defset termframe frame)
  ;;                      )))
  ;; (remove-hook 'after-make-frame-functions 'set-termframe)
  )

;; this makes it look like this is a regular hook list, which it isn't
;; The thing which calls the functions in =after-make-frame-functions= also supplies
;; the frame as a parameter
(add-hook 'after-make-frame-functions 'set-termframe)

(defmacro tryelse (thing &optional otherwise)
  "Try to run a thing. Run something else if it fails."
  `(condition-case nil ,thing (error ,otherwise)))
(defun try-cascade (list-of-alternatives)
  "Try to run a thing. Run something else if it fails."
  ;; (list2str list-of-alternatives)

  (catch 'bbb
    (dolist (p list-of-alternatives)
      ;; (message "%s" (list2str p))
      (let ((result nil))
        (tryelse
         (progn
           (setq result (eval p))
           (throw 'bbb result))
         result)))))
(defmacro try-cascade-sugar (&rest list-of-alternatives)
       "Try to run a thing. Run something else if it fails."
       `(try-cascade '(,@list-of-alternatives)))
(defalias 'try 'try-cascade-sugar)


(defun close-local-termframe ()
  ;; (interactive)
  (if (and (variable-p 'termframe-local)
           termframe-local)
      (try (delete-frame termframe-local t)
           (kill-emacs))))

;; I can't do this. I must link to =q=
;; (add-hook 'kill-buffer-hook 'close-local-termframe t)

(defun kill-emacs-on-scratch ()
  (interactive)
  (if (string-equal (buffer-name) "*scratch*")
      (kill-emacs)))
(add-hook 'window-configuration-change-hook 'kill-emacs-on-scratch)


;; (use-package magithub
;;   :after magit
;;   :config
;;   (magithub-feature-autoinject t)
;;   (setq magithub-clone-default-directory default-directory))


;; (progn  (magit-status) (delete-other-windows))


(setq termframe (selected-frame))


;; this fixes magithub and ghub+
;; But without the issue name, clicking on issues is broken. So this must be fixed
(defun ghub--host-around-advice (proc &rest args)
  (if (not args)
      (setq args '(github)))
  (let ((res (apply proc args)))
    res))
;; (advice-add 'ghub--host :around #'ghub--host-around-advice)
;; (advice-remove 'ghub--host #'ghub--host-around-advice)

(magithub-feature-autoinject t)
(setq magithub-clone-default-directory "~/github")

(setq-default magit-log-arguments '("-n20" "--graph" "--stat" "--decorate"))
(setq-default magit-commit-arguments (quote ("--verbose")))
(custom-set-variables
 '(magit-log-arguments (quote ("--graph" "--decorate" "--stat" "-n20")))
 ;; '(magit-log-arguments (quote ("--graph" "--decorate" "--patch" "--stat" "-n20")))
 )

(setq-default magit-diff-refine-hunk 'all)
(setq-default magit-diff-highlight-trailing t)
(setq-default magit-diff-paint-whitespace t)
(setq-default magit-diff-highlight-hunk-body t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-popup-argument ((t (:inverse-video t)))))

;; I'm not sure where this was set, but this is what it needs to be set to
(setq magit-display-buffer-function
      (lambda
        (buffer)
        (if magit-display-buffer-noselect
            (magit-display-buffer-traditional buffer)
          (delete-other-windows)
          (set-window-dedicated-p nil nil)
          (set-window-buffer nil buffer)
          (get-buffer-window buffer))))


(defun parse-iso8601-time-string-around-advice (proc &rest args)
  (if (string-match-p "Z\\+" (car args))
      (setq args (list (replace-regexp-in-string "Z\\+.*" "" (car args)))))
  (let ((res (apply proc args)))
    res))
(advice-add 'parse-iso8601-time-string :around #'parse-iso8601-time-string-around-advice)


;; (defun magithub-issue-repo-around-advice (proc &rest args)
;;   (ignore-errors
;;     (let ((res (apply proc args)))
;;       res)))
;; (advice-add 'magithub-issue-repo :around #'magithub-issue-repo-around-advice)


;; This isn't removing backtrace truncation
(setq eval-expression-print-level nil)
(setq eval-expression-print-length nil)
(setq print-level nil)
(setq print-length nil)

;; TODO Make a fz function

(defun lsp-get-server-for-install (name)
  (interactive (list (fz (lsp-list-all-servers))))
  (cdr (car (-filter (lambda (sv) (string-equal (car sv) name))
                     (--map (cons (funcall
                                   (-compose #'symbol-name #'lsp--client-server-id) it) it)
                            (or (->> lsp-clients
                                     (ht-values)
                                     (-filter (-andfn
                                               (-orfn (-not #'lsp--server-binary-present?)
                                                      (-const t))
                                               (-not #'lsp--client-download-in-progress?)
                                               #'lsp--client-download-server-fn)))
                                (user-error "There are no servers with automatic installation")))))))

(defun lsp-install-server-by-name (name)
  (interactive (list (fz (lsp-list-all-servers))))
  (lsp--install-server-internal (lsp-get-server-for-install name)))

;; (lsp-install-server-by-name "vimls")