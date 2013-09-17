;;设置默认文件格式
(setq default-buffer-file-coding-system 'utf-8)

;;设置用户细节
(setq user-full-name "zysw")
(setq user-mail-address "zysw01@gmail.com")

;;设置环境
(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))
(require 'cl)

;;设置包管理工具
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq package-archive-enable-alist '(("melpa" deft magit)))

;;设置默认包列表
(defvar zysw/packages '(ac-slime
                          auto-complete
                          smartparens
                          magit
                          markdown-mode
                          org
                          puppet-mode
                          smex
                          yaml-mode
			  ess)
  "Default packages")

;;emacs启动时检测默认包是否安装，未安装则使用elpa安装
(defun zysw/packages-installed-p ()
  (loop for pkg in zysw/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (zysw/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg zysw/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;;_____________________________________________________________________________
;;                                   设置启动操作
;;-----------------------------------------------------------------------------

;;去掉启动画面（Splash Screen）
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;;去掉工具栏、滚动条
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode 1)

;; 设置显示括号的样式
(setq show-paren-style 'mixed) 

 ;; 光标与鼠标重合时，移开鼠标
(mouse-avoidance-mode 'animate)

;;设置其他的插件位置
(defvar zysw/plugins  (expand-file-name "plugins" "~/.emacs.d/"))
(add-to-list 'load-path  zysw/plugins)
(dolist (project (directory-files   zysw/plugins t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;;加载主题
(add-to-list 'custom-theme-load-path zysw/plugins)
(load-theme 'Amelie t)

;;显示列号
(column-number-mode 1)
;;(setq column-number-mode t)

;; 启动 Emacs 服务，下次打开文件时使用同一个 Emacs
(server-start)

;;设置自动补全
 (require 'smartparens-config) 
(smartparens-global-mode t) 
;; highlights matching pairs 
(show-smartparens-global-mode t) 
(add-hook 'ess-R-post-run-hook 'smartparens-mode) ;;R专用

;;设置自动匹配
(require `auto-complete-config)
(ac-config-default)

;;配置Smex,Smex非常必要，他可以提供历史和搜索当你M-X时。
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;设置ido
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

;;设置markdown
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (visual-line-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")
(setq markdown-css-path (expand-file-name "markdown.css" zysw/plugins))


;;---------------------------------------------------------------------------
;;                       ESS配置
;;---------------------------------------------------------------------------

;;加载ESS
(require 'ess-site)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

;;ESS的代码缩进设置
(add-hook 'ess-mode-hook
          (lambda ()
            (ess-set-style 'C++ 'quiet)
            (setq comment-column 4) ; 把以#开始的行缩进4空格，免得难看
            (show-paren-mode t)     ; 自动加亮跟踪括号
            ess-indent-level 2
            ess-continued-statement-offset 2
            ess-brace-offset 0
            ess-arg-function-offset 4
            ess-expression-offset 2
            ess-else-offset 0
            ess-close-brace-offset 0
))

;;运算符书写规范
(require 'smart-operator)
(add-hook 'ess-mode-hook 'smart-operator-mode)
(add-hook 'inferior-ess-mode-hook 'smart-operator-mode)


