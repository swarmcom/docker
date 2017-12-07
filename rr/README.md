HTTP File server
================

Record and maintains different files: records, music on holds and avatar images. Each write (HTTP PUT) must be confirmed (HTTP POST),
or file will be deleted after timeout.

Also has built-in Icecast compatible music player to serve MOHs continuously.
