local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local utils = require "utils"

vim.lsp.set_log_level("error")
vim.keymap.set('n', "<leader>iht", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

local get_diagnostics = function()
    local diags = vim.lsp.diagnostic.get_all()
    for _, v in pairs(diags) do
        for i in pairs(v) do
            print(i, v[i])
        end
    end
end


local saga_status, lspsaga = pcall(require, "lspsaga")
if saga_status then
    lspsaga.setup {
        border_style = "rounded",
        lightbulb = {
            enable = false
        },
        -- Action keys should be:
        -- o/<cr>: open in current
        -- <c-x>: open in split
        -- <c-v>: open in vsplit
        -- They seem more complicated than the defaults but it's for consistency.
        keys = {
            split = "<c-x>",
            vsplit = "<c-v>",
            open = "<cr>",
        }
    }
end

local custom_attach = function()
    if saga_status then
        utils.map_allbuf("n", "Kk", "<cmd>Lspsaga hover_doc<CR>")
        utils.map_allbuf("n", "Kd", "<cmd>Lspsaga peek_definition<CR>")
        utils.map_allbuf("n", "Kt", "<cmd>Lspsaga peek_type_definition<CR>")
        utils.map_allbuf("n", "gd", "<cmd>Lspsaga finder<CR>")
        utils.map_allbuf("n", "<leader>ac", "<cmd>Lspsaga code_action<CR>")
        utils.map_allbuf("n", "<leader>ee", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
        utils.map_allbuf("n", "]g", "<cmd>Lspsaga diagnostic_jump_next<CR>")
        utils.map_allbuf("n", "[g", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        utils.map_allbuf("n", "<leader>ar", "<cmd>Lspsaga rename<CR>")
    end
    utils.map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    utils.map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    utils.map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    utils.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    utils.map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    utils.map("n", "<leader>gw", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
    utils.map("n", "<leader>gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
    utils.map("n", "<leader>ah", "<cmd>lua vim.lsp.buf.hover()<CR>")
    utils.map("n", "<leader>ai", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>")
    utils.map("n", "<leader>ao", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>")
    utils.map("n", "]q", ":cnext<CR>")
    utils.map("n", "[q", ":cprev<CR>")
    utils.map("n", "]h", ":ClangdSwitchSourceHeader<CR>")

    --> formatting
    utils.map("n", "=f",
        "<cmd>lua vim.lsp.buf.format{ async = true, formatting_options = { style = 'file' } }<CR>")
end

vim.fn.sign_define("LspDiagnosticsSignError",
    { text = "", numhl = "LspDiagnosticsDefaultError" })
vim.fn.sign_define("LspDiagnosticsSignWarning",
    { text = "", numhl = "LspDiagnosticsDefaultWarning" })
vim.fn.sign_define("LspDiagnosticsSignInformation",
    { text = "", numhl = "LspDiagnosticsDefaultInformation" })
vim.fn.sign_define("LspDiagnosticsSignHint",
    { text = "", numhl = "LspDiagnosticsDefaultHint" })

local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has("win32") == 1 then
    system_name = "Windows"
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text only on Warning or above, override spacing to 2
        virtual_text = {
            spacing = 2,
            min = "Warning",
        },
        signs = false,
    }
)

local servers = {
    "rust_analyzer",
    "clangd",
    "ts_ls",
    "vimls",
    "bashls",
    "pylsp",
    "hls",
    "cmake",
    "lua_ls",
    "zls",
    "gopls"
}
local capabilities =
    require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities())
for _, s in ipairs(servers) do
    if (s == "clangd") then
        if system_name == "Linux" or "macOS" then
            nvim_lsp[s].setup {
                on_attach = custom_attach,
                cmd = { "clangd", "--resource-dir=" .. utils.valueOrDefault(vim.g.resource_dir, ""), "-j=5",
                    "--header-insertion=iwyu",
                    "--background-index" },
                capabilities = capabilities,
            }
        else
            nvim_lsp[s].setup {
                on_attach = custom_attach,
                capabilities = capabilities,
            }
        end
    elseif (s == "pylsp") then
        nvim_lsp[s].setup {
            on_attach = custom_attach,
            capabilities = capabilities,
            settings = {
                plugins = {
                    flake8 = {
                        enabled = true,
                    },
                    pycodestyle = {
                        enabled = true,
                        maxLineLength = 80
                    },
                    autopep8 = {
                        enabled = true
                    }
                },
                pythonVersion = "3.10",
            }
        }
    elseif (s == "lua_ls") then
        nvim_lsp[s].setup {
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    -- Make the server aware of Neovim runtime files
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                            -- Depending on the usage, you might want to add additional paths here.
                            -- "${3rd}/luv/library"
                            -- "${3rd}/busted/library",
                        }
                        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                        -- library = vim.api.nvim_get_runtime_file("", true)
                    }
                })
            end,
            settings = {
                Lua = {}
            },
            on_attach = custom_attach,
            capabilities = capabilities
        }
    else
        nvim_lsp[s].setup { on_attach = custom_attach, capabilities = capabilities, }
    end
end

return {
    get_diagnostics = get_diagnostics,
}
