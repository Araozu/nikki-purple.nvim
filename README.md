# nikki-purple.nvim

A pastel-purple Neovim colorscheme with a calm lavender-and-mauve syntax
hierarchy and three variants: light, dark, and screen.

## Features

- Light palette for paper-like daytime editing
- Dark palette built around midnight blue and glowing lavender
- Screen palette with deeper backgrounds and brighter accents
- Native Vim syntax, Treesitter, LSP diagnostics, diff, and terminal colors
- Highlight integrations for Telescope, WhichKey, GitSigns, Neo-tree, and Oil

## Installation

Add the repository to your plugin manager. For `lazy.nvim`, a local checkout can
be configured like this:

```lua
{
  dir = "/path/to/nikki-purple-nvim",
  name = "nikki-purple.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("nikki-purple")
  end,
}
```

For a manual local install, add the directory to Neovim's runtime path:

```lua
vim.opt.rtp:prepend("/path/to/nikki-purple-nvim")
vim.cmd.colorscheme("nikki-purple")
```

## Variants

The default colorscheme follows `&background`: it selects `light` when
`background=light` and `dark` otherwise.

```vim
colorscheme nikki-purple
colorscheme nikki-purple-light
colorscheme nikki-purple-dark
colorscheme nikki-purple-screen
```

To use the screen palette through the default loader:

```lua
vim.g.nikki_purple_style = "screen"
vim.cmd.colorscheme("nikki-purple")
```

The Lua API accepts `light`, `dark`, or `screen`:

```lua
require("nikki-purple").setup({ style = "screen" })
```

## Palette

All palette values are defined in `lua/nikki-purple/palette.lua`.

| Token | Light | Dark | Screen |
| --- | --- | --- | --- |
| `bg` | `#fbf8fd` | `#0b0920` | `#100c17` |
| `bg_alt` | `#f4eff9` | `#110d2a` | `#181224` |
| `surface` | `#eee7f5` | `#171233` | `#241b33` |
| `surface_alt` | `#e6daef` | `#211a40` | `#302442` |
| `border` | `#d4c3df` | `#392b50` | `#4c3b62` |
| `fg` | `#3b2d4a` | `#e9e0ef` | `#f8f0ff` |
| `fg_dim` | `#5f506d` | `#c2b5ca` | `#ddcfea` |
| `muted` | `#81718e` | `#998ba4` | `#b6a5c4` |
| `subtle` | `#a797b4` | `#74677f` | `#8d7c9c` |
| `lavender` | `#8464ad` | `#b49ad8` | `#d9b8ff` |
| `purple` | `#7957a3` | `#aa86d2` | `#c49cff` |
| `violet` | `#6657ae` | `#9189e0` | `#b6a5ff` |
| `pink` | `#a25b8b` | `#d18ab4` | `#f0b6df` |
| `rose` | `#ad5d75` | `#d4879c` | `#ffafc9` |
| `peach` | `#9d674a` | `#d39a7b` | `#ffc0a6` |
| `yellow` | `#8b6a21` | `#d1ad5e` | `#f5d791` |
| `green` | `#4f805f` | `#82b792` | `#b7e9c0` |
| `cyan` | `#377d81` | `#6fc0c2` | `#a7e8e5` |
| `blue` | `#4d6fa7` | `#8da9dd` | `#b9d4ff` |
| `red` | `#aa5557` | `#d78386` | `#ffb0b0` |
| `orange` | `#a4623e` | `#d48a66` | `#ffbf8e` |
| `selection` | `#e5d9ef` | `#30234a` | `#503e6a` |
| `visual` | `#ded0ea` | `#3a2850` | `#49365d` |
| `search` | `#c7a8dd` | `#65417a` | `#9275ba` |
| `match` | `#b18ac9` | `#76548a` | `#73558e` |

## Syntax Hierarchy

The theme intentionally avoids giving every token a separate rainbow color.

| Role | Highlight groups | Color token |
| --- | --- | --- |
| Comments | `Comment`, `@comment` | `muted` |
| Variables and parameters | `Identifier`, `Parameter`, `@variable` | `fg` |
| Strings | `String`, `@string` | `green` |
| Characters and escapes | `Character`, `SpecialChar` | `cyan` |
| Functions | `Function`, `@function`, `@method` | `lavender` |
| Types | `Type`, `Structure`, `Typedef` | `purple` |
| Keywords | `Keyword`, `Statement`, `Conditional`, `Repeat` | `pink` |
| Constants | `Constant`, `Boolean` | `peach` |
| Numbers | `Number`, `Float` | `orange` |
| Operators and macros | `Operator`, `PreProc`, `Macro` | `violet` |
| Punctuation | `Delimiter`, punctuation captures | `fg_dim` |
| Properties | `Property`, `@property`, `@field` | `blue` |
| Tags and special syntax | `Tag`, `Special` | `rose` |
| Errors | `DiagnosticError`, `Error` | `red` |
| Warnings | `DiagnosticWarn`, `WarningMsg` | `yellow` |
| Hints | `DiagnosticHint`, `HintMsg` | `cyan` |
| Info | `DiagnosticInfo`, `InfoMsg` | `blue` |
| Success and additions | `DiagnosticOk`, `Added`, `GitSignsAdd` | `green` |

## Terminal Colors

The terminal palette uses the same semantic colors instead of stock ANSI
values. Bright magenta is `pink`, bright blue is `blue`, and bright white is
the `fg` moonlight color.

| ANSI index | Color token |
| --- | --- |
| `0` | `bg` |
| `1` | `red` |
| `2` | `green` |
| `3` | `yellow` |
| `4` | `blue` |
| `5` | `purple` |
| `6` | `cyan` |
| `7` | `fg` |
| `8` | `subtle` |
| `9` | `red` |
| `10` | `green` |
| `11` | `yellow` |
| `12` | `blue` |
| `13` | `pink` |
| `14` | `cyan` |
| `15` | `fg` |
