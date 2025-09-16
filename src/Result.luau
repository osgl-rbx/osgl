export type Result<T, E> = {
    isOk: boolean,
    value: {T | E},

    Unwrap: (self: Result<T, E>) -> T,
    Expect: (self: Result<T, E>, message: string) -> T,

    UnwrapErr: (self: Result<T, E>) -> E,
    ExpectErr: (self: Result<T, E>, message: string) -> E,
}

export type SmallResult<T, E> = {
    isOk: boolean,
    value: {T | E}
}

local Result = {}

function Result.new<T, E>(isOk: boolean, ...: T | E): Result<T, E>
    return Result.castSmallToDefault(
        Result.newSmall(isOk, ...)
    )
end

function Result.ok<T, E>(...: T | E): Result<T, E>
    return Result.new(true, ...)
end

function Result.err<T, E>(...: T | E): Result<T, E>
    return Result.new(false, ...)
end

function Result.newSmall<T, E>(isOk: boolean, ...: T | E): SmallResult<T, E>
    return {
        isOk = isOk,
        value = {...},
    }
end

function Result.okSmall<T, E>(...: T | E): SmallResult<T, E>
    return Result.newSmall(true, ...)
end

function Result.errSmall<T, E>(...: T | E): SmallResult<T, E>
    return Result.newSmall(false, ...)
end

function Result.castSmallToDefault<T, E>(result: SmallResult<T, E>): Result<T, E>
    local res = result

    function res:Unwrap()
        return res:Expect("Attempt to `unwrap` an erroneous value")
    end

    function res:Expect(message: string)
        if not res.isOk then
            error(message, 3)
        end

        return table.unpack(res.value)
    end

    function res:UnwrapErr()
        return res:ExpectErr("Attempt to unwrap an error out of a correct value")
    end

    function res:ExpectErr(message: string)
        if not res.isOk then
            return res.value[1]
        end

        error(message, 3)
    end

    return res
end

return Result