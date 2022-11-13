# Nexus VR Core
Nexus VR Core is a framework for assisting the development
of VR content on Roblox. The goal of Nexus VR Core is to
provide an implementation for pointing a `SurfaceGui`s without
additional overhead and improving `ScreenGui`s with minimal
additional overhead.

## Problems With Roblox's Implementation
Roblox provides a native implementation for `ScreenGui`s and
`SurfaceGui`s, but is too limited for a lot of cases. Some of
the limits include:

* `ScreenGui`s don't follow the user, making HUDs impractical.
* `SurfaceGui`s are only interactable with the right controller.

## Nexus VR Core Limitations
When considering using Nexus VR Core, the following
limitations should be considered:

* `Touched` events are not handled.
* The default character and camera implementations are not replaced. Use [Nexus VR Character Model](https://github.com/thenexusAvenger/nexus-vr-character-model) for that. Version 2.0.0 and newer include Nexus VR Core.
* Multiple instances of Nexus VR Core can lead to unintended consequences.
* Hardware support is dependant on Roblox. Some devices like the Valve Index may not perform as intended because of the lack of support from Roblox.