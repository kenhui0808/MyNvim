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
    --"kyazdani42/nvim-web-devicons",
    "nvim-tree/nvim-web-devicons",
    after = "nvim-base16.lua",
    config = config_require("plugins.configs.icons", "setup"),
  },

  {
    "feline-nvim/feline.nvim",
    after = "nvim-web-devicons",
    config = config_require("plugins.configs.statusline", "setup"),
  },

  {
    "akinsho/bufferline.nvim",
    after = "nvim-web-devicons",
    config = config_require("plugins.configs.bufferline", "setup"),
    setup = function()
      require("core.mappings").bufferline()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = config_require("plugins.configs.others", "blankline"),
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = config_require("plugins.configs.others", "colorizer"),
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile" },
    config = config_require("plugins.configs.treesitter", "setup"),
    run = ":TSUpdate",
  },

  {
    "lewis6991/gitsigns.nvim",
    opt = true,
    config = config_require("plugins.configs.others", "gitsigns"),
    setup = function()
      require("core.utils").packer_lazy_load "gitsigns.nvim"
    end,
  },

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
    "MunifTanjim/nui.nvim",
    after = "nvim-lspconfig",
  },

  --{
  --  "ShinKage/idris2-nvim",
  --  after = "nui.nvim",
  --  config = config_require("plugins.configs.idris2", "setup"),
  --},

  {
    "ray-x/lsp_signature.nvim",
    after = "nvim-lspconfig",
    config = config_require("plugins.configs.others", "signature"),
  },

  {
    "andymass/vim-matchup",
    opt = true,
    setup = function()
      require("core.utils").packer_lazy_load "vim-matchup"
    end,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    config = config_require("plugins.configs.others", "better_escape"),
  },

  {
    "rafamadriz/friendly-snippets",
    module = "cmp_nvim_lsp",
    event = "InsertEnter",
  },

  {
    "hrsh7th/nvim-cmp",
    after = "friendly-snippets",
    config = config_require("plugins.configs.cmp", "setup"),
  },

  {
    "L3MON4D3/LuaSnip",
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = config_require("plugins.configs.others", "luasnip"),
  },

  {
    "saadparwaiz1/cmp_luasnip",
    after = options.cmp.lazy_load and "LuaSnip",
  },

  {
    "hrsh7th/cmp-nvim-lua",
    after = "cmp_luasnip",
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    after = "cmp-nvim-lua",
  },

  {
    "hrsh7th/cmp-buffer",
    after = "cmp-nvim-lsp",
  },

  {
    "hrsh7th/cmp-path",
    after = "cmp-buffer",
  },

  {
    "windwp/nvim-autopairs",
    after = options.autopairs.loadAfter,
    config = config_require("plugins.configs.others", "autopairs"),
  },

  {
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = { "gcc" },
    config = config_require("plugins.configs.others", "comment"),
    setup = function()
      require("core.mappings").comment()
    end,
  },

  {
    "kyazdani42/nvim-tree.lua",
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
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    setup = function()
      vim.g.mkdp_page_title = '${name}'
      vim.g.mkdp_theme = 'light'
    end,
  },
}

-- label plugins for operational assistance
plugins = require("core.utils").label_plugins(plugins)

return packer.startup(function(use)
  for _, v in pairs(plugins) do
    use(v)
  end
end)
