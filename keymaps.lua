local map = vim.keymap.set

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
