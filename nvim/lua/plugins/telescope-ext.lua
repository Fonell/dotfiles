return {
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        config = function()
          LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("live_grep_args")
          end)
        end,
      },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Grep this file" },
      {
        "<leader>sg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep with Args (root dir)",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          width = 300,
          height = 90,
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        git_status = {
          layout_strategy = "horizontal",
        },
        buffers = {
          mappings = {
            i = {
              ["<A-d>"] = function(...)
                return require("telescope.actions").delete_buffer(...)
              end,
            },
            n = {
              ["<A-d>"] = function(...)
                return require("telescope.actions").delete_buffer(...)
              end,
            },
          },
        },
      },
      extensions = {
        live_grep_args = {
          mappings = {
            i = {
              ["<C-k>"] = function(picker)
                require("telescope-live-grep-args.actions").quote_prompt()(picker)
              end,
              ["<C-i>"] = function(picker)
                require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })(picker)
              end,
              ["<C-Space>"] = function(picker)
                require("telescope.actions").to_fuzzy_refine(picker)
              end,
            },
          },
        },
      },
    },
  },
}
