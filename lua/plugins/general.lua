return {
  -- カラースキーム
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Set light or dark variant
        variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

        -- Enable transparent background
        transparent = true,

        -- Reduce the overall saturation of colours for a more muted look
        saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

        -- Enable italics comments
        italic_comments = false,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = false,

        -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
        borderless_pickers = false,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
        cache = false,

        -- Override highlight groups with your own colour values
        highlights = {
          -- Highlight groups to override, adding new groups is also possible
          -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

          -- Example:
          Comment = { fg = "#696969", bg = "NONE", italic = true },

          -- More examples can be found in `lua/cyberdream/extensions/*.lua`
        },

        -- Override a highlight group entirely using the built-in colour palette
        overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
          -- Example:
          return {
            Comment = { fg = colors.green, bg = "NONE", italic = true },
            ["@property"] = { fg = colors.magenta, bold = true },
          }
        end,

        -- Override colors
        colors = {
          -- For a list of colors see `lua/cyberdream/colours.lua`

          -- Override colors for both light and dark variants
          bg = "#000000",
          green = "#00ff00",

          -- If you want to override colors for light or dark variants only, use the following format:
          dark = {
            magenta = "#ff00ff",
            fg = "#eeeeee",
          },
          light = {
            red = "#ff5c57",
            cyan = "#5ef1ff",
          },
        },

        -- Disable or enable colorscheme extensions
        extensions = {
          telescope = true,
          notify = true,
          mini = true,
        },
      })
      -- カラースキームの設定
      vim.cmd.colorscheme "cyberdream"

      -- Visualモードの選択範囲の背景色を変更
      vim.api.nvim_set_hl(0, "Visual", { bg = "#0E676E", fg = "NONE", bold = false })
      -- カレント行の行番号の背景色を変更
      vim.opt.cursorline = true
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", fg = "#5bcfb5", bold = true })
    end
  },

  -- アイコン
  { "lambdalisue/vim-nerdfont" },
  { "lambdalisue/vim-glyph-palette" },
  { "nvim-tree/nvim-web-devicons",  opts = {} },

  -- ステータスライン
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
        }
      })
    end
  },

  -- Linter
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      local js_formatters = { { "biome", "prettierd", "prettier" } }
      require("conform").setup({
        formatters_by_ft = {
          -- Lua
          lua = { "stylua" },

          -- Python
          python = { "isort", "black" },

          -- JavaScript系
          json = js_formatters,
          javascript = js_formatters,
          javascriptreact = js_formatters,
          typescript = js_formatters,
          typescriptreact = js_formatters,
          astro = js_formatters,

          -- Markdown
          markdown = { "markdownlint-cli2" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_format = "fallback",
          lsp_fallback = true,
          quiet = false,
        },
      })
    end,
  },

  -- サイドバー系

  -- Oil
  -- {
  --   "stevearc/oil.nvim",
  --   opts = {
  --     use_default_keymaps = false,
  --     view_options = {
  --       show_hidden = true,
  --     },
  --   },
  --   keymaps = {
  --     ["g?"] = { "actions.show_help", mode = "n" },
  --     ["<leader>v"] = { "actions.select", opts = { vertical = true } },
  --     ["<leader>s"] = { "actions.select", opts = { horizontal = true } },
  --     ["<leader>t"] = { "actions.select", opts = { tab = true } },
  --     ["<leader>p"] = "actions.preview",
  --   },
  --   config = function()
  --     local oil = require("oil").setup()
  --
  --     vim.keymap.set("n", "<C-a>", oil.open, { desc = "Oil: Open Oil" })
  --   end,
  -- },
  -- {
  --   "refractalize/oil-git-status.nvim",
  --
  --   dependencies = {
  --     "stevearc/oil.nvim",
  --   },
  --
  --   config = true,
  -- },
  -- {
  --   "benomahony/oil-git.nvim",
  --   dependencies = { "stevearc/oil.nvim" },
  --   -- No opts or config needed! Works automatically
  -- },
  -- {
  --     "JezerM/oil-lsp-diagnostics.nvim",
  --     dependencies = { "stevearc/oil.nvim" },
  --     opts = {}
  -- },

  -- Snacks.nvim
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = {
        sections = {
          -- {
          --   section = "terminal",
          --   cmd =
          --   "chafa ~/.config/nvim/lua/plugins/dashboard.png -c 240 --size 60 --format symbols --symbols=braille --stretch; sleep .1",
          --   height = 60,
          --   padding = 1,
          -- },
          {
            -- pane = 2,
            {
              section = "terminal",
              cmd = "figlet NeoVim | lolcat",
              padding = 1,
            },
            { section = "keys",   gap = 1, padding = 1 },
            { section = "startup" },
          }
        }
      },
      explorer = { enabled = true },
      indent = { enabled = true, },
      input = { enabled = true },
      image = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      {
        "<C-a>",
        function()
          Snacks.picker.explorer()
        end,
        desc = "Snacks: Open Picker",
      },
      {
        "<leader>pp",
        function()
          Snacks.picker()
        end,
        desc = "Snacks: Open Picker",
      },
      {
        "<leader>pr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Snacks: Open Recent Files",
      },
      {
        "<leader>pg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Snacks: Open Grep",
      },
      {
        "<leader>pf",
        function()
          Snacks.picker.files()
        end,
        desc = "Snacks: Open files",
      },
      {
        "<leader>pt",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Snacks: Search todo Comments",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          if vim.bo.filetype ~= "" then
            Snacks.indent.enable()
          end
        end
      })
    end
  },

  -- コメントを見やすくする
  { "LudoPinelli/comment-box.nvim", },

  -- todoを見やすくする
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ツリー状にコードを整形
  {
    'Wansmer/treesj',
    keys = { '<space>j' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup({
        vim.keymap.set("n", "<space>j", function()
          require("treesj").toggle({
            split = { recursive = true }, -- split recursively
          })
        end, { desc = "Treesj: Toggle" }),
      })
    end,
  },

  -- Zenモードの導入
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("no-neck-pain").setup({
        buffers = {
          right = {
            enabled = false,
          },
          scratchPad = {
            enabled = true,
            location = "~/notes"
          },
          bo = {
            filetype = "md",
          },
        },
        autocmds = {
          -- enableOnVimEnter = true,
          enableOnTabEnter = true,
        },
      })
      vim.keymap.set({ "n", "x", "o" }, "<Leader>z", "<cmd>NoNeckPain<CR>", { desc = "no-neck-pain: Toggle" })
    end
  },

  -- タグウィンドウを表示
  {
    "preservim/tagbar"
  },

  -- タブの表示をおしゃれにする
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
        },
      })
    end
  },

  -- ハイライト表示
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "elixir", "heex", "eex", "rust", "scala" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        }
      }
    end
  },
  -- 画面上部にコードブロックを表示
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end,
  },

  -- HTMLなどのタグを自動で閉じる
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },

  -- スクロールバー
  {
    "petertriho/nvim-scrollbar",
    event = { "BufNewFile", "BufReadPre" },
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      require("scrollbar").setup({
      })
    end,
  },

  -- Git

  -- 行番号の位置に差分を表示
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "tpope/vim-fugitive",
    config = function()
      require('gitsigns').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },

  -- GItの差分を表示
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      signs = {
        fold_closed = "",
        fold_open = "",
      },
    },
    keys = {
      {
        "<leader>gd",
        function()
          require("diffview").open({ "HEAD~1" })
        end,
        desc = "[DiffView]: Open Diff View for HEAD~1",
      },
      {
        "<leader>gD",
        function()
          require("diffview").close()
        end,
        desc = "[DiffView]: Close Diff View",
      },
      {
        "<leader>gf",
        "<cmd>DiffviewFileHistory %<CR>",
        desc = "[DiffView]: Open File History for current file",
      },
    },
  },

  -- Gitのコミットグラフを表示
  {
    'isakbm/gitgraph.nvim',
    dependencies = {
      'sindrets/diffview.nvim'
    },
    opts = {
      git_cmd = "git",
      symbols = {
        merge_commit = "○",
        commit = "●",
        merge_commit_end = "○",
        commit_end = "●",

        -- Advanced symbols
        GVER = "│",
        GHOR = "─",
        GCLD = "╮",
        GCRD = "╭",
        GCLU = "╯",
        GCRU = "╰",
        GLRU = "┴",
        GLRD = "┬",
        GLUD = "┤",
        GRUD = "├",
        GFORKU = "┼",
        GFORKD = "┼",
        GRUDCD = "├",
        GRUDCU = "┡",
        GLUDCD = "┪",
        GLUDCU = "┩",
        GLRDCL = "┬",
        GLRDCR = "┬",
        GLRUCL = "┴",
        GLRUCR = "┴",
      },
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      hooks = {
        on_select_commit = function(commit)
          print('selected commit:', commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print('selected range:', from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require('gitgraph').draw({}, { all = false, max_count = 100 })
        end,
        desc = "Git Graph: 現在のブランチのみ",
      },
      {
        "<leader>gL",
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph: 全ブランチの表示",
      },
    },
  },

  -- Git Brame表示
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    keys = {
      {
        "<leader>gb",
        "<cmd>BlameToggle virtual<CR>",
        desc = "Git Blame: Toggle Virtual Blame",
      },
    },
    config = function()
      require('blame').setup {}
    end,
  },

  -- 括弧補完など
  {
    "alvan/vim-closetag",
    ft = { "html", "xhtml", "javascript", "typescript", "javascript.jsx", "typescript.tsx" },
    config = function()
      vim.g.closetag_filenames = "*.html"
      vim.g.closetag_xhtml_filenames = "*.jsx,*.tsx,*.vue"
      vim.g.closetag_filetypes = "html"
      vim.g.closetag_xhtml_filetypes = "jsx,tsx,javascript.jsx,typescript.tsx,vue"
      vim.g.closetag_emptyTags_caseSensitive = 1
      vim.g.closetag_shortcut = ">"
    end
  },

  -- 自動で括弧を閉じる
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  -- cs"' 系の補完を有効化する
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- emmet
  { "mattn/emmet-vim" },

  -- gccコメントアウトを有効化する
  { "numToStr/Comment.nvim" },

  -- 通知をわかりやすくする
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        },
      })

      vim.keymap.set("n", "<leader>pn", function()
        require("noice").cmd("last")
      end, { desc = "[Noice]: Show Last Notification" })
    end,
  },

  -- RGBに色を付ける
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require('colorizer').setup()
    end
  },

  -- 型シグネチャの表示
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      -- cfg options
      bind = true,
      handler_opts = {
        border = "rounded"
      }
    },
  },

  -- コードのアウトライン表示
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require('aerial').setup({
        backends = { "treesitter", "lsp" },
        show_guides = true,
        show_guide_icons = true,
        show_cursor = true,
        show_unlisted = false,
        close_on_select = true,
        filter_kind = false,
        keymaps = {
          ["<CR>"] = "actions.jump",
          ["<leader>v"] = "actions.jump_vsplit",
          ["<leader>s"] = "actions.jump_split",
          ["<leader>t"] = "actions.jump_tab",
          ["<leader>r"] = "actions.rename",
          ["<leader>d"] = "actions.peek_definition",
          ["<leader>f"] = "actions.focus",
          ["<leader>F"] = "actions.jump_quickfix",
          ["<leader>h"] = "actions.hover",
        },
      })
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "[Aerial]: Toggle Aerial" })
    end
  },

  -- インラインでdiagnosticメッセージを表示
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,    -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },

  -- その他
  {
    "simeji/winresizer",
    init = function()
      vim.g.winresizer_start_key = '<Leader>w'
    end
  },

  -- ナビゲーション & 検索
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require('flash').setup({
        modes = {
          char = {
            enabled = false,
          },
        },
      })

      vim.keymap.set({ "n", "x", "o" }, "<Leader><Leader>s", function() require("flash").jump() end,
        { desc = "Flash: Jump" })
      vim.keymap.set({ "n", "x", "o" }, "<Leader><Leader>a", function() require("flash").treesitter() end,
        { desc = "Flash: Treesiter" })
      vim.keymap.set({ "n", "x", "o" }, "<Leader><Leader>w", function() require("flash").treesitter_search() end,
        { desc = "Flash: Treesitter Search" })
      vim.keymap.set({ "n", "x", "o" }, "<Leader><Leader>d", function() require("flash").remote() end,
        { desc = "Flash: Remote" })
    end
  },

  -- open-browser
  {
    "https://github.com/tyru/open-browser.vim"
  },

  -- markdownの描画をリッチにする
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    ft = { "markdown" },
    keys = {
      {
        "<leader>mn",
        ":RenderMarkdown toggle<CR>",
        desc = "[RenderMarkdown]: Markdown表示切替"
      },
    },
    config = function()
      require("render-markdown").setup({})
    end,
  },

  -- markdown-preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mm",
        ":MarkdownPreview<CR>",
        desc = "[MarkdownPreview]: markdownをブラウザで開く"
      },
    },
  },

  -- コードブロックの開閉
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "kevinhwang91/nvim-treesitter"
    },
    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set("n", "<leader>ga", require('ufo').openAllFolds, { desc = "[UFO]: Open All Folds" })
      vim.keymap.set("n", "<leader>gs", require('ufo').closeAllFolds, { desc = "[UFO]: Close All Folds" })

      require("ufo").setup()
    end,
  },

  -- GitHub Copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = {
  --         -- enabled = false,
  --         auto_trigger = true,
  --         keymap = {
  --           accept = "<f13>",
  --         }
  --       },
  --       panel = { enabled = false },
  --       copilot_node_command = 'node',
  --     })
  --   end,
  -- },

  -- AI Coding
  {
    "olimorris/codecompanion.nvim",
    opts = {
      language = "japanese",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup()

      vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "v" }, "<leader>d", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cab cc CodeCompanion]])
    end
  },

}
