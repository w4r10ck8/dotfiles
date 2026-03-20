-- Duckbones colorscheme for Neovim
-- Ported from the Ghostty Duckbones theme

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.g.colors_name = "duckbones"
vim.o.termguicolors = true

local c = {
  bg        = "#0e101a",
  bg_dark   = "#080910",
  bg_hl     = "#1a1c2e",
  sel       = "#37382d",
  grey      = "#444860",
  fg        = "#ebefc0",
  fg_dim    = "#b3b692",
  red       = "#e03600",
  red_br    = "#ff4821",
  green     = "#5dcd97",
  green_br  = "#58db9e",
  yellow    = "#e39500",
  yellow_br = "#f6a100",
  blue      = "#00a3cb",
  blue_br   = "#00b4e0",
  purple    = "#795ccc",
  purple_br = "#b3a1e6",
  cyan      = "#00a3cb",
  cyan_br   = "#00b4e0",
  cursor    = "#edf2c2",
  none      = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Base
hi("Normal",          { fg = c.fg,       bg = c.bg })
hi("NormalFloat",     { fg = c.fg,       bg = c.bg_dark })
hi("NormalNC",        { fg = c.fg_dim,   bg = c.bg })
hi("ColorColumn",     {                  bg = c.bg_hl })
hi("CursorLine",      {                  bg = c.bg_hl })
hi("CursorColumn",    {                  bg = c.bg_hl })
hi("Cursor",          { fg = c.bg,       bg = c.cursor })
hi("TermCursor",      { fg = c.bg,       bg = c.cursor })
hi("LineNr",          { fg = c.grey })
hi("CursorLineNr",    { fg = c.yellow,   bold = true })
hi("SignColumn",      { fg = c.grey,     bg = c.bg })
hi("FoldColumn",      { fg = c.grey,     bg = c.bg })
hi("Folded",          { fg = c.fg_dim,   bg = c.bg_hl })
hi("VertSplit",       { fg = c.grey })
hi("WinSeparator",    { fg = c.grey })
hi("MatchParen",      { fg = c.cyan_br,  bold = true, underline = true })

-- Selection / Search
hi("Visual",          {                  bg = c.sel })
hi("VisualNOS",       {                  bg = c.sel })
hi("Search",          { fg = c.bg,       bg = c.yellow })
hi("IncSearch",       { fg = c.bg,       bg = c.yellow_br, bold = true })
hi("CurSearch",       { fg = c.bg,       bg = c.yellow_br, bold = true })
hi("Substitute",      { fg = c.bg,       bg = c.red_br })

-- Statusline / Tabline
hi("StatusLine",      { fg = c.fg,       bg = c.bg_dark })
hi("StatusLineNC",    { fg = c.grey,     bg = c.bg_dark })
hi("TabLine",         { fg = c.grey,     bg = c.bg_dark })
hi("TabLineFill",     {                  bg = c.bg_dark })
hi("TabLineSel",      { fg = c.fg,       bg = c.bg,    bold = true })

-- Popup menu
hi("Pmenu",           { fg = c.fg,       bg = c.bg_dark })
hi("PmenuSel",        { fg = c.fg,       bg = c.sel,   bold = true })
hi("PmenuSbar",       {                  bg = c.bg_dark })
hi("PmenuThumb",      {                  bg = c.grey })

-- Syntax
hi("Comment",         { fg = c.grey,     italic = true })
hi("Constant",        { fg = c.purple_br })
hi("String",          { fg = c.green })
hi("Character",       { fg = c.green })
hi("Number",          { fg = c.yellow_br })
hi("Boolean",         { fg = c.yellow_br })
hi("Float",           { fg = c.yellow_br })
hi("Identifier",      { fg = c.fg })
hi("Function",        { fg = c.blue_br })
hi("Statement",       { fg = c.purple })
hi("Conditional",     { fg = c.purple })
hi("Repeat",          { fg = c.purple })
hi("Label",           { fg = c.purple })
hi("Operator",        { fg = c.cyan })
hi("Keyword",         { fg = c.purple,   bold = true })
hi("Exception",       { fg = c.red_br })
hi("PreProc",         { fg = c.cyan })
hi("Include",         { fg = c.cyan })
hi("Define",          { fg = c.cyan })
hi("Macro",           { fg = c.cyan })
hi("Type",            { fg = c.blue })
hi("StorageClass",    { fg = c.blue })
hi("Structure",       { fg = c.blue })
hi("Typedef",         { fg = c.blue })
hi("Special",         { fg = c.cyan_br })
hi("SpecialChar",     { fg = c.cyan_br })
hi("Delimiter",       { fg = c.fg_dim })
hi("Underlined",      { underline = true })
hi("Error",           { fg = c.red_br })
hi("Todo",            { fg = c.yellow,   bold = true })
hi("Title",           { fg = c.blue_br,  bold = true })
hi("Directory",       { fg = c.blue })

-- Diff
hi("DiffAdd",         { fg = c.green,    bg = c.bg_hl })
hi("DiffChange",      { fg = c.yellow,   bg = c.bg_hl })
hi("DiffDelete",      { fg = c.red,      bg = c.bg_hl })
hi("DiffText",        { fg = c.yellow_br,bg = c.sel,   bold = true })

-- Diagnostics
hi("DiagnosticError",            { fg = c.red_br })
hi("DiagnosticWarn",             { fg = c.yellow })
hi("DiagnosticInfo",             { fg = c.blue })
hi("DiagnosticHint",             { fg = c.cyan })
hi("DiagnosticUnderlineError",   { undercurl = true, sp = c.red_br })
hi("DiagnosticUnderlineWarn",    { undercurl = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo",    { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint",    { undercurl = true, sp = c.cyan })

-- Spell
hi("SpellBad",        { undercurl = true, sp = c.red_br })
hi("SpellCap",        { undercurl = true, sp = c.yellow })
hi("SpellRare",       { undercurl = true, sp = c.purple })
hi("SpellLocal",      { undercurl = true, sp = c.cyan })

-- Treesitter
hi("@comment",              { link = "Comment" })
hi("@string",               { link = "String" })
hi("@number",               { link = "Number" })
hi("@boolean",              { link = "Boolean" })
hi("@float",                { link = "Float" })
hi("@function",             { link = "Function" })
hi("@function.builtin",     { fg = c.cyan_br })
hi("@function.call",        { fg = c.blue_br })
hi("@method",               { fg = c.blue_br })
hi("@method.call",          { fg = c.blue_br })
hi("@constructor",          { fg = c.blue })
hi("@keyword",              { link = "Keyword" })
hi("@keyword.function",     { fg = c.purple, bold = true })
hi("@keyword.return",       { fg = c.purple, bold = true })
hi("@keyword.operator",     { fg = c.cyan })
hi("@operator",             { link = "Operator" })
hi("@type",                 { link = "Type" })
hi("@type.builtin",         { fg = c.blue, italic = true })
hi("@variable",             { fg = c.fg })
hi("@variable.builtin",     { fg = c.red_br, italic = true })
hi("@parameter",            { fg = c.fg_dim })
hi("@field",                { fg = c.fg })
hi("@property",             { fg = c.fg })
hi("@punctuation.bracket",  { fg = c.fg_dim })
hi("@punctuation.delimiter",{ fg = c.fg_dim })
hi("@tag",                  { fg = c.blue })
hi("@tag.attribute",        { fg = c.cyan })
hi("@tag.delimiter",        { fg = c.grey })
hi("@namespace",            { fg = c.blue })
hi("@constant",             { link = "Constant" })
hi("@constant.builtin",     { fg = c.purple_br, bold = true })

-- LSP
hi("LspReferenceText",       { bg = c.sel })
hi("LspReferenceRead",       { bg = c.sel })
hi("LspReferenceWrite",      { bg = c.sel })
hi("LspSignatureActiveParameter", { fg = c.yellow, bold = true })

-- GitSigns
hi("GitSignsAdd",            { fg = c.green })
hi("GitSignsChange",         { fg = c.yellow })
hi("GitSignsDelete",         { fg = c.red })

-- Telescope / snacks picker
hi("TelescopeNormal",        { fg = c.fg,      bg = c.bg_dark })
hi("TelescopeBorder",        { fg = c.grey,    bg = c.bg_dark })
hi("TelescopePromptBorder",  { fg = c.blue,    bg = c.bg_dark })
hi("TelescopeSelection",     { fg = c.fg,      bg = c.sel })
hi("TelescopeMatching",      { fg = c.yellow,  bold = true })

-- Neo-tree
hi("NeoTreeNormal",          { fg = c.fg,      bg = c.bg_dark })
hi("NeoTreeNormalNC",        { fg = c.fg_dim,  bg = c.bg_dark })
hi("NeoTreeDirectoryName",   { fg = c.blue })
hi("NeoTreeDirectoryIcon",   { fg = c.blue })
hi("NeoTreeFileName",        { fg = c.fg })
hi("NeoTreeGitAdded",        { fg = c.green })
hi("NeoTreeGitModified",     { fg = c.yellow })
hi("NeoTreeGitDeleted",      { fg = c.red })
