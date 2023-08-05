local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local configs = require "lspconfig/configs"
local utils = require "utils"

-- formatter
local futil = require "formatter.util"

require "formatter".setup {
    filetype = {
        python = {
            function()
                local black = {
                    exe = "black",
                    args = {
                        "--line-length 79"
                    }
                }
                local autopep8 = {
                    exe = "autopep8",
                    args = {
                        "--max-line-length 79",
                        "--hang-closing",
                        "--aggressive",
                        "--in-place",

                    }
                }
                return autopep8
            end
        },
        lua = {
            require "formatter.filetypes.lua".stylelua,
        },
        cpp = {
            function()
                return {
                    exe = "bde-format-11",
                    args = {

                    }
                }
            end
        },
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace
        }
    }
}

vim.lsp.set_log_level("error")

local get_diagnostics = function()
    local diags = vim.lsp.diagnostic.get_all()
    for _, v in pairs(diags) do
        for i in pairs(v) do
            print(i, v[i])
        end
    end
end



local custom_attach = function(client)
    utils.map("n", "=f",
        "<cmd>lua vim.lsp.buf.format{ async = true, formatting_options = { file = '~/.clang-format', tabSize = 4, insertSpaces = true, trimTrailingWhitespace = true,} }<CR>")
    utils.map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    -- utils.map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    -- utils.map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    -- utils.map("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    -- utils.map("n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()<CR>")
    -- utils.map("n", "<leader>ar", "<cmd>lua require('utils').rename()<CR>")
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

    require "lsp_signature".on_attach({
        hint_prefix = "=> ",
        floating_window = false,
    })
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
            severity_limit = "Warning",
        },
        signs = false,
    }
)

local servers = {
    "rust_analyzer",
    "clangd",
    "tsserver",
    "vimls",
    "bashls",
    "pyright",
    "hls",
    "cmake",
    "lua_ls"
}
local capabilities =
    require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities())
for _, s in ipairs(servers) do
    if (s == "clangd") then
        if system_name == "Linux" then
            nvim_lsp[s].setup {
                on_attach = custom_attach,
                cmd = { "clangd", "--resource-dir=" .. vim.g.resource_dir, "-j=5", "--header-insertion=iwyu",
                    "--background-index", "--enable-config" },
                capabilities = capabilities,
            }
        else
            nvim_lsp[s].setup {
                on_attach = custom_attach,
                capabilities = capabilities,
            }
        end
    elseif (s == "pyright") then
        nvim_lsp[s].setup {
            on_attach = custom_attach,
            capabilities = capabilities,
            settings = {
                plugins = {
                    flake8 = {
                        enabled = true,
                    }
                }
            }
        }
    elseif (s == "lua_ls") then
        nvim_lsp[s].setup {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
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
