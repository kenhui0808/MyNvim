local M = {}

local cmd = vim.cmd

M.close_window = function()
  local wins = vim.fn.gettabinfo(vim.fn.tabpagenr())[1].windows

  if #wins > 2 then
    vim.cmd("close")
    return
  end

  if #wins == 2 then
    for _, win in ipairs(wins) do
      local buf = vim.fn.getwininfo(win)[1].bufnr
      if vim.fn.getbufvar(buf, "&filetype") == "NvimTree" then
        -- ignore if NvimTree is showing
        return
      end
    end
    vim.cmd("close")
  end
end

M.close_buffer = function()
  -- Check if is a terminal buffer
  local function is_terminal_buf(buf)
    if vim.fn.getbufvar(buf, "&buftype") == "terminal" then
      return true
    else
      return false
    end
  end

  -- Switch to buffer 'buf' on each tabpage each window from list 'windows'
  local function switch_buffer(windows, buf)
    local cur_tab = vim.fn.tabpagenr()
    local cur_win = vim.fn.winnr()
    for _, winid in ipairs(windows) do
      winid = tonumber(winid) or 0
      if winid > 0 then
        local tabwin = vim.fn.win_id2tabwin(winid)
        local tab = tonumber(tabwin[1])
        local win = tonumber(tabwin[2])
        vim.cmd(string.format("tabn %d", tab))
        vim.cmd(string.format("%d wincmd w", win))
        vim.cmd(string.format("buffer %d", buf))
      end
    end
    -- return to original window
    vim.cmd(string.format("tabn %d", cur_tab))
    vim.cmd(string.format("%d wincmd w", cur_win))
  end

  local cur_buf = vim.fn.bufnr()

  if vim.fn.buflisted(cur_buf) == 0 then
    -- ignore nobl buffer
    return
  end

  if is_terminal_buf(cur_buf) then
    for buf = 1, vim.fn.bufnr("$") do
      if not is_terminal_buf(buf) and  vim.fn.buflisted(buf) == 1 then
        vim.cmd(string.format("buffer %d", buf))
        return
      end
    end
    vim.cmd("enew")
    return
  end
 
  local wins = vim.fn.getbufinfo(cur_buf)[1].windows
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  local buf_count = 0
  for _, buf in ipairs(bufs) do
    if not is_terminal_buf(buf.bufnr) then
      buf_count = buf_count + 1
    end
  end

  if buf_count <= 1 then
    -- ignore last buffer
    return
  end

  if cur_buf == bufs[#bufs].bufnr then
    vim.cmd("BufferLineCyclePrev")
  else
    vim.cmd("BufferLineCycleNext")
  end

  local switch_buf = vim.fn.bufnr()
  switch_buffer(wins, switch_buf)
  vim.cmd(string.format("silent! confirm bd %d", cur_buf))
end

M.map = function(mode, keys, command, opt)
  local options = { noremap = true, silent = true }
  if opt then
    options = vim.tbl_extend("force", options, opt)
  end

  -- all valid modes allowed for mappings
  -- :h map-modes
  local valid_modes = {
    [""] = true,
    ["n"] = true,
    ["v"] = true,
    ["s"] = true,
    ["x"] = true,
    ["o"] = true,
    ["!"] = true,
    ["i"] = true,
    ["l"] = true,
    ["c"] = true,
    ["t"] = true,
  }

  -- helper function for M.map
  -- can gives multiple modes and keys
  local function map_wrapper(sub_mode, lhs, rhs, sub_options)
    if type(lhs) == "table" then
      for _, key in ipairs(lhs) do
        map_wrapper(sub_mode, key, rhs, sub_options)
      end
    else
      if type(sub_mode) == "table" then
        for _, m in ipairs(sub_mode) do
          map_wrapper(m, lhs, rhs, sub_options)
        end
      else
        if valid_modes[sub_mode] and lhs and rhs then
          vim.api.nvim_set_keymap(sub_mode, lhs, rhs, sub_options)
        else
          sub_mode, lhs, rhs = sub_mode or "", lhs or "", rhs or ""
          print(
            "Cannot set mapping [ mode = '" .. sub_mode .. "' | key = '" .. lhs .. "' | cmd = '" .. rhs .. "' ]"
          )
        end
      end
    end
  end

  map_wrapper(mode, keys, command, options)
end

-- load plugin after entering vim ui
M.packer_lazy_load = function(plugin, timer)
  if plugin then
    timer = timer or 0
    vim.defer_fn(function()
      require("packer").loader(plugin)
    end, timer)
  end
end

-- Highlights functions

-- Define bg color
-- @param group Group
-- @param color Color

M.bg = function(group, col)
  cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
M.fg = function(group, col)
  cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
M.fg_bg = function(group, fgcol, bgcol)
  cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

-- Config of a plugin based on the path provided in the plugins/configs
-- Arguments:
--  1st - name of plugin
--  2nd - default config path
--  3rd - optional function name which will called from default_config path
--  e.g: if given args - "telescope", "plugins.configs.telescope", "setup"
--      then return "require('plugins.configs.telescope').setup()"
--      if 3rd arg not given, then return "require('plugins.configs.telescope')"
M.config_require = function(name, config_path, config_function)
  local result = config_path
  result = "('" .. result .. "')"
  if type(config_function) == "string" and config_function ~= "" then
    -- add the . to call the functions and concatenate true or false as argument
    result = result .. "." .. config_function .. "()"
  end
  return "require" .. result
end

-- provide labels to plugins instead of integers
M.label_plugins = function(plugins)
  local plugins_labeled = {}
  for _, plugin in ipairs(plugins) do
    plugins_labeled[plugin[1]] = plugin
  end
  return plugins_labeled
end

return M
