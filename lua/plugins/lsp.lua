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

					-- Crystal
					crystal = { "crystal" },

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

					-- KCL
					kcl = { "kcl" },

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
			local lspconfig = require("lspconfig")
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

			-- lspconfigで定義されていないLSPサーバーの設定

			-- Protobuf LSP
			lspconfig.buf_ls.setup({
				capabilities = capabilities,
				filetypes = { "proto" },
				root_dir = lspconfig.util.root_pattern(".git"),
			})

			-- Terraform / Opentofu
			vim.cmd("autocmd BufNewFile,BufRead *.tf set filetype=terraform")
			lspconfig.terraformls.setup({
				capabilities = capabilities,
				filetypes = { "terraform", "tf" },
			})

			-- Yaml-Language-Server
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				filetypes = { "yaml", "yml" },
				cmd = { "yaml-language-server", "--stdio" },
			})

			-- Lua LSP (lua-language-server)
			lspconfig.lua_ls.setup({
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
			})

			-- Python LSP (pylsp)
			lspconfig.pylsp.setup({
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
			})

			-- Rust LSP (rust-analyzer)
			lspconfig.rust_analyzer.setup({
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
			})

			-- Go LSP (gopls)
			lspconfig.gopls.setup({
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
			})

			-- C/C++ LSP (clangd)
			lspconfig.clangd.setup({
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
				root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
			})

			-- elixir-ls
			lspconfig.elixirls.setup({
				capabilities = capabilities,
				cmd = {
					"elixir-ls",
				},
				filetypes = { "elixir", "eelixir", "heex", "surface" },
				root_dir = lspconfig.util.root_pattern("mix.exs", ".git"),
				settings = {
					elixirLs = {
						suggestSpecs = true,
						dialyzerEnabled = true,
						mixEnv = "dev",
						fetchDeps = false,
						additionalWatchedExtensions = { "heex" },
						projectDir = "",
						enableTestLenses = true,
						mixFormat = true,
					},
				},
			})

			-- HTML LSP
			lspconfig.html.setup({
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
			})

			-- Bash LSP
			lspconfig.bashls.setup({
				capabilities = capabilities,
				filetypes = { "sh", "bash", "zsh" },
			})

			-- Docker Compose LSP
			lspconfig.docker_compose_language_service.setup({
				capabilities = capabilities,
			})

			-- Jsonnet
			lspconfig.jsonnet.setup({
				capabilities = capabilities,
				filetypes = { "jsonnet", "--stdio" },
				cmd = { "jsonnet-language-server" },
			})

			-- Markdown LSP (markdown-oxide)
			lspconfig.markdown_oxide.setup({
				capabilities = capabilities,
			})

			-- Node.js
			local is_node_dir = function()
				return lspconfig.util.root_pattern("package.json")(vim.fn.getcwd())
			end

			-- ts_ls
			local ts_opts = {
				capabilities = capabilities,
				init_options = {
					preferences = {
						importModuleSpecifierPreference = "relative",
						includeCompletionsForModuleExports = "auto",
					},
				},
				settings = {
					typescript = {
						preferences = {
							importModuleSpecifier = "relative",
						},
						suggest = {
							includeCompletionsForModuleExports = true,
						},
					},
					javascript = {
						preferences = {
							importModuleSpecifier = "relative",
						},
						suggest = {
							includeCompletionsForModuleExports = true,
						},
					},
				},
			}
			ts_opts.on_attach = function(client)
				if not is_node_dir() then
					client.stop(true)
				end
			end
			lspconfig.ts_ls.setup(ts_opts)

			-- denols
			local deno_opts = {
				capabilities = capabilities,
				root_dir = lspconfig.util.root_pattern(
					"deno.json",
					"deno.jsonc",
					"tsconfig.json",
					"jsconfig.json",
					".git"
				),
				init_options = {
					lint = true,
					unstable = true,
					suggest = {
						paths = true,
						autoImports = true,
					},
				},
				settings = {
					deno = {
						enable = true,
						lint = true,
						unstable = true,
						suggest = {
							paths = true,
							autoImports = true,
						},
					},
				},
			}
			deno_opts.on_attach = function(client)
				if is_node_dir() then
					client.stop(true)
				end
			end
			lspconfig.denols.setup(deno_opts)
		end,
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

			sources = {
				default = { "mooncake", "lsp", "path", "snippets", "buffer" },
				providers = {
					mooncake = {
						name = "mooncakes",
						module = "moonbit.mooncakes.completion.blink",
						opts = { max_items = 100 },
					},
				},
			},

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

	-- Moonbit
	{
		"moonbit-community/moonbit.nvim",
		ft = { "moonbit" },
		opts = {
			mooncakes = {
				virtual_text = true, -- virtual text showing suggestions
				use_local = true, -- recommended, use index under ~/.moon
			},
			-- optionally disable the treesitter integration
			treesitter = {
				enabled = true,
				-- Set false to disable automatic installation and updating of parsers.
				auto_install = true,
			},
			-- configure the language server integration
			-- set `lsp = false` to disable the language server integration
			lsp = {
				-- provide an `on_attach` function to run when the language server starts
				on_attach = function(client, bufnr) end,
				-- provide client capabilities to pass to the language server
				capabilities = vim.lsp.protocol.make_client_capabilities(),
			},
		},
	},
}
