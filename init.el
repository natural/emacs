(package-initialize)
(require 'package)

;; asap appearance changes
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-face-font 'default "Input Mono Compressed-12")


;; maximize window
(ignore-errors
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
			 '(2 "_NET_WM_STATE_FULLSCREEN" 0)))




;; packages
(ignore-errors
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  
  (unless (package-installed-p 'ag)
    (package-refresh-contents))

  (mapc
   (lambda (package)
     (unless (package-installed-p package)
       (package-install package)

       )
     (require package))
   '(
     ag
     aggressive-indent
     all-the-icons-dired
     all-the-icons-ivy
     beacon
     cider
     clojure-mode
     color-identifiers-mode
     counsel
     dashboard
     dashboard-project-status
     doom-modeline
     doom-themes
     eshell-git-prompt
     find-file-in-project
     flycheck-clojure
     goto-line-preview
     highlight-indentation
     indent-guide
     keystore-mode
     magit
     magit-popup
     meghanada
     minimap
     multi-web-mode
     mvn
     paredit
     paredit-everywhere
     powerline
     projectile
     rainbow-identifiers
     rainbow-mode
     swiper
     web-mode
     web-mode-edit-element
     yaml-mode
     )))


;; load theme
(load-theme 'doom-one t)


;; modes and things
(beacon-mode 1)
(doom-modeline-mode 1)
(global-prettify-symbols-mode +1)
(indent-guide-global-mode)
(ivy-mode 1)
(ivy-set-display-transformer 'ivy-switch-buffer 'all-the-icons-ivy-buffer-transformer)
(set-default 'truncate-lines t)
(setq column-number-mode t)
(setq dashboard-banner-logo-title "")
(setq dashboard-center-content t)
(setq dashboard-items '((projects . 5) (bookmarks . 5) (recents  . 20)))
(setq dashboard-startup-banner 'logo)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq cider-repl-display-help-banner nil)
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           #_(figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")
(setq ffip-find-options
      "-not -regex \".*compiled.*\"  -not -regex \".*vendor.*\" -not -regex \".*target.*\" ")


;; hooks
(add-hook 'after-init-hook                        'dashboard-setup-startup-hook)
(add-hook 'after-init-hook                        'global-color-identifiers-mode)
(add-hook 'clojure-mode-hook                      'aggressive-indent-mode)
(add-hook 'clojure-mode-hook                      'enable-paredit-mode)
(add-hook 'clojure-mode-hook                      'rainbow-identifiers-mode)
(add-hook 'clojurescript-mode-hook                'aggressive-indent-mode)
(add-hook 'clojurescript-mode-hook                'enable-paredit-mode)
(add-hook 'clojurescript-mode-hook                'rainbow-identifiers-mode)
(add-hook 'dired-mode-hook                        'all-the-icons-dired-mode)
(add-hook 'emacs-lisp-mode-hook                   'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook  'enable-paredit-mode)
(add-hook 'ielm-mode-hook                         'enable-paredit-mode)
(add-hook 'lisp-mode-hook                         'enable-paredit-mode)
(add-hook 'prog-mode-hook                         'elide-head)
(add-hook 'prog-mode-hook                         'linum-mode)

(add-hook
 'compilation-filter-hook
 (lambda () (when (eq major-mode 'compilation-mode)
	 (let ((inhibit-read-only t))
	   (if (boundp 'compilation-filter-start)
	       (ansi-color-apply-on-region compilation-filter-start (point)))))))

(add-hook
 'eshell-mode-hook
 (lambda () (defun eshell/clear ()
	 (interactive)
	 (let ((inhibit-read-only t))
	   (erase-buffer)
	   (eshell-send-input)))
   (eshell-git-prompt-use-theme 'powerline)
   (local-set-key (kbd "C-l") 'eshell/clear)))

(add-hook
 'java-mode-hook
 (lambda ()
   (meghanada-mode t)
   (flycheck-mode +1)
   ;; (setq c-basic-offset 2)
   ))


(add-hook
 'after-init-hook
 (lambda ()
   (if (not (server-running-p)) (server-start))))


;; keys
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x C-g") 'magit-status)
(global-set-key (kbd "C-x p") 'find-file-in-project)
(global-set-key (kbd "M-g M-g") 'goto-line-preview)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-c C-t") 'mvn-clean-test)


;; 
(defun kill-em-all ()
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
        (buffer-list))
  (delete-other-windows))



(defun mvn-clean-test ()
    (interactive)
    (mvn "clean test"))




;; elide
(require 'elide-head)
(add-to-list 'elide-head-headers-to-hide
	     '("Licensed to the Apache Software Foundation" . "limitations under the License."))



(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
