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
(package-install 'vimrc-mode nil)

(require 'company-tabnine)

(company-tabnine-install-binary)
(add-to-list 'company-backends #'company-tabnine)
(package-install 'go-mode nil)
(package-install 'lsp-mode nil)

(require 'lsp)

(package-install 'dap-mode nil)
(package-install 'purescript-mode nil)
