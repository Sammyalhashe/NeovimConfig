local loop = vim.loop

local parseInput = function(input)
    if not input then
        error("Invalid input")
    end

    local numbers = {}
    local current = ""

    for i = 1, #input do
        local c = input:sub(i, i)
        if c ~= ":" then
            current = current .. c
        else
            local parsed = tonumber(current)
            if not parsed then
                error("Invalid input given, format should be x:x:x")
            end
            table.insert(numbers, parsed)
            current = ""
        end
    end

    if current then
        if current == ":" then
            error("Last value of input cannot be :")
        end
        local parsed = tonumber(current)
        if not parsed then
            error("Invalid input given, format should be x:x:x")
        end
        table.insert(numbers, parsed)
    end
    return numbers
end

local M = {}

local isDone = false

M.signifyDone = function()
    local timer = loop.new_timer()
    local initialBackground = vim.opt.background:get()
    local light = initialBackground == "light"
    timer:start(1000, 1000, vim.schedule_wrap(function()
        if isDone then
            timer:close()
            vim.api.nvim_command('set background=' .. initialBackground)
        end
        if light then
            vim.api.nvim_command('set background=dark')
        else
            vim.api.nvim_command('set background=light')
        end
        light = not light
    end))
end

M.markDone = function()
    isDone = true
end

M.timerFunc = function(input, callback, doneCb)
    if not doneCb then
        doneCb = M.signifyDone
    end
    seconds = tonumber(input)
    numbers = parseInput(input)
    isDone = false
    local timePassed = 0
    local timer = loop.new_timer()
    if #numbers > 0 then
        if #numbers == 1 then
            seconds = numbers[1]
        elseif #numbers == 2 then
            seconds = numbers[1] * 60 + numbers[2]
        elseif #numbers == 3 then
            seconds = numbers[1] * 3600 + numbers[2] * 60 + numbers[3]
        else
            error("Invalid number format, should be x:x:x")
        end
        timer:start(1000, 1000, vim.schedule_wrap(function()
            if timePassed >= seconds or isDone then
                timer:close()
                if not isDone then
                    doneCb()
                end
            end
            callback(timePassed)
            timePassed = timePassed + 1
        end))
    end
end

return M
