+++
title = "Solving Emacs Garbage Collection Stutters"
date = 2025-05-12
+++

The more you load Emacs up with packages, the more it starts to chug. Throw on a theme and an lsp client, and you might start to notice frequent stuttering.

This problem was very frustrating for me - I want to be able to hold `C-n` and linearly move down the document, micro-stutter *free*. I spent weeks searching for the problem, and considered quitting Emacs altogether.

# Garbage Collection
It turns out that the problem wasn't that packages were executing slowly, it was the garbage that they were building up.

Emacs' garbage collector waits until a byte threshold (the `gc-cons-threshold` variable) has been reached before executing. Its default value feels relatively low for a modern computer - only `800KB`. This results in frequent garbage collections, each causing a small stutter. Luckily, as with most things in Emacs, you can tune this behaviour.
> If you want to see how frequently the GC is triggered, try setting `garbage-collection-messages` to non nil (you might be surprised).

Opinions on the ideal solution differ.
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

I have been using this for a few months and it's worked perfectly. I've tried my best to notice the garbage collections, I haven't been able to.

> There is a package for this, called [the Garbage Collector Magic Hack](https://github.com/emacsmirror/gcmh). Personally I prefer a lower idle time than its default, and I like keeping it in my own config.
