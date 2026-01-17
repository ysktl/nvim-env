return {
	-- Linter
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local js_formatters = { "biome", "prettierd", "prettier" }
			require("conform").setup({
				formatters_by_ft = {
					-- Lua
					lua = { "stylua" },

					-- C, C++
					clang = { "clang_format" },
					cmake = { "cmake_format" },

					-- Python
					python = { "isort", "black" },

					-- Golang
					golang = { "gofmt", "goimports" },

					-- Rust
					rust = { "rustfmt", lsp_format = "fallback" },

					-- YAML
					yaml = { "yamlfmt" },

					-- TOML
					toml = { "tombi" },

					-- Protobuf
					protobuf = { "buf" },

					-- Dockerfile
					docker = { "dockerfmt" },

					-- Terraform
					terraform = { "terraform_fmt" },

					-- Ansible
					ansible = { "ansible-lint" },

					-- HTML
					html = { "html_beautify" },

					-- CSS
					css = { "css_beautify" },

					-- JavaScript
					json = js_formatters,
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					astro = js_formatters,

					-- Deno
					deno = { "deno_fmt" },

					-- Markdown
					markdown = { "markdownlint-cli2" },

					-- SQL
					sql = { "sqlfmt", "sqruff" },

					-- PostgreSQL
					postgresql = { "pg_format" },

					-- CockroachDB
					cockroachdb = { "crlfmt" },
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

	-- LSP本体
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			-- LSPの設定
			local blink = require("blink.cmp")

			-- blink.cmpのcapabilitiesを取得
			local capabilities = blink.get_lsp_capabilities()

			-- on_attach
			function on_attach(on_attach)
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local buffer = args.buf
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						on_attach(client, buffer)
					end,
				})
			end

			on_attach(function(client, buffer)
				-- on_attach 共通設定
			end)

			-- lsp-configで定義されていないLSPサーバーの設定

			-- Protobuf LSP
			vim.lsp.config.buf_ls = {
				capabilities = capabilities,
				filetypes = { "proto" },
				root_markers = { ".git" },
			}
			vim.lsp.enable("buf_ls")

			-- Terraform / Opentofu
			vim.cmd("autocmd BufNewFile,BufRead *.tf set filetype=terraform")
			vim.lsp.config.terraformls = {
				capabilities = capabilities,
				filetypes = { "terraform", "tf" },
			}
			vim.lsp.enable("terraformls")

			-- Yaml-Language-Server
			vim.lsp.config.yamlls = {
				capabilities = capabilities,
				filetypes = { "yaml", "yml" },
				cmd = { "yaml-language-server", "--stdio" },
			}
			vim.lsp.enable("yamlls")

			-- Lua LSP (lua-language-server)
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
			vim.lsp.enable("lua_ls")

			-- Python LSP (pylsp)
			vim.lsp.config.pylsp = {
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								ignore = { "W391" },
								maxLineLength = 100,
							},
						},
					},
				},
			}
			vim.lsp.enable("pylsp")

			-- Rust LSP (rust-analyzer)
			vim.lsp.config.rust_analyzer = {
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			}
			vim.lsp.enable("rust_analyzer")

			-- Go LSP (gopls)
			vim.lsp.config.gopls = {
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			}
			vim.lsp.enable("gopls")

			-- C/C++ LSP (clangd)
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
			}
			vim.lsp.enable("clangd")

			-- HTML LSP
			vim.lsp.config.html = {
				capabilities = capabilities,
				filetypes = { "html" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = {
						css = true,
						javascript = true,
					},
					provideFormatter = true,
				},
			}
			vim.lsp.enable("html")

			-- Bash LSP
			vim.lsp.config.bashls = {
				capabilities = capabilities,
				filetypes = { "sh", "bash", "zsh" },
			}
			vim.lsp.enable("bashls")

			-- Markdown LSP (markdown-oxide)
			vim.lsp.config.markdown_oxide = {
				capabilities = capabilities,
			}
			vim.lsp.enable("markdown_oxide")

    end
	},

	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		build = "cargo build --release",
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "super-tab" },

			appearance = {
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	-- Metals (Scala LSP)
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"saghen/blink.cmp",
		},
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.capabilities = require("blink.cmp").get_lsp_capabilities()
			metals_config.on_attach = function(client, bufnr)
				-- your on_attach function
			end

			return metals_config
		end,
		config = function(self, metals_config)
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end,
	},

  -- Typescript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- Pkl
  {
    "apple/pkl-neovim",
    lazy = true,
    ft = "pkl",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = function(_)
          vim.cmd("TSUpdate")
        end,
      },
      "L3MON4D3/LuaSnip",
    },
    build = function()
      require('pkl-neovim').init()

      -- Set up syntax highlighting.
      vim.cmd("TSInstall pkl")
    end,
    config = function()
      -- Set up snippets.
      require("luasnip.loaders.from_snipmate").lazy_load()

      -- Configure pkl-lsp
      vim.g.pkl_neovim = {
        start_command = { "java", "-jar", "/path/to/pkl-lsp.jar" },
        -- or if pkl-lsp is installed with brew:
        -- start_command = { "pkl-lsp" },
        pkl_cli_path = "/path/to/pkl"
      }
    end,
  },
}
