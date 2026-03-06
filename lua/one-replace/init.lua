local M = {}

function M.open_prompt()
    local buf = vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.4)
    local win_opts = {
        relative = 'editor',
        width = width,
        height = 1,
        row = vim.o.lines - 4,
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = " Replace: old/new ",
        title_pos = "center"
    }

    local win = vim.api.nvim_open_win(buf, true, win_opts)
    vim.cmd("startinsert")

    local function execute_and_close()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
        local input = lines[1] or ""

        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.cmd("stopinsert")

        if input ~= "" then
            local cmd_str = "%s/" .. input .. "/gc"
            local ok, err = pcall(function()
                vim.cmd(cmd_str)
            end)
            if not ok then
                vim.notify("Replace Error: " .. err, vim.log.levels.ERROR)
            end
        end
    end

    local function cancel()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.cmd("stopinsert")
    end

    vim.keymap.set({ 'n', 'i' }, '<CR>', execute_and_close, { buffer = buf, silent = true })
    vim.keymap.set({ 'n', 'i' }, '<Esc>', cancel, { buffer = buf, silent = true })
    vim.keymap.set('n', 'q', cancel, { buffer = buf, silent = true })
end

function M.setup(opts)
    --i'll add defaults later
    opts = opts or {}
end

return M
