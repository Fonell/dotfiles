-- ============================
-- OPTIONS
-- ============================
vim.g.mapleader = " " -- leader key
vim.g.maplocalleader = "\\" -- local leader key
vim.g.autoformat = true -- format on save

vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.shiftwidth = 2 -- indent size
vim.opt.tabstop = 2 -- tab width
vim.opt.shiftround = true -- round indent to shiftwidth
vim.opt.smartindent = true -- auto indent new lines
vim.opt.ignorecase = true -- case-insensitive search
vim.opt.smartcase = true -- case-sensitive if search has capitals
vim.opt.inccommand = "nosplit" -- live preview of :s
vim.opt.grepprg = "rg --vimgrep" -- use ripgrep for :grep
vim.opt.undofile = true -- persist undo history
vim.opt.undolevels = 10000 -- max undo steps
vim.opt.swapfile = false -- no swap files
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.splitright = true -- vertical splits open right
vim.opt.splitkeep = "screen" -- keep text in place on split
vim.opt.scrolloff = 4 -- lines kept above/below cursor
vim.opt.sidescrolloff = 8 -- columns kept left/right of cursor
vim.opt.wrap = false -- no line wrap
vim.opt.linebreak = true -- wrap at word boundaries
vim.opt.laststatus = 3 -- single global statusline
vim.opt.showmode = false -- hide mode, lualine shows it
vim.opt.termguicolors = true -- true color
vim.opt.timeoutlen = 300 -- ms to wait for mapped key sequence
vim.opt.updatetime = 200 -- ms before CursorHold
vim.opt.confirm = true -- ask to save instead of failing
vim.opt.autowrite = true -- save before :make, :next etc.
vim.opt.mouse = "a" -- mouse in all modes
vim.opt.virtualedit = "block" -- free cursor in visual block
vim.opt.foldlevel = 99 -- start with all folds open
vim.opt.foldmethod = "indent" -- fold by indent
vim.opt.list = true -- show tabs and trailing spaces
vim.opt.conceallevel = 2 -- hide markup like ** in markdown
vim.opt.completeopt = "menu,menuone,noselect" -- completion menu behavior
vim.opt.smoothscroll = true -- scroll wrapped lines smoothly
vim.opt.jumpoptions = "view" -- restore view when jumping back
vim.opt.pumheight = 10 -- max completion menu items
vim.opt.diffopt:append({ "algorithm:histogram", "indent-heuristic" }) -- better diff algorithm
vim.diagnostic.config({ virtual_text = true }) -- show diagnostics inline

-- ============================
-- PLUGINS
-- ============================
local gh = function(repo) return "https://github.com/" .. repo end
vim.pack.add({
  gh("Mofiqul/vscode.nvim"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  { src = gh("nvim-treesitter/nvim-treesitter-textobjects"), version = "main" },
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-lualine/lualine.nvim"),
  gh("folke/snacks.nvim"),
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
  gh("christoomey/vim-tmux-navigator"),
  gh("RyanMillerC/better-vim-tmux-resizer"),
  gh("folke/which-key.nvim"),
  gh("folke/trouble.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("folke/flash.nvim"),
  gh("nvim-mini/mini.nvim"),
  gh("stevearc/conform.nvim"),
  gh("folke/lazydev.nvim"),
})
vim.cmd.packadd("nvim.undotree")

-- ============================
-- PLUGIN SETUP
-- ============================
require("vscode").setup({})
vim.cmd.colorscheme("vscode")
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    u = ai.gen_spec.function_call(),
  },
})
require("mini.pairs").setup()
require("mini.cmdline").setup()
require("mini.notify").setup()
require("snacks").setup({
  picker = { sources = { explorer = { layout = { layout = { position = "right" } } } } },
  explorer = {},
  indent = {},
  lazygit = {},
  scroll = {},
  dashboard = {
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function() return Snacks.git.get_root() ~= nil end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 300,
        indent = 3,
      },
    },
  },
})
require("lualine").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "vtsls",
    "pyright",
    "ruff",
    "bashls",
    "clangd",
    "rust_analyzer",
    "jsonls",
    "yamlls",
    "taplo",
    "marksman",
    "html",
    "cssls",
  },
})
local registry = require("mason-registry")
registry.refresh(function()
  for _, name in ipairs({ "stylua", "prettier", "shfmt" }) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() then pkg:install() end
  end
end)
require("lazydev").setup()
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = { lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 } },
  },
})
require("which-key").setup({
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>f", group = "file" },
    { "<leader>g", group = "git" },
    { "<leader>gh", group = "hunks" },
    { "<leader>q", group = "quit" },
    { "<leader>s", group = "search" },
    { "<leader>t", group = "toggle" },
    { "<leader>w", group = "windows" },
    { "<leader>x", group = "diagnostics" },
  },
})
require("trouble").setup()
require("gitsigns").setup()
require("flash").setup()
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
  },
  format_on_save = function()
    if vim.g.autoformat then return { timeout_ms = 500, lsp_format = "fallback" } end
  end,
})

