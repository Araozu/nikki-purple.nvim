local palette = require("nikki-purple.palette")

local M = {}

local function resolve_style(style)
  style = style or vim.g.nikki_purple_style

  if style == nil or style == "auto" then
    style = vim.o.background == "light" and "light" or "dark"
  end

  if palette[style] == nil then
    error("nikki-purple: unknown style " .. vim.inspect(style) .. "; use light, dark, or screen")
  end

  return style
end

local function apply_highlights(c)
  local highlights = {
    -- Editor UI
    Normal = { fg = c.fg, bg = c.bg },
    NormalNC = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.surface },
    FloatBorder = { fg = c.border, bg = c.surface },
    FloatTitle = { fg = c.lavender, bg = c.surface, bold = true },
    ColorColumn = { bg = c.bg_alt },
    Conceal = { fg = c.subtle },
    Cursor = { fg = c.bg, bg = c.lavender },
    lCursor = { fg = c.bg, bg = c.lavender },
    CursorIM = { fg = c.bg, bg = c.lavender },
    CursorColumn = { bg = c.bg_alt },
    CursorLine = { bg = c.bg_alt },
    CursorLineNr = { fg = c.lavender, bold = true },
    LineNr = { fg = c.subtle },
    SignColumn = { fg = c.muted, bg = c.bg },
    FoldColumn = { fg = c.subtle, bg = c.bg },
    Folded = { fg = c.muted, bg = c.surface },
    NonText = { fg = c.subtle },
    Whitespace = { fg = c.border },
    SpecialKey = { fg = c.subtle },
    EndOfBuffer = { fg = c.bg_alt },
    VertSplit = { fg = c.border, bg = c.bg },
    WinSeparator = { fg = c.border, bg = c.bg },
    StatusLine = { fg = c.fg, bg = c.surface_alt, bold = true },
    StatusLineNC = { fg = c.muted, bg = c.bg_alt },
    StatusLineTerm = { fg = c.fg, bg = c.surface_alt, bold = true },
    StatusLineTermNC = { fg = c.muted, bg = c.bg_alt },
    TabLine = { fg = c.muted, bg = c.bg_alt },
    TabLineFill = { fg = c.subtle, bg = c.bg },
    TabLineSel = { fg = c.fg, bg = c.surface_alt, bold = true },
    WinBar = { fg = c.fg_dim, bg = c.bg },
    WinBarNC = { fg = c.muted, bg = c.bg },
    Pmenu = { fg = c.fg, bg = c.surface },
    PmenuSel = { fg = c.bg, bg = c.lavender, bold = true },
    PmenuKind = { fg = c.purple, bg = c.surface },
    PmenuKindSel = { fg = c.bg, bg = c.lavender, bold = true },
    PmenuExtra = { fg = c.muted, bg = c.surface },
    PmenuExtraSel = { fg = c.bg, bg = c.lavender },
    PmenuSbar = { bg = c.surface_alt },
    PmenuThumb = { bg = c.border },
    WildMenu = { fg = c.bg, bg = c.lavender, bold = true },
    Directory = { fg = c.blue, bold = true },
    Title = { fg = c.lavender, bold = true },
    Question = { fg = c.green, bold = true },
    MoreMsg = { fg = c.green },
    ModeMsg = { fg = c.fg_dim, bold = true },
    MsgArea = { fg = c.fg_dim },
    MsgSeparator = { fg = c.border },
    ErrorMsg = { fg = c.red, bold = true },
    WarningMsg = { fg = c.yellow, bold = true },
    InfoMsg = { fg = c.blue },
    HintMsg = { fg = c.cyan },
    HelpCommand = { fg = c.purple },
    HelpExample = { fg = c.green },

    -- Search, selection, and motion
    Search = { fg = c.bg, bg = c.search, bold = true },
    IncSearch = { fg = c.bg, bg = c.peach, bold = true },
    CurSearch = { fg = c.bg, bg = c.peach, bold = true },
    Substitute = { fg = c.bg, bg = c.pink, bold = true },
    Visual = { bg = c.visual },
    VisualNOS = { bg = c.visual },
    MatchParen = { fg = c.lavender, bg = c.match, bold = true },
    QuickFixLine = { bg = c.surface_alt },
    CursorLineFold = { fg = c.lavender, bg = c.bg_alt },
    CursorLineSign = { fg = c.lavender, bg = c.bg_alt },

    -- Diagnostics and language client UI
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.cyan },
    DiagnosticOk = { fg = c.green },
    DiagnosticVirtualTextError = { fg = c.red, bg = c.bg_alt },
    DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.bg_alt },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.bg_alt },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = c.bg_alt },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },
    LspReferenceText = { bg = c.selection },
    LspReferenceRead = { bg = c.selection },
    LspReferenceWrite = { bg = c.selection },
    LspInlayHint = { fg = c.subtle, bg = c.bg_alt, italic = true },
    LspCodeLens = { fg = c.subtle, italic = true },
    LspCodeLensSeparator = { fg = c.border },

    -- Diff and version control
    DiffAdd = { fg = c.green, bg = c.bg_alt },
    DiffChange = { fg = c.yellow, bg = c.bg_alt },
    DiffDelete = { fg = c.red, bg = c.bg_alt },
    DiffText = { fg = c.bg, bg = c.lavender, bold = true },
    Added = { fg = c.green },
    Changed = { fg = c.yellow },
    Removed = { fg = c.red },

    -- Syntax groups
    Comment = { fg = c.muted, italic = true },
    Constant = { fg = c.peach },
    String = { fg = c.green },
    Character = { fg = c.cyan },
    Number = { fg = c.orange },
    Boolean = { fg = c.peach, bold = true },
    Float = { fg = c.orange },
    Identifier = { fg = c.fg },
    Parameter = { fg = c.fg },
    Property = { fg = c.blue },
    Function = { fg = c.lavender, bold = true },
    Statement = { fg = c.pink },
    Conditional = { fg = c.pink },
    Repeat = { fg = c.pink },
    Label = { fg = c.rose },
    Operator = { fg = c.violet },
    Keyword = { fg = c.pink },
    Exception = { fg = c.rose },
    PreProc = { fg = c.violet },
    Include = { fg = c.purple },
    Define = { fg = c.violet },
    Macro = { fg = c.violet },
    PreCondit = { fg = c.violet },
    Type = { fg = c.purple },
    StorageClass = { fg = c.purple, bold = true },
    Structure = { fg = c.purple },
    Typedef = { fg = c.purple },
    Special = { fg = c.rose },
    SpecialChar = { fg = c.cyan },
    Tag = { fg = c.rose },
    Delimiter = { fg = c.fg_dim },
    SpecialComment = { fg = c.subtle, italic = true },
    Debug = { fg = c.orange },
    Underlined = { fg = c.blue, underline = true },
    Error = { fg = c.red, bold = true },
    Todo = { fg = c.bg, bg = c.yellow, bold = true },

    -- Common plugin surfaces
    TelescopeNormal = { fg = c.fg, bg = c.surface },
    TelescopeBorder = { fg = c.border, bg = c.surface },
    TelescopePromptNormal = { fg = c.fg, bg = c.surface_alt },
    TelescopePromptBorder = { fg = c.border, bg = c.surface_alt },
    TelescopePromptTitle = { fg = c.bg, bg = c.lavender, bold = true },
    TelescopeResultsTitle = { fg = c.bg, bg = c.purple, bold = true },
    TelescopePreviewTitle = { fg = c.bg, bg = c.green, bold = true },
    TelescopeSelection = { bg = c.selection },
    TelescopeMatching = { fg = c.pink, bold = true },
    WhichKey = { fg = c.lavender, bold = true },
    WhichKeyGroup = { fg = c.purple },
    WhichKeyDesc = { fg = c.fg_dim },
    WhichKeySeparator = { fg = c.subtle },
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
    NeoTreeNormal = { fg = c.fg, bg = c.surface },
    NeoTreeNormalNC = { fg = c.fg_dim, bg = c.surface },
    NeoTreeDirectoryName = { fg = c.blue },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.yellow },
    NeoTreeGitDeleted = { fg = c.red },
    OilDir = { fg = c.blue },
    OilFile = { fg = c.fg },
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local treesitter_links = {
    ["@attribute"] = "PreProc",
    ["@attribute.builtin"] = "Special",
    ["@boolean"] = "Boolean",
    ["@character"] = "Character",
    ["@character.special"] = "SpecialChar",
    ["@comment"] = "Comment",
    ["@constant"] = "Constant",
    ["@constant.builtin"] = "Constant",
    ["@constructor"] = "Type",
    ["@function"] = "Function",
    ["@function.builtin"] = "Function",
    ["@function.call"] = "Function",
    ["@function.macro"] = "Macro",
    ["@keyword"] = "Keyword",
    ["@keyword.conditional"] = "Conditional",
    ["@keyword.directive"] = "PreProc",
    ["@keyword.exception"] = "Exception",
    ["@keyword.function"] = "Keyword",
    ["@keyword.import"] = "Include",
    ["@keyword.operator"] = "Operator",
    ["@keyword.repeat"] = "Repeat",
    ["@keyword.return"] = "Keyword",
    ["@label"] = "Label",
    ["@method"] = "Function",
    ["@method.call"] = "Function",
    ["@module"] = "Type",
    ["@namespace"] = "Type",
    ["@number"] = "Number",
    ["@number.float"] = "Float",
    ["@operator"] = "Operator",
    ["@field"] = "Property",
    ["@parameter"] = "Parameter",
    ["@property"] = "Property",
    ["@punctuation.bracket"] = "Delimiter",
    ["@punctuation.delimiter"] = "Delimiter",
    ["@punctuation.special"] = "SpecialChar",
    ["@string"] = "String",
    ["@string.escape"] = "SpecialChar",
    ["@string.regex"] = "String",
    ["@string.special"] = "SpecialChar",
    ["@tag"] = "Tag",
    ["@tag.attribute"] = "Property",
    ["@tag.delimiter"] = "Delimiter",
    ["@type"] = "Type",
    ["@type.builtin"] = "Type",
    ["@variable"] = "Identifier",
    ["@variable.builtin"] = "Identifier",
    ["@variable.member"] = "Property",
    ["@variable.parameter"] = "Parameter",
    ["@variable.parameter.builtin"] = "Parameter",
    ["@markup.heading"] = "Title",
    ["@markup.link"] = "Underlined",
    ["@markup.raw"] = "String",
  }

  for group, target in pairs(treesitter_links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end
end

local function apply_terminal_palette(c)
  local colors = {
    c.bg,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.purple,
    c.cyan,
    c.fg,
    c.subtle,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.pink,
    c.cyan,
    c.fg,
  }

  for index, color in ipairs(colors) do
    vim.g["terminal_color_" .. (index - 1)] = color
  end
end

function M.load(style, name)
  style = resolve_style(style)

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = name or ("nikki-purple-" .. style)

  apply_highlights(palette[style])
  apply_terminal_palette(palette[style])
end

function M.setup(opts)
  opts = opts or {}
  M.load(opts.style, opts.name)
end

M.palette = palette

return M
