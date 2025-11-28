return {
  -- Linter
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        terraform = { "tfsec" },
        tf = { "tfsec" },
      }

      -- 保存時に自動実行
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      -- 手動実行コマンド
      vim.keymap.set("n", "<leader>lt", function()
        lint.try_lint()
      end, { desc = "nvim-lint: Run tfsec" })
    end,
  },


  -- カスタムスニペットを使えるようにする
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
      vim.keymap.set('n', '<leader>@', require("luasnip.loaders").edit_snippet_files, { desc = "Edit snippets" })
    end
  },

  -- LSP本体
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
    },
    config = function()
      -- LSPの設定
      local lspconfig = require('lspconfig')
      local blink = require('blink.cmp')

      -- blink.cmpのcapabilitiesを取得
      local capabilities = blink.get_lsp_capabilities()

      -- lspconfigで定義されていないLSPサーバーの設定

      -- Protobuf LSP
      lspconfig.buf_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "proto" },
        root_dir = lspconfig.util.root_pattern(".git"),
      })

      -- Terraform / Opentofu
      vim.cmd("autocmd BufNewFile,BufRead *.tf set filetype=terraform")
      lspconfig.terraformls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "terraform", "tf" }
      })

      -- Lua LSP (lua-language-server)
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
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
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = { 'W391' },
                maxLineLength = 100
              }
            }
          }
        }
      })

      -- Rust LSP (rust-analyzer)
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
        on_attach = on_attach,
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
        on_attach = on_attach,
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
        on_attach = on_attach,
        cmd = {
          "elixir-ls"
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
          }
        }
      })

      -- HTML LSP
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {
            css = true,
            javascript = true
          },
          provideFormatter = true
        }
      })

      -- Bash LSP
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "sh", "bash", "zsh" },
      })

      -- Docker Compose LSP
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Markdown LSP (markdown-oxide)
      lspconfig.markdown_oxide.setup({
        capabilities = capabilities,
      })

      -- Node.js
      local is_node_dir = function()
        return lspconfig.util.root_pattern('package.json')(vim.fn.getcwd())
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
            }
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "relative",
            },
            suggest = {
              includeCompletionsForModuleExports = true,
            }
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
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "tsconfig.json", "jsconfig.json", ".git"),
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
    end
  },

  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },

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
      keymap = { preset = 'super-tab' },

      appearance = {
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = true } },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" }
  },

  -- JSON スキーマサポート（jsonls用）
  {
    "b0o/schemastore.nvim",
    ft = "json",
  },

  -- Haskell
  -- {
  --   'mrcjkb/haskell-tools.nvim',
  --   version = '^5', -- Recommended
  --   lazy = false,
  --   config = function()
  --     local ht = require('haskell-tools')
  --     local bufnr = vim.api.nvim_get_current_buf()
  --     local opts = { noremap = true, silent = true, buffer = bufnr, }
  --
  --     vim.keymap.set('n', '<space>ll', vim.lsp.codelens.run, opts, desc = "Haskell-tools: Run code lens")
  --     vim.keymap.set('n', '<space>la', ht.hoogle.hoogle_signature, opts, desc = "Haskell-tools: Hoogle signature")
  --     vim.keymap.set('n', '<space>le', ht.lsp.buf_eval_all, opts, desc = "Haskell-tools: Eval all")
  --     vim.keymap.set('n', '<leader>lr', ht.repl.toggle, opts, desc = "Haskell-tools: Toggle REPL")
  --     vim.keymap.set('n', '<leader>lb', function()
  --       ht.repl.toggle(vim.api.nvim_buf_get_name(0))
  --     end, opts, desc = "Haskell-tools: Toggle REPL (buffer)")
  --     vim.keymap.set('n', '<leader>lq', ht.repl.quit, opts, desc = "Haskell-tools: Quit REPL")
  --   end
  -- },

  -- Metals (Scala LSP)
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
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
    end
  },
}
