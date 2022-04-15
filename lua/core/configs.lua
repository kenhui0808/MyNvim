local M = {}

M.options = {
  -- general nvim/vim options , check :h optionname to know more about an option
  clipboard = "",
  cmdheight = 1,
  ruler = false,
  hidden = true,
  ignorecase = true,
  smartcase = true,
  mapleader = " ",
  mouse = "",
  number = true,
  numberwidth = 2,
  relativenumber = false,
  expandtab = true,
  shiftwidth = 2,
  smartindent = false,
  tabstop = 2,
  timeoutlen = 400,
  updatetime = 500,
  undofile = false,
  fillchars = { eob = " " },
  shadafile = vim.opt.shadafile,

  settings = {
    copy_cut = true, -- copy cut text ( x key ), visual and normal mode
    copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
    insert_nav = true, -- navigation in insertmode
    window_nav = true,
  },
}

---- UI -----

M.ui = {
  theme = "onebright",
  italic_comments = false,

  -- path of your file that contains highlights
  hl_override = "",

  -- Change terminal bg to nvim theme's bg color so it'll match well
  transparency = false,
}

---- PLUGIN OPTIONS ----

M.plugins = {
  -- enable/disable plugins (false for disable)
  status = {
    autopairs = true,
    better_escape = true, -- map to <ESC> with no lag
    blankline = true, -- indentline stuff
    bufferline = true, -- manage and preview opened buffers
    cmp = true,
    colorizer = true, -- color RGB, HEX, CSS, NAME color codes
    comment = true, -- easily (un)comment code, language aware
    feline = true, -- statusline
    gitsigns = true,
    lspsignature = true, -- lsp enhancements
    nvimtree = true,
    vim_matchup = true, -- improved matchit
  },

  options = {
    autopairs = { loadAfter = "nvim-cmp" },
    cmp = {
      lazy_load = true,
    },
    esc_insertmode_timeout = 300,
    lspconfig = {
      servers = {
        tsserver = true,  -- npm i -g typescript typescript-language-server
        eslint = true,  -- npm i -g vscode-langservers-extracted
        cssls = true, -- npm i -g vscode-langservers-extracted
        emmet_ls = true, -- npm i -g emmet-ls
        stylelint_lsp = true, -- npm i -g stylelint-lsp
      },
      filetypes = {
        emmet_ls = { "html", "javascriptreact", "typescriptreact" },
        stylelint_lsp = { "css", "less", "scss", "sugarss", "wxss" },
      },
    },
    luasnip = {
      snippet_path = {},
    },
    nvimtree = {
      -- packerCompile required after changing lazy_load
      lazy_load = true,
    },
    packer = {
      init_file = "plugins.packer_init",
    },
    statusline = {
      shortline = true, -- truncate statusline on small screens
      style = "block", -- default, round , slant , block , arrow
    },
  },
}

--- MAPPINGS ----

-- non plugin
M.mappings = {

  -- custom user mappings
  misc = {
    close_buffer = "<S-c>",
    close_window = "<S-w>",
    cp_selection = "<Leader>y", -- copy all contents of current buffer
    cp_whole_file = "<C-a>", -- copy all contents of current buffer
    line_number_toggle = "<leader>n",
    new_buffer = "<S-b>",
    new_tabpage = "<S-Tab>",
    next_tabpage = "<S-Right>",
    prev_tabpage = "<S-Left>",
    close_tabpage = "<leader>c",
    split_horizontal = "<C-x>",
    split_vertical = "<C-y>",
    window_resize_up = "<C-Up>",
    window_resize_down = "<C-Down>",
    window_resize_left = "<C-Left>",
    window_resize_right = "<C-Right>",
    move_line_up = "<S-Up>",
    move_line_down = "<S-Down>",
  },

  -- navigation in insert mode, only if enabled in options

  insert_nav = {
    backward = "<C-h>",
    beginning_of_line = "<C-b>",
    end_of_line = "<C-e>",
    forward = "<C-l>",
    next_line = "<C-k>",
    prev_line = "<C-j>",
  },

  -- better window movement
  window_nav = {
    moveLeft = "<C-h>",
    moveRight = "<C-l>",
    moveUp = "<C-k>",
    moveDown = "<C-j>",
  },

  -- terminal related mappings
  terminal = {
    -- get out of terminal mode
    esc_termmode = { "jk" },

    -- spawn terminals
    new_terminal = "<S-t>",
  },
}

-- plugins related mappings
-- To disable a mapping, equate the variable to "" or false or nil
M.mappings.plugins = {
  bufferline = {
    next_buffer = ">",
    prev_buffer = "<",
  },

  comment = {
    toggle = "<leader>/",
  },

  -- map to <ESC> with no lag
  better_escape = { -- <ESC> will still work
    esc_insertmode = { "jk" }, -- multiple mappings allowed
  },

  lspconfig = {
    declaration = "gD",
    definition = "gd",
    hover = "K",
    implementation = "gi",
    signature_help = "gk",
    type_definition = "<leader>D",
    rename = "<leader>rn",
    references = "gr",
    float_diagnostics = "ge",
    goto_prev = "[g",
    goto_next = "]g",
    formatting = "<leader>fm",
  },

  nvimtree = {
    toggle = "<C-t>",
    focus = "<S-f>",
  },

  telescope = {
    -- buffers = "<leader>fb",
    buffers = "<C-b>",
    -- find_files = "<leader>ff",
    find_files = "<C-f>",
    find_hiddenfiles = "<leader>fi",
    git_commits = "<leader>gc",
    git_status = "<leader>gs",
    help_tags = "<leader>fh",
    -- live_grep = "<leader>fw",
    live_grep = "<C-g>",
    oldfiles = "<leader>fo",
  },
}

return M
