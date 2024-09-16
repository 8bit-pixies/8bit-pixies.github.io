---
title: "Dear IMGui - for Cross Platform Stuff"
author: 8bit-pixies
author-url: "https://github.com/8bit-pixies/"
toc-title: Contents
---

# 2024 September 17

I've been looking for a cross platform, GUI that works on Web and Desktop that isn't Web based (e.g. webview) and can be consistent across multiple programming languages and uses immediate mode. The setup that I finally arrived is using the go-bindings for Dear IM Gui. 

The gist of it is:

- [giu](https://github.com/AllenDang/giu) can be used to create desktop applications
- [ebiten-imgui](https://github.com/gabstv/ebiten-imgui/tree/master) can be used to create web applications

These seem like weird choices, because it would be difficult to build a consistent application across all platforms (well, one could use [ebiten-imgui](https://github.com/gabstv/ebiten-imgui/tree/master) for desktop applications as well I suppose). 

The purpose of this isn't necessarily to use a single framework for everything, but rather focus on having a consistent framework/suite across multiple "small" applications. 

Maybe in the future I'll come up with my custom immediate mode framework to enable this in a consistent manner.