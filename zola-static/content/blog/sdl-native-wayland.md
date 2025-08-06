+++
title = "Forcing SDL3 to actually use Wayland on Wayland."
date = 2025-08-06
+++

[SDL3](https://wiki.libsdl.org/SDL3/FrontPage) is a great platform abstraction layer. On Linux, it compiles with support for both [X Window System](https://www.x.org/wiki/) and [Wayland](https://wayland.freedesktop.org/). This is great because it makes your app compatible with just about any desktop environment and window manager.

Here's the thing. X11 apps can still run under Wayland through the XWayland compatibility layer. In the [SDL3 documentation](https://wiki.libsdl.org/SDL3/README-wayland) it says that
> Wayland is a replacement for the X11 window system protocol and architecture and is favored over X11 by default in SDL3

This sounds great. Wayland is a replacement for X11 so I would rather use it instead of X with XWayland. Wayland native apps work better with my window manager, and behave more consistently. Unfortunately, in practice **SDL does not use Wayland**. My SDL windows open using X. I don't know if it's a problem with my environment, but here's how I fixed it (for c++).
```c++
for (int i = 0; i < SDL_GetNumVideoDrivers(); i++) {
    if (std::string(SDL_GetVideoDriver(i)) == "wayland") {
        SDL_SetHintWithPriority(SDL_HINT_VIDEO_DRIVER, "wayland", SDL_HINT_OVERRIDE);
        break;
    }
}
```
This code will explicitly enable Wayland if it is available. Thanks to my friend Riley for helping to figure it out.
> I've [asked about this issue](https://discourse.libsdl.org/t/is-wayland-really-default) on the SDL discourse. I'll update this post if there are any more details.
