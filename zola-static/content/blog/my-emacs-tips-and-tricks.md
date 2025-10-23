+++
title = "My Emacs Configuration Tips and Tricks"
date = 2025-10-22
+++

# Introduction
Throughout my time using GNU Emacs and its package ecosystem, I've found some annoying quirks that took a while to figure out, and I'm documenting them here. This will be a living document.

# Fixes
## General Stutters (Caused by Garbage Collection)
Garbage collection stutters is a common problem among Emacs users, and I have a constroversial solution which has worked for me. Basically: **only garbage collect when you are idle** (even for short periods of time). Read more about it [here](@/blog/emacs-garbage-collection.md).
```lisp
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000000))

(setq gc-cons-threshold most-positive-fixnum)

(run-with-idle-timer 1.2 t 'garbage-collect)
```

## Lsp-Mode Gives Bad Completion Results
Sometimes completion results won't refresh or refilter. This one pissed me off for a while because I couldn't quite nail down whose fault it was. It turns out that it was `lsp-mode` being overzealous with caching. There is a [cape](https://github.com/minad/cape) transformer which breaks the cache and fixes the results. Here's part of my config:
```lisp
(use-package cape
  :init
  (defun my/lsp-capf-busted ()
    "Return an uncached LSP completion function."
    (cape-capf-buster #'lsp-completion-at-point))
  (add-hook 'lsp-completion-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (my/lsp-capf-busted))))))
```

# General Advice
## Which Lsp Client?
I use `lsp-mode`. I would love to switch to `eglot`, but I really like `lsp-ui`'s peek feature and it hasn't been ported to eglot yet.
There are several other lsp clients meant to increase speed (such as [lsp-bridge](https://github.com/manateelazycat/lsp-bridge)), but I've got the best results on `lsp-mode` with [lsp-booster](https://github.com/blahgeek/emacs-lsp-booster).

<!-- ## Which Completion Provider? -->

<!-- ## Which Package Manager? -->
