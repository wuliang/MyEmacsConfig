;;;
;;; Org Mode
(require 'org-install)

(add-to-list 'load-path (expand-file-name "~/org-life/git/elisp"))
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;;
;; Open Some mode and flag
(add-hook 'message-mode-hook 'turn-on-orgstruct 'append)
(add-hook 'message-mode-hook 'turn-on-orgstruct++ 'append)
(add-hook 'message-mode-hook 'turn-on-auto-fill 'append)
;; It is confused with Chinese.
(add-hook 'message-mode-hook 'turn-off-flyspell 'append)
(add-hook 'message-mode-hook 'orgtbl-mode 'append)

;; Org Mode 
(add-hook 'org-mode-hook 'turn-off-flyspell 'append)

;; Disable C-c [ and C-c ] in org-mode
(add-hook 'org-mode-hook
          (lambda ()
            ;; Undefine C-c [ and C-c ] since this breaks my
            ;; org-agenda files when directories are include It
            ;; expands the files in the directories individually
            (org-defkey org-mode-map "\C-c["    'undefined)
            (org-defkey org-mode-map "\C-c]"    'undefined))
          'append)

;; Mail subtree
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-o") 'my-mail-subtree))
          'append)

;; Implete Mail subtree
(defun my-mail-subtree ()
  (interactive)
  (org-mark-subtree)
  (org-mime-subtree))

;;; Set Agenda files
;; 第1个目录为主目录;后面的目录根据情况变化
(setq org-agenda-files (quote ("~/org-life/git/org"
                               "~/org-life/git/org/company"
                               "~/org-life/git/org/blog"
                               "~/org-life/git/org/nlp"
                               "~/org-life/git/org/scrapy")))

;;;快捷键绑定
;; Standard key bindings
(global-set-key (kbd "<f11> l")  'org-store-link)
(global-set-key (kbd "<f11> a")  'org-agenda)
(global-set-key (kbd "<f11> b")  'org-iswitchb)
(global-set-key (kbd "<f11> c")  'org-capture)

;; 调到todo列表
(global-set-key (kbd "<f11> t")  'org-todo)
;; 对选中任务开始记时
(global-set-key (kbd "<f11> i")  'org-clock-in)
;; 停止选中任务记时
(global-set-key (kbd "<f11> o")  'org-clock-out)
;; 跳到正在记时的任务
(global-set-key (kbd "<f11> g")  'org-clock-goto)
;; 切换日程文件
(global-set-key (kbd "<f11> f")  'org-cycle-agenda-files)
;; 全屏显示本子树
(global-set-key (kbd "<f11> n")  'org-narrow-to-subtree)


;; 发邮件
;; (global-set-key (kbd "<f9> g")  'gnus)
;; 限定显示选中区域
(global-set-key (kbd "<f9> r")  'narrow-to-region)
;; 放开显示特定区域
(global-set-key (kbd "<f9>  w") 'widen)
;; 设置分段
(global-set-key (kbd "<f9> T") 'set-truncate-lines)
;; 打开bbdb文件
(global-set-key (kbd "<f9> b") 'bbdb)
;; 打开日历界面
(global-set-key (kbd "<f9> c") 'calendar)
;; 隐藏其它的子树
(global-set-key (kbd "<f9> h") 'hide-other)
;; tab化，空格变tab
(global-set-key (kbd "<f9> t") 'tabify)
;; 去tab化，tab变空格
(global-set-key (kbd "<f9> u") 'untabify)
;; 让不可见的内容临时可见
(global-set-key (kbd "<f9> v") 'visible-mode)
;; 切换到前一个buffer
(global-set-key (kbd "<f9> p") 'prev0ious-buffer)
;; 切换到下一个buffer
(global-set-key (kbd "<f9> n") 'next-buffer)


;; 状态两组，其中|表示DONE类型的状态。只是为了切换方便
;; 不同组之间的切换，可以用C-S-RIGHT，C-S-LEFT完成
;; 括号中为快捷键
;; @表示记录带时间的日志 !表示记录时间 ／表示前一个为入记录－后一个为
;; 出记录（缺省是入记录）。 log缺省会记录在抽屉LOGBOOK中
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE"))))
;; 设定状态的显示
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

;; 强制TODO的状态切换依赖（父任务必须等子任务完成才能完成）
(setq org-enforce-todo-dependencies t)
;; 必须等待Checkbox完成
(setq org-enforce-todo-checkboxdependencies t)

;; 完成时记录时间。在状态定义时已经设定，所以这里关闭
(setq org-log-done 'time)
;; 设置父状态自动完成，当子状态完成
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states) ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; 允许通过S-LEFT，S-RIGHT的修改，只认为是文字修改
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;;; 时间相关的配置
;; 记录所有的记时时钟信息(重启emacs时继续)
;; 可以设置存history还是clock,还是都存(t的时候)
(setq org-clock-persist t)
(org-clock-persistence-insinuate)

;; 设置空闲时间为.10分钟没有操作电脑将视为空闲,org会提示是否扣除时间等
(setq org-clock-idle-time 10)
;; 最多记录15项历史信息
(setq org-clock-history-length 15)
;; 允许继续之前已经打开的时钟?允许未关闭的时钟再次纪时?
;; (setq org-clock-in-resume t) --my: 这应当是一种异常

;; 记时信息是否装入抽屉,使用系统缺省的抽屉( LOGBOOK?)
(setq org-clock-into-drawer t)
;; 不足1分钟的记时忽略
(setq org-clock-out-remove-zero-time-clocks t)
;; 状态变为DONE时,自动停止记时
(setq org-clock-out-when-done t)
;; 时间报告中包含正在记时的任务
(setq org-clock-report-include-clocking-task t)

;; 没有写明保存文件的抓取都记录到notes.org文件中
(setq org-default-notes-file "~/org-life/git/org/notes.org")
;; 确定的抓取类型:
;; gtd.org记录task;
;; journal.org记录日记(按日记录的一切东西)
;; %? 表示鼠标停留的位置 ; %i 表示抓取时region的内容; %a表示link; %U表
;; 示时间(非激活); %t表示按日的时间(激活)
;; Journal和Phone可人持续比较长时间,所以单独开始记时
;; 一些意外的中断即转到Jounal中记录
(setq org-capture-templates
      (quote (("t" "Todo" entry (file+headline "~/org-life/git/org/gtd.org" "Tasks")
               "* TODO %?\n %i\n %a")
              ("j" "Journal" entry (file+datetree "~/org-life/git/org/journal.org")
               "* %?\nEntered on %U\n %i\n %a")
              ("p" "Phone call" entry (file+headline "~/org-life/git/org/gtd.org" "Phones")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file+headline "~/org-life/git/org/gtd.org" "Habits")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n  %i"))
             ))

;;
;; 邮件配置
;; 发送邮件功能
;;（1） 页面显示 


;;（2）邮件发送
(setq user-mail-address "www.wuliang.cn@gmail.com"
      user-full-name "Wu Liang")
(setq mail-user-agent 'message-user-agent)

;;Tell Emacs about your mail server and credentials
;;If you tried configuring your SMTP server on port 465 (with SSL) and
;;port 587
;;(with TLS), but are still having trouble sending mail,
;;try configuring your SMTP to use port 25 (with SSL).
;; Donot forget to modify authinfo, if port changed

(require 'tls)
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
;;      starttls-gnutls-program "/usr/bin/gnutls-cli"
      starttls-extra-arguments nil      
      smtpmail-gnutls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-starttls-credentials 
       '(("smtp.gmail.com" 587 "www.wuliang.cn@gmail.com" nil))
       smtpmail-default-smtp-server "smtp.gmail.com"
       smtpmail-smtp-server "smtp.gmail.com"
       smtpmail-smtp-service 587
       smtpmail-stream-type 'ssl
       smtpmail-debug-info nil
       smtpmail-local-domain "qingshi.com")
(require 'smtpmail)

;; 收邮件使用离线收取
;; 调用Offlinemap-el,负责检索邮件？ 现在放在Shell做
;; (require 'offlineimap) 
(require 'notmuch)

;; (setq mm-text-html-renderer 'w3m) ;; html2text is default, if no w3m
(setq notmuch-fcc-dirs nil) ; Gmail saves sent mails by itself

(global-set-key (kbd "<f11> m g") 'notmuch)

(defun ext-notmuch-view-html ()
"Open the HTML parts of a mail in a web browser."
(interactive)
(with-current-notmuch-show-message
    (let ((mm-handle (mm-dissect-buffer)))
         (notmuch-foreach-mime-part
         (lambda (p)
         (if (string-equal (mm-handle-media-type p) "text/html")
             (mm-display-external p (lambda ()
              (message "Opening web browser...")
              (browse-url-of-buffer)
     (bury-buffer)))))
          mm-handle))))

(defun ext-notmuch-search-filter-by-date (days)
(interactive "NNumber of days to display: ")
 (let* ((now (current-time))
   (beg (time-subtract now (days-to-time days)))
    (filter
      (concat
           (format-time-string "%s.." beg)
           (format-time-string "%s" now))))
  (notmuch-search-filter filter)))

(define-key notmuch-show-mode-map (kbd "RET") 'goto-address-at-point)
(define-key notmuch-show-mode-map (kbd "H") 'ext-notmuch-view-html)
(define-key notmuch-show-mode-map (kbd "D") 'ext-notmuch-search-filter-by-date)

(setq notmuch-saved-searches 
      '(("inbox" . "tag:inbox")
        ("sent"  . "tag:sent"))) 

;; TAB自动Complete地址
(require 'notmuch-address)
(setq notmuch-address-command "$HOME/org-life/tools/utils/nottoomuch-addresses.sh")
(notmuch-address-message-insinuate)

;; Notmuch-ORG的结合
(require 'org-notmuch)

;;;;;;;;;
;; Literature
;; 脚本位于： $HOME/Documents/Literature/scripts/
(defun dired-literature-create-directory-from-pdf ()
  (interactive)
  (save-window-excursion
    (dired-do-async-shell-command
   "$HOME/Documents/Literature/scripts/LitCreateDir.sh" current-prefix-arg
   (dired-get-marked-files t current-prefix-arg))))
;; 定义按键调用pdf文件打包   
;;(setq dired-mode-map (make-keymap))
;;            (suppress-keymap dired-mode-map)

;; (define-key dired-mode-map (kbd "s-l d") 'dired-literature-create-directory-from-pdf)
(global-set-key (kbd "<f12> d") 'dired-literature-create-directory-from-pdf)

;; 定义按键调用更新
(defun literature-update ()
  (interactive)
  (shell-command "$HOME/Documents/Literature/scripts/LitUpdate.sh")
)
(global-set-key (kbd "<f12> u") 'literature-update)


;; 加强版本的Dired
;;(require  'dired-launch) ? not work for me
(require  'dired-sort-map)
(require  'dired-details)
(dired-details-install)

;; 和dired-launch类似。用外部程序打开文件
(require 'openwith)
(openwith-mode t)

;; NLP-Delphin-LKB
(let ((root (or (getenv "DELPHINHOME")
                  "$HOME/delphin")))
    (if (file-exists-p (format "%s/lkb/etc/dot.emacs" root))
      (load (format "%s/lkb/etc/dot.emacs" root) nil t t)))

;;;
;;; NLP-Delphin-LOGON-specific settings
;;;
(if (getenv "LOGONROOT")
    (let ((logon (substitute-in-file-name "$LOGONROOT")))
      (if (file-exists-p (format "%s/dot.emacs" logon))
         (load (format "%s/dot.emacs" logon) nil t t))))
;; END.
