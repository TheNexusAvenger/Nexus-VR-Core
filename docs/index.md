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
    * `SurfaceGui`s are interactable if and only if they are in the player's `PlayerGui`.
    * `SurfaceGui`s in `Workspace` with buttons can lead to crashing ([VR immediately crashes when you try to interact with any surface gui](https://devforum.roblox.com/t/vr-immediately-crashes-when-you-try-to-interact-with-any-surface-gui/498889)).
* There is no visual indicator that a user is pointing at a `SurfaceGui`.

## Nexus VR Core Limitations
When considering using Nexus VR Core, the following
limitations should be considered:

* Instances created with `Instance.new(...)` will not have events unless they are fetched from a wrapped instance afterward.
    * Either use `NexusWrappedInstance.new(...)` or index from another wrapped instance.
* Wrapped instances should be `Destroy`ed when done, not just unparented. This may lead to a memory leak if not done.
* `BillboardGui`s are not supported.
* Input objects from `InputBegan`, `InputChanged`, and `InputEnded` are basic and are missing some properties. Create a GitHub Issue if a property is missing that you need with your use case.
* `ClickDetector` events do not replicate to the server.
* `Touched` events are not handled.
* The chat is not automatically made better for VR.
* Core GUIs, like purchase prompts, can't be modified and are stuck with the native `ScreenGui` implementation.
* The default character and camera implementations are not replaced. Use [Nexus VR Character Model](https://github.com/thenexusAvenger/nexus-vr-character-model) for that. Version 2.0.0 and newer include Nexus VR Core.
* Multiple instances of Nexus VR Core can lead to unintended consequences.
* Hardware support is dependant on Roblox. Some devices like the Valve Index may not perform as intended because of the lack of support from Roblox.
* Auto button coloring is not affected by pointing.