+++
title = "Solving Emacs Garbage Collection Stutters"
date = 2025-05-12
+++

The more you load Emacs up with packages, the more it starts to show its age. Throw on a theme and an lsp client, and you might start to notice frequent stuttering. 

This problem was very frustrating for me - I dealt with it for months, and considered quitting Emacs altogether. I want to be able to hold `C-n` and linearly move down the document, micro-stutter *free*.


# Garbage Collection
It turns out that the problem wasn't that packages were executing slowly, it was the garbage that they were building up. Emacs' garbage collector waits until a byte threshold has been reached before executing. 
> This value feels relatively low for a modern computer - only `800KB`.

Once threshold is reached the garbage collection process takes time, and causes the stutter. If you want to see just how often this triggers the GC, try setting `garbage-collection-messages` to non nil (you might be surprised how often it triggers). As with most things in Emacs, you can tune this behaviour.

Opinions differ.
- Some people recommend **increasing** the threshold, leading to longer times without triggering the GC but longer stutters. 
- Others recommend **lowering** the threshold, causing more frequent GC triggers but smaller stutters.
- The minibuffer (especially with packages like `vertico`) can use a lot of memory, so some [recommend](https://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/) increasing the threshold only when using it.

# The Solution
In my opinion, the best solution is to garbage collect **when idle**. When editing, you're often pausing briefly - and if there is little garbage, Emacs can collect it very quickly.
I also *basically* disable the threshold entirely when in the minibuffer. Here's the code from my `init.el`.

```lisp
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000000))

(setq gc-cons-threshold most-positive-fixnum)

(run-with-idle-timer 1.2 t 'garbage-collect)
```

I have been using this for a few months and it's worked perfectly. Even when I try my best to notice the garbage collection, I can't.

> There is a package which does the same thing, called [the Garbage Collector Magic Hack](https://github.com/emacsmirror/gcmh). Personally I prefer a lower idle time, and keeping it in my own config. 
