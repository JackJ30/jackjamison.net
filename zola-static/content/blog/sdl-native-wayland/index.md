+++
title = "Why SDL3 doesn't use Wayland on Wayland."
date = 2025-08-06
updated = 2025-08-08
+++

[SDL3](https://wiki.libsdl.org/SDL3/FrontPage) is a great platform abstraction layer. On Linux, it compiles with support for both [X Window System](https://www.x.org/wiki/) and [Wayland](https://wayland.freedesktop.org/). This is great because it makes your app compatible with just about any desktop environment or window manager. In the [SDL3 documentation](https://wiki.libsdl.org/SDL3/README-wayland) it says that
> Wayland is a replacement for the X11 window system protocol and architecture and is favored over X11 by default in SDL3

However, if your compositor does not implement the `wp_fifo_manager_v1` protocol SDL will fall back to XWayland. My compositor doesn't have it, and here's how I forced SDL to use Wayland anyway (for c++).
```c++
for (int i = 0; i < SDL_GetNumVideoDrivers(); i++) {
    if (std::string(SDL_GetVideoDriver(i)) == "wayland") {
        SDL_SetHintWithPriority(SDL_HINT_VIDEO_DRIVER, "wayland", SDL_HINT_OVERRIDE);
        break;
    }
}
```
This code will explicitly enable Wayland if it is available.
