This package defines several Org link types which can be used to
link to certain Magit buffers.

   orgit:/path/to/repo/           links to a `magit-status' buffer
   orgit-log:/path/to/repo/::REV  links to a `magit-log' buffer
   orgit-rev:/path/to/repo/::REV  links to a `magit-revision' buffer

Such links can be stored from corresponding Magit buffers using
the command `org-store-link'.

When an Org file containing such links is exported, then the url of
the remote configured with `orgit-remote' is used to generate a web
url according to `orgit-export-alist'.  That webpage should present
approximately the same information as the Magit buffer would.

Both the remote to be considered the public remote, as well as the
actual web urls can be defined in individual repositories using Git
variables.

To use a remote different from `orgit-remote' but still use
`orgit-export-alist' to generate the web urls, use:

   git config orgit.remote REMOTE-NAME

To explicitly define the web urls, use something like:

   git config orgit.status http://example.com/repo/overview
   git config orgit.log http://example.com/repo/history/%r
   git config orgit.rev http://example.com/repo/revision/%r
