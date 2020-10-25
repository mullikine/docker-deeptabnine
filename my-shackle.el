(require 'shackle)

;; shackle gives you the means to put an end to popped up buffers not
;; behaving the way you'd like them to. By setting up simple rules you
;; can for instance make Emacs always select help buffers for you or
;; make everything reuse your currently selected window.

;; Shackle
;; https://github.com/wasamasa/shackle

;; I think shackle must use display-buffer-alist
;; It hooks into it.
;; [[https://www.youtube.com/watch?v=rjOhJMbA-q0][Emacs: window rules and parameters (`display-buffer-alist' and extras) - YouTube]]

;; split-window-sensibly
(defun my-shackle-sensible-alignment (&optional window)
  (interactive)
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window)
             'below)
        (and (window-splittable-p window t)
             'right)
        (and
         ;; If WINDOW is the only usable window on its frame (it is
         ;; the only one or, not being the only one, all the other
         ;; ones are dedicated) and is not the minibuffer window, try
         ;; to split it vertically disregarding the value of
         ;; `split-height-threshold'.
         (let ((frame (window-frame window)))
           (or
            (eq window (frame-root-window frame))
            (catch 'done
              (walk-window-tree (lambda (w)
                                  (unless (or (eq w window)
                                              (window-dedicated-p w))
                                    (throw 'done nil)))
                                frame)
              t)))
         (not (window-minibuffer-p window))
         (let ((split-height-threshold 0))
           (when (window-splittable-p window)
             'below))))))


(setq shackle-lighter "")
(setq shackle-select-reused-windows nil) ; default nil
(setq shackle-default-alignment 'below)  ; default below
;; (setq shackle-default-alignment 'same) ; default below
(setq shackle-default-size 0.4)     ; default 0.5

(setq shackle-rules
      '(
        (magit-process-mode :select nil :inhibit-window-quit t :same nil :align my-shackle-sensible-alignment :size 0.5)
        ("\\*magit-process:" :regexp t :select nil :inhibit-window-quit t :same nil :align my-shackle-sensible-alignment :size 0.5)
        ("*fs-mode*" :ignore nil :select t :same t)
        ("*flycheck-error-list-mode*" :ignore nil :select t :same t)
        ("*Bluetooth device info*" :ignore nil :select t :same t)
        ("*kubernetes logs*" :ignore nil :select t :same t)
        (hackernews-mode :ignore nil :select t :same t)
        ("*Occur*" :ignore nil :select t :same t)
        (inf-ruby-mode :ignore nil :select t :same t)
        (inf-messer-mode :ignore nil :select t :same t)
        ("*magit-prettier-graph*" :ignore nil :select t :same t)
        ("*xbm life*" :ignore nil :select t :same t)
        ("\\*docker.*\\*" :regexp t :ignore nil :select t :same t)
        ("\\*daemons .*\\*" :regexp t :ignore nil :select t :same t)
        ("\\*define-it: .*\\*" :regexp t :ignore nil :select t :same t)
        ("\\*kubel .*\\*" :regexp t :ignore nil :select t :same t)
        ("\\*.*\\*\\.csv" :regexp t :ignore nil :select t :same t)
        ("magit.*\\.csv" :regexp t :ignore nil :select t :same t)
        ("*Flycheck checkers*" :ignore nil :select t :same t)
        ("\\*aws .*\\*" :regexp t :ignore nil :select t :same t)
        ("*HTTP Response*" :ignore nil :select t :same t)
        ("*aws-instances*" :ignore nil :select t :same t)
        ("*annotations*" :ignore nil :select t :same t)
        ("*inferior-lisp*" :ignore nil :select t :same t)
        ("\\*sly-mrepl.*" :regexp t :ignore nil :select t :same t)
        ("\\* docker image inspect.*" :regexp t :ignore nil :select t :same t)
        ("\\* docker container inspect.*" :regexp t :ignore nil :select t :same t)
        ("*undo-tree*" :size 0.25 :align my-shackle-sensible-alignment)
        ("\\*doc-override.*" :regexp t :size 0.25 :align my-shackle-sensible-alignment)
        ("*Google Translate*" :size 0.25 :align my-shackle-sensible-alignment :select t)
        ("*Flycheck error messages*" :size 0.25 :align my-shackle-sensible-alignment :select nil)
        ("*Racket REPL*" :select t :same t)
        ("\\*YASnippet Tables.*" :regexp t :select t :same t)
        ("\\*Slack - .*" :regexp t :select t :same t)
        ("*Apropos*" :ignore nil :select t :same t)
        ("*prodigy*" :select t :same t)
        ("*lsp-diagnostics*" :select t :same t)
        ("*Shell Command Output*" :ignore t :select nil :same nil)
        ("\\*Async Shell.*" :regexp t :ignore t)
        ("*Async Shell Command*" :ignore t :select nil :same nil)
        ("*Process List*" :select t :same t)
        ("*pydoc*" :select nil :same t)
        ("*url cookies*" :select nil :same t)
        ("\\*edit-indirect .*\\*" :regexp t :select t :same t)
        ("\\*How Do You.*\\*" :regexp t :select t :same t)
        ("\\*Perl-REPL.*\\*" :regexp t :select t :same t)
        ("\\*GHCi-REPL.*\\*" :regexp t :select t :same t)
        ("*eshell*" :select t :other t)
        ("*Python*" :ignore t :select nil :same nil)
        ("*eww bookmarks*" :select nil :same t)
        ("*haskell*" :ignore t :select nil :same nil)
        ("*Compile-Log*" :ignore t :select nil :same nil)
        ("*Flycheck errors*" :select t :same t)
        ("*Warnings*" :ignore t :select nil :same t)
        ("*warnings*" :ignore t :select nil :same t)
        ("*Ibuffer*" :select t :same nil)
        ("*slime-description*" :select nil :same nil)
        ("*Proced*" :select t :same t)
        ("\\*edbi.*" :regexp t :select t :same t)
        ("\\*jenkins.*" :regexp t :select t :same t)
        ("*Anaconda*" :other t :select nil :same nil :align my-shackle-sensible-alignment :size 0.5)
        ("*Help*" :select t :same t)
        ("\\*helpful function.*" :regexp t :other t :select nil :same nil :align my-shackle-sensible-alignment :size 0.5)
        (circe-channel-mode :select t :same t)
        (circe-server-mode :select t :same t)
        ("*org-brain*" :select t :same t)
        ("*Bufler*" :select t :same t)
        ("*edbi-dialog-ds*" :select t :same t)
        ("\\*wiki-summary\\*.*" :regexp t :select t :same t)
        ("\\*Dictionary\\*.*" :regexp t :select t :same t)
        ("\\*gist-.*" :regexp t :select t :same t)
        ("\\*Org Src.*" :regexp t :select t :same t)
        ("*WordNut*" :select t :same t)
        ("*arXiv search*" :select t :same t)
        (occur-mode :select t :align t)
        ("*Completions*" :size 0.3 :align t)
        ("*Messages*" :select nil :inhibit-window-quit t :other t)
        ("\\*[Wo]*Man.*\\*" :regexp t :select t :inhibit-window-quit t :same t)
        ("\\*poporg.*\\*" :regexp t :select t :other t)
        ("*command-log*" :select nil :size 0.3 :align t)
        ("*Calendar*" :select t :size 0.3 :align below)
        ("*info*" :select t :inhibit-window-quit t :same t)
        ("\\*magit-diff: .*" :regexp t :select t :same t)
        (magit-status-mode :select t :inhibit-window-quit t :same t)
        (magit-log-mode :select t :inhibit-window-quit t :same t)))

(shackle-mode 1)


(provide 'setup-shackle)
(provide 'my-shackle)