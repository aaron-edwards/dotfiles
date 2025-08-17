local M = {
  SUB_IDX = {"₁","₂","₃","₄","₅","₆","₇","₈","₉","₁₀",
    "₁₁","₁₂","₁₃","₁₄","₁₅","₁₆","₁₇","₁₈","₁₉","₂₀"
  },
  HOME = os.getenv('HOME'),

  basename = function(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
  end,

  programs = {}
}

function string:start_with(start)
  return self:sub(1, #start) == start
end

function string:empty_nil() 
  if self == '' then
    return nil
  else
    return self
  end
end

M.split_dir = function(str)
  local fields = {}
  for field in str:gmatch('([^/]+)') do
    fields[#fields+1] = field
  end
  return fields
end

M.pritty_dir = function(dir)
  if #dir <= 1 then
    return dir
  elseif dir:start_with('.') then
    return string.sub(dir,1,2)
  else
    return string.sub(dir,1,1)
  end
end

M.pritty_path = function(dir)
  dir = dir:gsub("%"..M.HOME, "~")

  local dir_parts = M.split_dir(dir)

  local p_path = dir_parts[#dir_parts]

  for i=#dir_parts-1, 1, -1 do
    p_path = M.pritty_dir(dir_parts[i]) .. '/' .. p_path
  end

  return p_path
end

M.title_with_dir = function(icon, path_func)
  return function(wezterm, tab, pane)
    local tab_title = tab.tab_title
    if tab_title:empty_nil() == nil then
      local mux_pane = wezterm.mux.get_pane(pane.pane_id)
      local process_info = mux_pane:get_foreground_process_info()

      local dir = path_func and path_func(process_info) or process_info['cwd']
      if dir == '.' then
        dir = process_info['cwd']
      end
      tab_title = M.pritty_path(dir)
    end

    return icon .. ' ' .. tab_title
  end
end

M.programs['nvim'] = M.title_with_dir('', function(info) return info.argv[2] end) 
M.programs['zsh'] = M.title_with_dir('', nil) 
M.programs[''] = function(wezterm, tab, pane)
  local mux_pane = wezterm.mux.get_pane(pane.pane_id)
  local process_info = mux_pane:get_foreground_process_info()

  if process_info and process_info.name == 'sudo' then
    return '  ' .. (process_info.argv[2] or 'sudo')
  else
    return M.default(wezterm, tab, pane)
  end
end


M.default = function(wezterm, tab, pane)
  return '  ' .. (tab.tab_title:empty_nil() or M.basename(pane.foreground_process_name):empty_nil() or pane.title) 
end

function M.apply(config, wezterm, globals)
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local process = M.basename(pane.foreground_process_name)
    local custom_title = M.programs[process] or M.default
    local text = custom_title(wezterm, tab, pane)

    return {
      { Text = ' ' .. text .. ' ' .. M.SUB_IDX[tab.tab_index+1] },
    }

  end)
  return config
end

return M
