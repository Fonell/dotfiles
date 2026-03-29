local map = vim.keymap.set

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