-- ============================
-- TREESITTER
-- ============================
require("nvim-treesitter").install({
  "bash",
  "cpp",
  "css",
  "diff",
  "html",
  "javascript",
  "json",
  "python",
  "regex",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "yaml",
})
-- Start treesitter highlighting and folding for every filetype
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- ============================
-- AUTOCMDS
-- ============================
-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.hl.on_yank() end })
-- Reload files changed outside nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})
-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================
-- KEYMAPS
-- ============================
local map = vim.keymap.set
local P = function(name, opts)
  return function() Snacks.picker[name](opts) end
end
local gs = function(fn, ...)
  local args = { ... }
  return function() require("gitsigns")[fn](unpack(args)) end
end

map({ "i", "n", "v" }, "<C-Up>", "<cmd>TmuxNavigateUp<cr><esc>", { desc = "Move to pane Up" })
map({ "i", "n", "v" }, "<C-Down>", "<cmd>TmuxNavigateDown<cr><esc>", { desc = "Move to pane Down" })
map({ "i", "n", "v" }, "<C-Left>", "<cmd>TmuxNavigateLeft<cr><esc>", { desc = "Move to pane Left" })
map({ "i", "n", "v" }, "<C-Right>", "<cmd>TmuxNavigateRight<cr><esc>", { desc = "Move to pane Right" })
map({ "i", "n", "v" }, "<S-Up>", "<cmd>TmuxResizeUp<cr><esc>", { desc = "Resize pane Up" })
map({ "i", "n", "v" }, "<S-Down>", "<cmd>TmuxResizeDown<cr><esc>", { desc = "Resize pane Down" })
map({ "i", "n", "v" }, "<S-Left>", "<cmd>TmuxResizeLeft<cr><esc>", { desc = "Resize pane Left" })
map({ "i", "n", "v" }, "<S-Right>", "<cmd>TmuxResizeRight<cr><esc>", { desc = "Resize pane Right" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move block down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move block up" })
map("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
map("x", "p", [["_dP]])
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map({ "n", "v" }, "<leader>d", [["_d]])

-- ============================
-- GENERAL KEYMAPS
-- ============================
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>xq", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = "Quickfix List" })
map("n", "<leader>xl", function()
  if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
    vim.cmd.lclose()
  else
    pcall(vim.cmd.lopen)
  end
end, { desc = "Location List" })
local diag = function(count, severity)
  return function() vim.diagnostic.jump({ count = count, severity = vim.diagnostic.severity[severity], float = true }) end
end
map("n", "]e", diag(1, "ERROR"), { desc = "Next Error" })
map("n", "[e", diag(-1, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diag(1, "WARN"), { desc = "Next Warning" })
map("n", "[w", diag(-1, "WARN"), { desc = "Prev Warning" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map(
  { "n", "x" },
  "<leader>cf",
  function() require("conform").format({ lsp_format = "fallback" }) end,
  { desc = "Format" }
)

-- ============================
-- LSP
-- ============================
map("n", "gd", P("lsp_definitions"), { desc = "Goto Definition" })
map("n", "gr", P("lsp_references"), { nowait = true, desc = "References" })
map("n", "gI", P("lsp_implementations"), { desc = "Goto Implementation" })
map("n", "gy", P("lsp_type_definitions"), { desc = "Goto Type Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map(
  "n",
  "<leader>cA",
  function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end,
  { desc = "Source Action" }
)
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", { desc = "Lsp Info" })
map("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

-- ============================
-- PICKER
-- ============================
map("n", "<leader><space>", P("files"), { desc = "Find Files" })
map("n", "<leader>/", P("grep"), { desc = "Grep" })
map("n", "<leader>,", P("buffers"), { desc = "Buffers" })
map("n", "<leader>:", P("command_history"), { desc = "Command History" })
map("n", "<leader>ff", P("files"), { desc = "Find Files" })
map("n", "<leader>fr", P("recent"), { desc = "Recent" })
map("n", "<leader>fc", P("files", { cwd = vim.fn.stdpath("config") }), { desc = "Find Config File" })
map("n", "<leader>fg", P("git_files"), { desc = "Find Files (git-files)" })
map("n", "<leader>sg", P("grep"), { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", P("grep_word"), { desc = "Visual selection or word" })
map("n", "<leader>sb", P("lines"), { desc = "Buffer Lines" })
map("n", "<leader>sh", P("help"), { desc = "Help Pages" })
map("n", "<leader>sk", P("keymaps"), { desc = "Keymaps" })
map("n", "<leader>sd", P("diagnostics"), { desc = "Diagnostics" })
map("n", "<leader>sR", P("resume"), { desc = "Resume" })
map("n", "<leader>ss", P("lsp_symbols"), { desc = "LSP Symbols" })
map("n", "<leader>sS", P("lsp_workspace_symbols"), { desc = "LSP Workspace Symbols" })
map("n", "<leader>su", "<cmd>Undotree<cr>", { desc = "Undotree" })
map("n", "<leader>uC", P("colorschemes"), { desc = "Colorschemes" })
map("n", "<leader>gs", P("git_status"), { desc = "Git Status" })
map("n", "<leader>gl", P("git_log"), { desc = "Git Log" })
map("n", "<leader>gf", P("git_log_file"), { desc = "Git Current File History" })

-- ============================
-- GIT
-- ============================
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "]h", gs("nav_hunk", "next"), { desc = "Next Hunk" })
map("n", "[h", gs("nav_hunk", "prev"), { desc = "Prev Hunk" })
map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" })
map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" })
map("n", "<leader>ghp", gs("preview_hunk_inline"), { desc = "Preview Hunk Inline" })
map("n", "<leader>ghb", gs("blame_line", { full = true }), { desc = "Blame Line" })
map("n", "<leader>ghd", gs("diffthis"), { desc = "Diff This" })
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", { desc = "Select Hunk" })

-- ============================
-- TOGGLES
-- ============================
Snacks.toggle({
  name = "Autoformat",
  get = function() return vim.g.autoformat end,
  set = function(state) vim.g.autoformat = state end,
}):map("<leader>tf")
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
Snacks.toggle.line_number():map("<leader>tl")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
Snacks.toggle.diagnostics():map("<leader>td")
Snacks.toggle.inlay_hints():map("<leader>th")
Snacks.toggle.scroll():map("<leader>tS")
Snacks.toggle.indent():map("<leader>ti")
map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Git Blame" })

-- ============================
-- TROUBLE
-- ============================
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- ============================
-- OTHER
-- ============================
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Explorer" })
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Keymaps" })
