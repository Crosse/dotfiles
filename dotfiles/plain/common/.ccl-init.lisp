(load #P"~/.lisprc")

(setf *quit-on-eof* t)

;(defun lisp-prompt-format (stream level)
;  (if (zerop level)
;    (format stream "~%[CCL] ~A> " (package-name *package*))
;    (format stream "~%[~d] > " level)))

(when (interactive-stream-p *terminal-io*)
    (require :linedit)
    (funcall (intern "INSTALL-REPL" :linedit) :wrap-current t :eof-quits t))


(setf ccl:*listener-prompt-format* #'lisp-prompt-format)
(setf ccl:*default-file-character-encoding* :utf-8)
