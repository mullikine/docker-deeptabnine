(require 'package)
;; stable
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; bleeding
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)

(package-initialize)
(package-refresh-contents)
(package-install 'git-timemachine nil)
;; (package-install 's nil)
(package-install 'magit nil)
(package-install 'ghub nil)
(package-install 'ghub+ nil)
(package-install 'magithub nil)
(package-install 'docker nil)
(package-install 'xclip nil)
(package-install 'shackle nil)
(package-install 'helm nil)
(package-install 'company nil)
(package-install 'company-tabnine nil)
(require 'company-tabnine)
(company-tabnine-install-binary)
(add-to-list 'company-backends #'company-tabnine)
(package-install 'go-mode nil)
(package-install 'lsp-mode nil)

(require 'lsp)

(defun lsp-list-all-servers ()
  (mapcar 'car (--map (cons (funcall
                             (-compose #'symbol-name #'lsp--client-server-id) it) it)
                      (or (->> lsp-clients
                               (ht-values)
                               (-filter (-andfn
                                         (-orfn (-not #'lsp--server-binary-present?)
                                                (-const t))
                                         (-not #'lsp--client-download-in-progress?)
                                         #'lsp--client-download-server-fn)))
                          (user-error "There are no servers with automatic installation")))))


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

(lsp-install-server-by-name "vimls")

(package-install 'dap-mode nil)
(package-install 'purescript-mode nil)
