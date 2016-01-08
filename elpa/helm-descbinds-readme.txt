This package is a replacement of `describe-bindings' for Helm.

Usage:
Add followings on your .emacs.

  (require 'helm-descbinds)
  (helm-descbinds-mode)

or use customize to set `helm-descbinds-mode' to t.

Now, `describe-bindings' is replaced to `helm-descbinds'. Type
`C-h b', `C-x C-h' these run `helm-descbinds'.

In the Helm buffer, you can select key-binds with Helm interface.

 - When type RET, selected candidate command is executed.

 - When type TAB, you can "Execute", "Describe Function" or "Find
   Function" by the menu.

 - When type C-z, selected command is described without quitting.

On a prefix command, hitting RET will restart the session using
this prefix.
