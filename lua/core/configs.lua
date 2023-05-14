local M = {}

M.options = {
  -- general nvim/vim options , check :h optionname to know more about an option
  clipboard = "unnamedplus",
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
  smartindent = true,
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
  options = {
    autopairs = { loadAfter = "nvim-cmp" },
    cmp = {
      lazy_load = true,
    },
    esc_insertmode_timeout = 300,
    lspconfig = {
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      servers = {
        tsserver = true,  -- npm i -g typescript typescript-language-server
        eslint = true,  -- npm i -g vscode-langservers-extracted
        html = true, -- npm i -g vscode-langservers-extracted
        cssls = true, -- npm i -g vscode-langservers-extracted
        jsonls = true, -- npm i -g vscode-langservers-extracted
        emmet_ls = true, -- npm i -g emmet-ls
        stylelint_lsp = true, -- npm i -g stylelint-lsp
      },
      formatting = {
        tsserver = true,
        stylelint_lsp = true,
      },
      settings = {
        stylelint_lsp = {
          stylelintplus = {
            autoFixOnFormat = true,
          },
        },
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
M.mappings = {
  -- custom user mappings
  misc = {
    line_number_toggle = "<leader>n",
    -- copy
    cp_selection = "<leader>y",
    cp_whole_file = "<leader>a",
    -- move
    move_line_up = "<S-Up>",
    move_line_down = "<S-Down>",
    -- buffer
    new_buffer = "<S-b>",
    close_buffer = "<S-c>",
    -- tab
    next_tabpage = "<leader>.",
    prev_tabpage = "<leader>,",
    new_tabpage = "<leader>t",
    close_tabpage = "<leader>c",
    -- window
    split_horizontal = "<C-x>",
    split_vertical = "<C-y>",
    window_resize_up = "<C-Up>",
    window_resize_down = "<C-Down>",
    window_resize_left = "<C-Left>",
    window_resize_right = "<C-Right>",
    close_window = "<C-c>",
  },

  -- navigation in insert mode, only if enabled in options
  insert_nav = {
    backward = "<C-h>",
    forward = "<C-l>",
    next_line = "<C-k>",
    prev_line = "<C-j>",
    beginning_of_line = "<C-b>",
    end_of_line = "<C-e>",
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
    -- spawn terminals
    new_terminal = "<S-t>",
    -- get out of terminal mode
    esc_termmode = { "jk" },
  },
}

-- plugins related mappings
-- To disable a mapping, equate the variable to "" or false or nil
M.mappings.plugins = {
  bufferline = {
    next_buffer = ">",
    prev_buffer = "<",

    buffer_move_left = "_",
    buffer_move_right = "+",
  },

  comment = {
    toggle = "<leader>/",
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
    focus = "<C-f>",
  },

  telescope = {
    buffers = "<leader>fb",
    find_files = "<leader>ff",
    find_hiddenfiles = "<leader>fi",
    git_commits = "<leader>gc",
    git_status = "<leader>gs",
    help_tags = "<leader>fh",
    live_grep = "<leader>fw",
    oldfiles = "<leader>fo",
  },
}

return M
