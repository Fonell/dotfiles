local map = vim.keymap.set

map({ "i", "n", "v" }, "<C-Up>", "<cmd>TmuxNavigateUp<cr><esc>", { desc = "Move to pane Up" })
map({ "i", "n", "v" }, "<C-Down>", "<cmd>TmuxNavigateDown<cr><esc>", { desc = "Move to pane Down" })
map({ "i", "n", "v" }, "<C-Left>", "<cmd>TmuxNavigateLeft<cr><esc>", { desc = "Move to pane Left" })
map({ "i", "n", "v" }, "<C-Right>", "<cmd>TmuxNavigateRight<cr><esc>", { desc = "Move to pane Right" })

map({ "i", "n", "v" }, "<S-Up>", "<cmd>TmuxResizeUp<cr><esc>", { desc = "Resize pane Up" })
map({ "i", "n", "v" }, "<S-Down>", "<cmd>TmuxResizeDown<cr><esc>", { desc = "Resize pane Down" })
map({ "i", "n", "v" }, "<S-Left>", "<cmd>TmuxResizeLeft<cr><esc>", { desc = "Resize pane Left" })
map({ "i", "n", "v" }, "<S-Right>", "<cmd>TmuxResizeRight<cr><esc>", { desc = "Resize pane Right" })

-- Move blocks of text up/down in visual and normal modes
map({ "v", "n" }, "<A-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move block down" })
map({ "v", "n" }, "<A-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move block up" })
map("n", "<A-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })

-- Paste in visual mode without yanking replaced text
map("x", "p", [["_dP]])

-- yank to clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
-- yank line to clipboard
map("n", "<leader>Y", [["+Y]])

-- delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]])
