local nvim_lsp = require'lspconfig'
local configs = require'lspconfig/configs'

local map = function(type, key, value)
    vim.fn.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

local get_diagnostics = function()
    local diags = vim.lsp.diagnostic.get_all()
    for k,v in pairs(diags) do
        for i in pairs(v) do
            print(i, v[i])
        end
    end
end

local custom_attach = function(client)
    print("LSP started.");
    require'completion'.on_attach(client)
    -- require('folding').on_attach()
    -- require'diagnostic'.on_attach(client)

    map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
    map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n','gr','<cmd>lua vim.lsp.buf.references()<CR>')
    map('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n','<leader>gw','<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
    map('n','<leader>ah','<cmd>lua vim.lsp.buf.hover()<CR>')
    map('n','<leader>ac','<cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n','<leader>ee','<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    map('n','<leader>ar','<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n','<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    map('n','<leader>ai','<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
    map('n','<leader>ao','<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
    map('n','[q',':cnext<CR>')
    map('n',']q',':cprev<CR>')
    map('n',']g','<cmd>lua vim.lsp.diagnostic.goto_next({ enable_popup = false })<CR>')
    map('n','[g','<cmd>lua vim.lsp.diagnostic.goto_prev({ enable_popup = false })<CR>')
    map('n',']h',':ClangdSwitchSourceHeader<CR>')
end

local servers = {'clangd', 'pyls'}
for _, s in ipairs(servers) do
    nvim_lsp[s].setup{on_attach=custom_attach}
end
-- nvim_lsp.clangd.setup{on_attach=custom_attach}
-- nvim_lsp.pyls.setup{on_attach=custom_attach}

return {
    get_diagnostics = get_diagnostics,
}
