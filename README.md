<h3 align="center">
  <img src="https://raw.githubusercontent.com/osgl-rbx/osgl/6c648cbffe55ffd189a54961e83def048583c76d/gh/Banner.svg" alt="OSGL Banner">
  <div style="margin: 24px 0;">
    <h4 align="center" style="margin: 0; line-height: 1.6;">
      <i>A powerful, lightweight graphics library for Roblox.<br>
      Draw videos, textures, fonts, and more, all at <b>blazingly fast</b> speeds.</i>
    </h4>
  </div>
  <img src="gh/Seperation.svg" alt="Section divider" style="margin: 8px 0 24px;">
</h3>

OSGL is a powerful graphics library for Roblox inspired by modern low-level graphics APIs.

- **Blazingly fast** rendering performance
- **Lightweight** and dependency-free
- **Thread-safe** architecture
- **Simple, intuitive** API

## Getting started

Check out the [documentation](https://osgl-rbx.github.io/osgl/) for installation guides and tutorials.

## Code sample

```lua
local OSGL = require(path.to.osgl)
local Window = OSGL.Window
local color = OSGL.color

local Image = path.to.imageLabel

-- Create a new drawing context (500px by 500px)
local canvas = Window.from(Image, 500, 500):Unwrap()

-- Clear the entire screen red
canvas:Clear(color.RED)

-- Render the frame
canvas:Render()
```