return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    { "<C-Left>",  function() require("smart-splits").move_cursor_left() end,  mode = { "n", "i", "v" }, desc = "Move to pane Left" },
    { "<C-Down>",  function() require("smart-splits").move_cursor_down() end,  mode = { "n", "i", "v" }, desc = "Move to pane Down" },
    { "<C-Up>",    function() require("smart-splits").move_cursor_up() end,    mode = { "n", "i", "v" }, desc = "Move to pane Up" },
    { "<C-Right>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "i", "v" }, desc = "Move to pane Right" },
    { "<S-Left>",  function() require("smart-splits").resize_left() end,       mode = { "n", "i", "v" }, desc = "Resize pane Left" },
    { "<S-Down>",  function() require("smart-splits").resize_down() end,       mode = { "n", "i", "v" }, desc = "Resize pane Down" },
    { "<S-Up>",    function() require("smart-splits").resize_up() end,         mode = { "n", "i", "v" }, desc = "Resize pane Up" },
    { "<S-Right>", function() require("smart-splits").resize_right() end,      mode = { "n", "i", "v" }, desc = "Resize pane Right" },
  },
  opts = {
    multiplexer_backend = "wezterm",
  },
}
