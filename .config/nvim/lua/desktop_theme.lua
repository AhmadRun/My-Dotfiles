local M = {}
local path = vim.fn.stdpath('config') .. '/omarchy-palette.json'
local previous
local function mix(a, b, t)
  local out = '#'
  for i = 2, 6, 2 do
    local x, y = tonumber(a:sub(i, i + 1), 16), tonumber(b:sub(i, i + 1), 16)
    out = out .. string.format('%02x', math.floor(x + (y - x) * t + 0.5))
  end
  return out
end
function M.reload()
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return end
  local raw = table.concat(lines, '\n')
  if raw == previous then return end
  local parsed, p = pcall(vim.json.decode, raw)
  if not parsed or type(p) ~= 'table' then return end
  for _, key in ipairs({ 'background', 'foreground', 'accent', 'color1', 'color2', 'color3', 'color4', 'color5', 'color6' }) do
    if type(p[key]) ~= 'string' or not p[key]:match('^#%x%x%x%x%x%x$') then return end
  end
  local bg, fg, ac = p.background, p.foreground, p.accent
  local r, g, b = tonumber(bg:sub(2,3),16), tonumber(bg:sub(4,5),16), tonumber(bg:sub(6,7),16)
  vim.opt.background = (0.299*r + 0.587*g + 0.114*b > 140) and 'light' or 'dark'
  vim.cmd('highlight clear')
  vim.g.colors_name = 'omarchy'
  for i = 0, 15 do vim.g['terminal_color_' .. i] = p['color' .. i] end
  local surface, muted = mix(bg, fg, 0.12), mix(bg, fg, 0.48)
  local function hl(names, spec)
    for name in names:gmatch('%S+') do vim.api.nvim_set_hl(0, name, spec) end
  end
  hl('Normal NormalNC NormalFloat SignColumn EndOfBuffer WinBar WinBarNC', { fg = fg })
  hl('LineNr Comment NonText Whitespace', { fg = muted })
  hl('CursorLineNr FloatBorder Directory Title', { fg = ac })
  hl('CursorLine ColorColumn StatusLineNC', { bg = surface })
  hl('Visual PmenuSel', { bg = mix(bg, ac, 0.35), fg = fg })
  hl('Pmenu StatusLine TabLine', { bg = surface, fg = fg })
  hl('TabLineSel Search IncSearch', { bg = ac, fg = bg })
  hl('String Character', { fg = p.color2 })
  hl('Number Boolean Float Constant', { fg = p.color3 })
  hl('Function Identifier', { fg = p.color4 })
  hl('Statement Conditional Repeat Keyword Operator Exception', { fg = p.color5 })
  hl('Type StorageClass Structure Typedef PreProc Special', { fg = p.color6 })
  hl('Error ErrorMsg DiagnosticError', { fg = p.color1 })
  hl('WarningMsg DiagnosticWarn', { fg = p.color3 })
  hl('DiagnosticInfo', { fg = p.color4 })
  hl('DiagnosticHint', { fg = p.color6 })
  hl('DiffAdd', { bg = mix(bg, p.color2, 0.2) })
  hl('DiffChange', { bg = mix(bg, p.color4, 0.2) })
  hl('DiffDelete', { fg = p.color1, bg = mix(bg, p.color1, 0.2) })
  hl('DiffText', { bg = mix(bg, p.color4, 0.4) })
  hl('SnacksDashboardHeader SnacksDashboardIcon SnacksDashboardKey', { fg = ac, bold = true })
  hl('MiniStatuslineModeNormal', { fg = bg, bg = ac, bold = true })
  hl('MiniStatuslineModeInsert', { fg = bg, bg = p.color2, bold = true })
  hl('MiniStatuslineModeVisual', { fg = bg, bg = p.color5, bold = true })
  hl('MiniStatuslineDevinfo MiniStatuslineFileinfo MiniStatuslineFilename MiniStatuslineInactive', { fg = fg, bg = surface })
  previous = raw
  vim.api.nvim_exec_autocmds('ColorScheme', { pattern = 'omarchy' })
  vim.cmd('redraw')
end
function M.setup()
  M.reload()
  local timer = vim.uv.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(M.reload))
  local group = vim.api.nvim_create_augroup('DesktopTheme', { clear = true })
  vim.api.nvim_create_autocmd('FocusGained', { group = group, callback = M.reload })
  vim.api.nvim_create_autocmd('VimLeavePre', { group = group, once = true, callback = function()
    timer:stop()
    timer:close()
  end })
end
return M
