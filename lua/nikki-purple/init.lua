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

local function hex_to_rgb(hex)
  return {
    tonumber(hex:sub(2, 3), 16),
    tonumber(hex:sub(4, 5), 16),
    tonumber(hex:sub(6, 7), 16),
  }
end

local function blend(color1, color2, weight)
  weight = weight or 0.5
  local rgb1 = hex_to_rgb(color1)
  local rgb2 = hex_to_rgb(color2)
  local out = {}
  for i = 1, 3 do
    out[i] = math.floor(rgb1[i] * weight + rgb2[i] * (1 - weight))
  end
  return string.format("#%02x%02x%02x", out[1], out[2], out[3])
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

    -- Markdown (legacy vim syntax)
    mkdCodeDelimiter = { fg = c.muted },
    mkdCodeStart = { fg = c.blue },
    mkdCodeEnd = { fg = c.blue },
    markdownHeadingDelimiter = { fg = c.muted },
    markdownCode = { fg = c.cyan },
    markdownCodeBlock = { fg = c.cyan },
    markdownH1 = { fg = c.orange, bold = true },
    markdownH2 = { fg = c.cyan, bold = true },
    markdownH3 = { fg = c.blue, bold = true },
    markdownH4 = { fg = c.purple, bold = true },
    markdownH5 = { fg = c.pink, bold = true },
    markdownH6 = { fg = c.green, bold = true },
    markdownLinkText = { fg = c.blue, underline = true },

    -- render-markdown.nvim
    RenderMarkdownH1 = { fg = c.orange, bold = true },
    RenderMarkdownH2 = { fg = c.cyan, bold = true },
    RenderMarkdownH3 = { fg = c.blue, bold = true },
    RenderMarkdownH4 = { fg = c.purple, bold = true },
    RenderMarkdownH5 = { fg = c.pink, bold = true },
    RenderMarkdownH6 = { fg = c.green, bold = true },
    RenderMarkdownH1Bg = { bg = blend(c.bg, c.orange, 0.85) },
    RenderMarkdownH2Bg = { bg = blend(c.bg, c.cyan, 0.85) },
    RenderMarkdownH3Bg = { bg = blend(c.bg, c.blue, 0.85) },
    RenderMarkdownH4Bg = { bg = blend(c.bg, c.purple, 0.85) },
    RenderMarkdownH5Bg = { bg = blend(c.bg, c.pink, 0.85) },
    RenderMarkdownH6Bg = { bg = blend(c.bg, c.green, 0.85) },
    RenderMarkdownQuote = { fg = c.muted },
    RenderMarkdownQuote1 = { fg = blend(c.muted, c.bg, 0.9) },
    RenderMarkdownQuote2 = { fg = blend(c.muted, c.bg, 0.8) },
    RenderMarkdownQuote3 = { fg = blend(c.muted, c.bg, 0.7) },
    RenderMarkdownQuote4 = { fg = blend(c.muted, c.bg, 0.6) },
    RenderMarkdownQuote5 = { fg = blend(c.muted, c.bg, 0.5) },
    RenderMarkdownQuote6 = { fg = blend(c.muted, c.bg, 0.4) },
    RenderMarkdownCode = { bg = c.bg_alt },
    RenderMarkdownBullet = { fg = c.muted },
    RenderMarkdownDash = { fg = c.muted },
    RenderMarkdownLink = { fg = c.cyan },
    RenderMarkdownMath = { fg = c.violet },
    RenderMarkdownTodo = { fg = c.orange },
    RenderMarkdownTableHead = { fg = c.muted },
    RenderMarkdownTableRow = { fg = blend(c.muted, c.bg, 0.7) },
    RenderMarkdownTableFill = { link = "Conceal" },
    RenderMarkdownSuccess = { fg = c.green },
    RenderMarkdownInfo = { fg = c.blue },
    RenderMarkdownHint = { fg = c.cyan },
    RenderMarkdownWarn = { fg = c.orange },
    RenderMarkdownError = { fg = c.red },

    -- markview.nvim
    MarkviewHeading1 = { fg = c.orange, bg = blend(c.bg, c.orange, 0.8), bold = true },
    MarkviewHeading2 = { fg = c.cyan, bg = blend(c.bg, c.cyan, 0.8), bold = true },
    MarkviewHeading3 = { fg = c.blue, bg = blend(c.bg, c.blue, 0.8), bold = true },
    MarkviewHeading4 = { fg = c.purple, bg = blend(c.bg, c.purple, 0.8), bold = true },
    MarkviewHeading5 = { fg = c.pink, bg = blend(c.bg, c.pink, 0.8), bold = true },
    MarkviewHeading6 = { fg = c.green, bg = blend(c.bg, c.green, 0.8), bold = true },
    MarkviewHeading1Sign = { fg = c.orange },
    MarkviewHeading2Sign = { fg = c.cyan },
    MarkviewHeading3Sign = { fg = c.blue },
    MarkviewHeading4Sign = { fg = c.purple },
    MarkviewHeading5Sign = { fg = c.pink },
    MarkviewHeading6Sign = { fg = c.green },
    MarkviewBlockQuoteDefault = { link = "Comment" },
    MarkviewBlockQuoteOk = { fg = c.green },
    MarkviewBlockQuoteWarn = { fg = c.yellow },
    MarkviewBlockQuoteError = { fg = c.red },
    MarkviewBlockQuoteNote = { fg = c.blue },
    MarkviewBlockQuoteSpecial = { fg = c.cyan },
    MarkviewCode = { bg = blend(c.bg_alt, c.surface_alt, 0.8) },
    MarkviewInlineCode = { fg = c.pink, bg = blend(c.bg_alt, c.surface_alt, 0.8) },
    MarkviewTableBorder = { fg = c.surface_alt },
    MarkviewTableAlignLeft = { fg = c.green },
    MarkviewTableAlignCenter = { fg = c.blue },
    MarkviewTableAlignRight = { fg = c.purple },

    -- helpview.nvim (same codeblock treatment)
    HelpviewCode = { bg = c.bg_alt },
    HelpviewInlineCode = { link = "HelpviewCode" },
    HelpviewCodeLanguage = { fg = c.muted, bg = c.bg_alt, italic = true },

    Italic = { italic = true },
    Bold = { bold = true },
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  for i = 1, 10 do
    vim.api.nvim_set_hl(0, "MarkviewGradient" .. i, { fg = blend(c.muted, c.bg, i / 10) })
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
    ["@markup.heading.1"] = "markdownH1",
    ["@markup.heading.2"] = "markdownH2",
    ["@markup.heading.3"] = "markdownH3",
    ["@markup.heading.4"] = "markdownH4",
    ["@markup.heading.5"] = "markdownH5",
    ["@markup.heading.6"] = "markdownH6",
    ["@markup.italic"] = "Italic",
    ["@markup.link"] = "Underlined",
    ["@markup.link.label.markdown_inline"] = "RenderMarkdownLink",
    ["@markup.link.markdown_inline"] = "markdownLinkText",
    ["@markup.link.url"] = "Underlined",
    ["@markup.list.checked"] = "DiagnosticOk",
    ["@markup.list.unchecked"] = "Todo",
    ["@markup.quote"] = "Comment",
    ["@markup.strong"] = "Bold",
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
