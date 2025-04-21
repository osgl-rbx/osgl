--!optimize 2
-- saaawdust ~ A port of Rusts `Result` in Roblox

------------------------------------------------------------
-- OSGL v1.6.1 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

export type Result<T, E> = {
    isOk: boolean,
    value: { T | E },

    Unwrap: (self: Result<T, E>) -> T,
    Expect: (self: Result<T, E>, message: string) -> T,

    UnwrapErr: (self: Result<T, E>) -> E,
    ExpectErr: (self: Result<T, E>, message: string) -> E,

    UnwrapOr: (self: Result<T, E>, value: T) -> T,
    Or: (self: Result<T, E>, value: Result<T, E>) -> Result<T, E>,
}

local Result = {}

--- A `Result` represents the outcome of an operation that can either succeed (`Ok`) or fail (`Err`).
--- Inspired by Rust's `Result` type, it provides a structured way to handle errors without exceptions or `nil` checks.
function Result.new<T, E>(isOk: boolean, ...: T | E): Result<T, E>
    local Res: Result<T ,E> = {
        isOk = isOk,
        value = {...},
    }

    --- Unwraps the `Result`, returning the value if `Ok`.
    --- Throws an error if the `Result` is `Err`.
    --- @returns The value wrapped in `Ok`.
    --- @error Throws an error if the `Result` is `Err`.
    function Res:Unwrap()
        return Res:Expect("Attempt to `unwrap` an erroneous value")
    end

    function Res:Expect(message: string)
        if not Res.isOk then
            error(message, 3)
        end

        return table.unpack(Res.value)
    end

    --- Unwraps the `Result`, returning the error if `Err`.
    --- Throws an error if the `Result` is `Ok`.
    --- @returns The error wrapped in `Err`.
    --- @error Throws an error if the `Result` is `Ok`.
    function Res:UnwrapErr()
        return Res:ExpectErr("Attempt to unwrap an error out of a correct value")
    end

    function Res:ExpectErr(message: string)
        if not Res.isOk then
            return Res.value[1]
        end

        error(message, 3)
    end

    --- Unwraps the `Result`, returning the value if `Ok` or a default value if `Err`.
    --- @param v any The default value to return if the `Result` is `Err`.
    --- @returns The value wrapped in `Ok`, or `default` if `Err`.
    function Res:UnwrapOr(v: T)
        if Res.isOk then
            return table.unpack(Res.value)
        end

        return v
    end

    function Res:Or(otherValue: Result<T, E>)
        if not Res.isOk then
            Res = otherValue
        end

        return Res
    end

    return Res
end

return Result
