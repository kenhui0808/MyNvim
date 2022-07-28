local options = require("core.configs").plugins.options
local present, packer = pcall(require, options.packer.init_file)

if not present then
  return false
end

local config_require = require("core.utils").config_require

local plugins = {
  { "nvim-lua/plenary.nvim" },
  { "lewis6991/impatient.nvim" },
  { "nathom/filetype.nvim" },

  {
    "wbthomason/packer.nvim",
    event = "VimEnter",
  },

  {
    "huiwaikwan/nvim-base16.lua",
    after = "packer.nvim",
    config = function()
      require("colors").init()
    end,
  },

  {
    "kyazdani42/nvim-web-devicons",
    after = "nvim-base16.lua",
    config = config_require("plugins.configs.icons", "setup"),
  },

  {
    "feline-nvim/feline.nvim",
    -- disable = not plugin_settings.status.feline,
    after = "nvim-web-devicons",
    config = config_require("plugins.configs.statusline", "setup"),
  },

  {
    "akinsho/bufferline.nvim",
    -- disable = not plugin_settings.status.bufferline,
    after = "nvim-web-devicons",
    config = config_require("plugins.configs.bufferline", "setup"),
    setup = function()
      require("core.mappings").bufferline()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    -- disable = not plugin_settings.status.blankline,
    event = "BufRead",
    config = config_require("plugins.configs.others", "blankline"),
  },

  {
    "norcalli/nvim-colorizer.lua",
    -- disable = not plugin_settings.status.colorizer,
    event = "BufRead",
    config = config_require("plugins.configs.others", "colorizer"),
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile" },
    config = config_require("plugins.configs.treesitter", "setup"),
    run = ":TSUpdate",
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    -- disable = not plugin_settings.status.gitsigns,
    opt = true,
    config = config_require("plugins.configs.others", "gitsigns"),
    setup = function()
      require("core.utils").packer_lazy_load "gitsigns.nvim"
    end,
  },

  -- lsp stuff
  {
    "neovim/nvim-lspconfig",
    module = "lspconfig",
    opt = true,
    setup = function()
      require("core.utils").packer_lazy_load "nvim-lspconfig"
      -- reload the current file so lsp actually starts for it
      vim.defer_fn(function()
        vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
      end, 0)
    end,
    config = config_require("plugins.configs.lspconfig"),
  },

  {
    "ray-x/lsp_signature.nvim",
    -- disable = not plugin_settings.status.lspsignature,
    after = "nvim-lspconfig",
    config = config_require("plugins.configs.others", "signature"),
  },

  {
    "andymass/vim-matchup",
    -- disable = not plugin_settings.status.vim_matchup,
    opt = true,
    setup = function()
      require("core.utils").packer_lazy_load "vim-matchup"
    end,
  },

  {
    "max397574/better-escape.nvim",
    -- disable = not plugin_settings.status.better_escape,
    event = "InsertCharPre",
    config = config_require("plugins.configs.others", "better_escape"),
  },

  -- load luasnips + cmp related in insert mode only

  {
    "rafamadriz/friendly-snippets",
    module = "cmp_nvim_lsp",
    -- disable = not plugin_settings.status.cmp,
    event = "InsertEnter",
  },

  {
    "hrsh7th/nvim-cmp",
    -- disable = not plugin_settings.status.cmp,
    after = "friendly-snippets",
    config = config_require("plugins.configs.cmp", "setup"),
  },

  {
    "L3MON4D3/LuaSnip",
    -- disable = not plugin_settings.status.cmp,
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = config_require("plugins.configs.others", "luasnip"),
  },

  {
    "saadparwaiz1/cmp_luasnip",
    -- disable = not plugin_settings.status.cmp,
    after = options.cmp.lazy_load and "LuaSnip",
  },

  {
    "hrsh7th/cmp-nvim-lua",
    -- disable = not plugin_settings.status.cmp,
    after = "cmp_luasnip",
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    -- disable = not plugin_settings.status.cmp,
    after = "cmp-nvim-lua",
  },

  {
    "hrsh7th/cmp-buffer",
    -- disable = not plugin_settings.status.cmp,
    after = "cmp-nvim-lsp",
  },

  {
    "hrsh7th/cmp-path",
    -- disable = not plugin_settings.status.cmp,
    after = "cmp-buffer",
  },

  -- misc plugins
  {
    "windwp/nvim-autopairs",
    -- disable = not plugin_settings.status.autopairs,
    after = options.autopairs.loadAfter,
    config = config_require("plugins.configs.others", "autopairs"),
  },

  {
    "numToStr/Comment.nvim",
    -- disable = not plugin_settings.status.comment,
    module = "Comment",
    keys = { "gcc" },
    config = config_require("plugins.configs.others", "comment"),
    setup = function()
      require("core.mappings").comment()
    end,
  },

  -- file managing, picker etc
  {
    "kyazdani42/nvim-tree.lua",
    -- disable = not plugin_settings.status.nvimtree,
    -- only set "after" if lazy load is disabled and vice versa for "cmd"
    after = not options.nvimtree.lazy_load and "nvim-web-devicons",
    cmd = options.nvimtree.lazy_load and { "NvimTreeToggle", "NvimTreeFindFile" },
    config = config_require("plugins.configs.nvimtree", "setup"),
    setup = function()
      require("core.mappings").nvimtree()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    module = "telescope",
    cmd = "Telescope",
    config = config_require("plugins.configs.telescope", "setup"),
    setup = function()
      require("core.mappings").telescope()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    setup = function()
      vim.g.mkdp_page_title = '${name}'
      vim.g.mkdp_theme = 'light'
    end,
    -- ft = { "markdown" },
  },
}

--label plugins for operational assistance
plugins = require("core.utils").label_plugins(plugins)

return packer.startup(function(use)
  for _, v in pairs(plugins) do
    use(v)
  end
end)
