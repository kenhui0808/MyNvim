local M = {}

require("plugins.configs.others").lsp_handlers()

local function buf_set_option(...)
  vim.api.nvim_buf_set_option(bufnr, ...)
end

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  require("core.mappings").lspconfig()
end

local function on_attach_enable_formatting(client, bufnr)
  -- Enable formatting
  client.resolved_capabilities.document_formatting = true
  client.resolved_capabilities.document_range_formatting = true

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  require("core.mappings").lspconfig()
end

local function setup_lsp(capabilities)
  local lspconfig = require "lspconfig"

  -- lspservers with core/configs
  local servers = require("core.configs").plugins.options.lspconfig.servers
  local formatting = require("core.configs").plugins.options.lspconfig.formatting
  local settings = require("core.configs").plugins.options.lspconfig.settings
  local filetypes = require("core.configs").plugins.options.lspconfig.filetypes

  for lsp, status in pairs(servers) do
    if status then
      local attach = on_attach
      if formatting[lsp] then
        attach = on_attach_enable_formatting
      end
      local configs = {
        on_attach = attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }
      if settings[lsp] then
        configs.settings = {}
        for k, v in pairs(settings[lsp]) do
          configs.settings[k] = v
        end
      end
      if filetypes[lsp] then
        configs.filetypes = filetypes[lsp]
      end
      lspconfig[lsp].setup(configs)
    end
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

setup_lsp(capabilities)

return M
