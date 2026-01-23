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
			vim.cmd.colorscheme("cyberdream")

			-- Visualモードの選択範囲の背景色を変更
			vim.api.nvim_set_hl(0, "Visual", { bg = "#0E676E", fg = "NONE", bold = false })
			-- カレント行の行番号の背景色を変更
			vim.opt.cursorline = true
			vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", fg = "#5bcfb5", bold = true })
		end,
	},

	-- アイコン
	{ "lambdalisue/vim-nerdfont" },
	{ "lambdalisue/vim-glyph-palette" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- ステータスライン
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					icons_enabled = true,
				},
			})
		end,
	},

	-- カスタムスニペット
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_lua").lazy_load({
				paths = "~/.config/nvim/lua/snippets",
			})
			require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets を併用したい場合
			vim.keymap.set(
				"n",
				"<leader>@",
				require("luasnip.loaders").edit_snippet_files,
				{ desc = "[LuaSnip] Edit snippets" }
			)
		end,
	},

	-- Oil.nvim
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "<leader>oi", function()
				require("oil").open_float()
			end, { desc = "[Oil]: Open parent directory" })
			vim.keymap.set("n", "<leader>oo", function()
				require("oil").open_float(".")
			end, { desc = "[Oil]: Open current directory" })
		end,
	},

	-- サイドバー系

	-- Snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				sections = {
					{
						{
							section = "terminal",
							cmd = "figlet -f O8 Kawaii | lolcat; sleep .1",
						},
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
				},
			},
			explorer = { enabled = true },
			indent = { enabled = true },
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
				desc = "[Snacks]: Open Picker",
			},
			{
				"<leader>pp",
				function()
					Snacks.picker()
				end,
				desc = "[Snacks]: Open Picker",
			},
			{
				"<leader>pr",
				function()
					Snacks.picker.recent()
				end,
				desc = "[Snacks]: Open Recent Files",
			},
			{
				"<leader>pg",
				function()
					Snacks.picker.grep()
				end,
				desc = "[Snacks]: Open Grep",
			},
			{
				"<leader>pf",
				function()
					Snacks.picker.files()
				end,
				desc = "[Snacks]: Open files",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("BufReadPost", {
				callback = function()
					if vim.bo.filetype ~= "" then
						Snacks.indent.enable()
					end
				end,
			})
		end,
	},

	-- コメントを見やすくする
	{ "LudoPinelli/comment-box.nvim" },

	-- todoを見やすくする
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
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
						location = "~/notes",
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
			vim.keymap.set({ "n", "x", "o" }, "<Leader>z", "<cmd>NoNeckPain<CR>", { desc = "[NoNeckPain]: Toggle" })
		end,
	},

	-- タグウィンドウを表示
	{
		"preservim/tagbar",
		keys = {
			{
				"<leader>s",
				"<cmd>TagbarToggle<CR>",
				desc = "[Tagbar]: 表示切り替え",
			},
		},
	},

	-- タブの表示をおしゃれにする
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "tabs",
				},
			})
		end,
	},

	-- ハイライト表示
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			highlight = { enabled = true },
		},
		config = function()
			require("nvim-treesitter").setup()

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
				callback = function(ctx)
					pcall(vim.treesitter.start)
				end,
			})
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
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
		dependencies = {
			"kevinhwang91/nvim-hlslens",
			"lewis6991/gitsigns.nvim",
		},
		config = function()
			require("scrollbar").setup()
		end,
	},

	-- Git

	-- 行番号の位置に差分を表示
	{
		"lewis6991/gitsigns.nvim",
		dependencies = "tpope/vim-fugitive",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
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
		"isakbm/gitgraph.nvim",
		dependencies = {
			"sindrets/diffview.nvim",
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
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			hooks = {
				on_select_commit = function(commit)
					print("selected commit:", commit.hash)
				end,
				on_select_range_commit = function(from, to)
					print("selected range:", from.hash, to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = false, max_count = 100 })
				end,
				desc = "[Git Graph]: 現在のブランチのみ",
			},
			{
				"<leader>gL",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "[GitGraph]: 全ブランチの表示",
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
				desc = "[GitBlame]: Toggle Virtual Blame",
			},
		},
		config = function()
			require("blame").setup()
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
		end,
	},

	-- 自動で括弧を閉じる
	{
		"windwp/nvim-autopairs",
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
		end,
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
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
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
			require("colorizer").setup()
		end,
	},

	-- 型シグネチャの表示
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			-- cfg options
			bind = true,
			handler_opts = {
				border = "rounded",
			},
		},
	},

	-- コードのアウトライン表示
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("aerial").setup({
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
			vim.keymap.set("n", "<leader>b", "<cmd>AerialToggle!<CR>", { desc = "[Aerial]: Toggle Aerial" })
		end,
	},

	-- インラインでdiagnosticメッセージを表示
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end,
	},

	-- その他
	{
		"simeji/winresizer",
		init = function()
			vim.g.winresizer_start_key = "<Leader>w"
		end,
	},

	-- ナビゲーション & 検索
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("flash").setup({
				modes = {
					char = {
						enabled = false,
					},
				},
			})

			vim.keymap.set({ "n", "x", "o" }, "<Leader>ff", function()
				require("flash").jump()
			end, { desc = "[Flash]: Jump" })
			vim.keymap.set({ "n", "x", "o" }, "<Leader>ft", function()
				require("flash").treesitter()
			end, { desc = "[Flash]: Treesiter" })
			vim.keymap.set({ "n", "x", "o" }, "<Leader>fs", function()
				require("flash").treesitter_search()
			end, { desc = "[Flash]: Treesitter Search" })
		end,
	},

	-- markdownの描画をリッチにする
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {},
		ft = { "markdown", "markdown.mdx", "Avante", "codecompanion" },
		keys = {
			{
				"<leader>mn",
				":RenderMarkdown toggle<CR>",
				desc = "[RenderMarkdown]: Markdown表示切替",
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
		keys = {
			{
				"<leader>mm",
				":MarkdownPreview<CR>",
				desc = "[MarkdownPreview]: markdownをブラウザで開く",
			},
		},
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},

	-- AI Coding
	{
		"olimorris/codecompanion.nvim",
		version = "v17.33.0",
		opts = {
			language = "japanese",
			display = {
				chat = {
					auto_scroll = false,
					show_header_separator = true,
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup()
			vim.keymap.set(
				{ "n", "v" },
				"<leader>cc",
				"<cmd>CodeCompanion<cr>",
				{ noremap = true, silent = true, desc = "[CodeCompanion]: Companion" }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				"<cmd>CodeCompanionActions<cr>",
				{ noremap = true, silent = true, desc = "[CodeCompanion]: Actions" }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>cd",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true, desc = "[CodeCompanion]: ChatToggle" }
			)

			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},
	-- AI Agent
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "zellij",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
		},
	},

  -- ハイライトのカラーリング
  {
    "y3owk1n/undo-glow.nvim",
    event = { "VeryLazy" },
    ---@type UndoGlow.Config
    opts = {
      animation = {
        enabled = true,
        duration = 300,
        animation_type = "zoom",
        window_scoped = true,
      },
      highlights = {
        undo = {
          hl_color = { bg = "#693232" }, -- Dark muted red
        },
        redo = {
          hl_color = { bg = "#2F4640" }, -- Dark muted green
        },
        yank = {
          hl_color = { bg = "#7A683A" }, -- Dark muted yellow
        },
        paste = {
          hl_color = { bg = "#325B5B" }, -- Dark muted cyan
        },
        search = {
          hl_color = { bg = "#5C475C" }, -- Dark muted purple
        },
        comment = {
          hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
        },
        cursor = {
          hl_color = { bg = "#793D54" }, -- Dark muted pink
        },
      },
      priority = 2048 * 3,
    },
    keys = {
      {
        "u",
        function()
          require("undo-glow").undo()
        end,
        mode = "n",
        desc = "Undo with highlight",
        noremap = true,
      },
      {
        "U",
        function()
          require("undo-glow").redo()
        end,
        mode = "n",
        desc = "Redo with highlight",
        noremap = true,
      },
      {
        "p",
        function()
          require("undo-glow").paste_below()
        end,
        mode = "n",
        desc = "Paste below with highlight",
        noremap = true,
      },
      {
        "P",
        function()
          require("undo-glow").paste_above()
        end,
        mode = "n",
        desc = "Paste above with highlight",
        noremap = true,
      },
      {
        "n",
        function()
          require("undo-glow").search_next({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search next with highlight",
        noremap = true,
      },
      {
        "N",
        function()
          require("undo-glow").search_prev({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search prev with highlight",
        noremap = true,
      },
      {
        "*",
        function()
          require("undo-glow").search_star({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search star with highlight",
        noremap = true,
      },
      {
        "#",
        function()
          require("undo-glow").search_hash({
            animation = {
              animation_type = "strobe",
            },
          })
        end,
        mode = "n",
        desc = "Search hash with highlight",
        noremap = true,
      },
      {
        "gc",
        function()
          -- This is an implementation to preserve the cursor position
          local pos = vim.fn.getpos(".")
          vim.schedule(function()
            vim.fn.setpos(".", pos)
          end)
          return require("undo-glow").comment()
        end,
        mode = { "n", "x" },
        desc = "Toggle comment with highlight",
        expr = true,
        noremap = true,
      },
      {
        "gc",
        function()
          require("undo-glow").comment_textobject()
        end,
        mode = "o",
        desc = "Comment textobject with highlight",
        noremap = true,
      },
      {
        "gcc",
        function()
          return require("undo-glow").comment_line()
        end,
        mode = "n",
        desc = "Toggle comment line with highlight",
        expr = true,
        noremap = true,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        callback = function()
          require("undo-glow").yank()
        end,
      })

      -- This only handles neovim instance and do not highlight when switching panes in tmux
      vim.api.nvim_create_autocmd("CursorMoved", {
        desc = "Highlight when cursor moved significantly",
        callback = function()
          require("undo-glow").cursor_moved({
            animation = {
              animation_type = "slide",
            },
          })
        end,
      })

      -- This will handle highlights when focus gained, including switching panes in tmux
      vim.api.nvim_create_autocmd("FocusGained", {
        desc = "Highlight when focus gained",
        callback = function()
          ---@type UndoGlow.CommandOpts
          local opts = {
            animation = {
              animation_type = "slide",
            },
          }

          opts = require("undo-glow.utils").merge_command_opts("UgCursor", opts)
          local pos = require("undo-glow.utils").get_current_cursor_row()

          require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
            s_row = pos.s_row,
            s_col = pos.s_col,
            e_row = pos.e_row,
            e_col = pos.e_col,
            force_edge = opts.force_edge == nil and true or opts.force_edge,
          }))
        end,
      })

      vim.api.nvim_create_autocmd("CmdlineLeave", {
        desc = "Highlight when search cmdline leave",
        callback = function()
          require("undo-glow").search_cmd({
            animation = {
              animation_type = "fade",
            },
          })
        end,
      })
    end,
  },
  -- nvim-dap
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    opts = {},
  },
  -- Godot
  {
    'Mathijs-Bakker/godotdev.nvim',
    dependencies = { 'nvim-lspconfig', 'nvim-dap', 'nvim-dap-ui', 'nvim-treesitter' },
  },
}
