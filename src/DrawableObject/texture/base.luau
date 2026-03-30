local Texture = script.Parent
local DrawableObject = Texture.Parent
local OSGL = DrawableObject.Parent

local base = require(DrawableObject.base)
local types = require(OSGL.types)

local Result = require(OSGL.result)
local oEnum = require(OSGL.enums)
local ImmutableTexture = require(Texture.immutable)

type Result<T, E> = Result.Result<T, E>

function ToImmutable(self: types.MutableTexture): Result<types.ImmutableTexture, oEnum.TextureError>
    return ImmutableTexture.fromBuffer(self.buffer, self)
end

export type TextureBase = base.Base & {
    ToImmutable: typeof(ToImmutable)
}

return {
    new = function(): TextureBase
        local self = base.new()
        self.ToImmutable = ToImmutable

        return self
    end
}