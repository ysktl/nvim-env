-- 基本設定
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "cp932", "euc-jp", "iso-2022-jp" }
vim.opt.fileformats = { "unix", "dos" }
vim.opt.fileformat = "unix"

-- タブ・インデント
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

-- 行番号表示
vim.opt.number = true
vim.opt.relativenumber = false

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 表示設定
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5

-- ステータスライン
vim.opt.laststatus = 2

-- バックアップ/スワップ
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- クリップボード共有
vim.opt.clipboard = "unnamedplus"

-- コマンド行の高さ
vim.opt.cmdheight = 1

-- タイムアウト
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- モード表示無効（airline 使用を想定）
vim.opt.showmode = false

-- ファイル読み込み後の自動更新
vim.opt.autoread = true

-- カーソルの見た目
vim.opt.guicursor = ""

-- マウス使用（必要に応じて）
vim.opt.mouse = "a"

-- 色設定（お好みに応じて）
vim.cmd [[
  filetype plugin indent on
]]

-- Nerdfontを使えるようにする
vim.opt.termguicolors = true

-- ウィンドウの不透明度
vim.opt.winblend = 0

-- ポップアップメニューの不透明度
vim.opt.pumblend = 0

-- コマンド補完をメニューから選択可能に
vim.opt.wildmenu = true

-- Neovim 用（ターミナルタイトルを変更しない）
vim.opt.title = false

-- ヤンクのハイライト
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#E3CC00" })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
  end,
})

-- 自動で改行コードを修正
vim.opt.fixendofline = true
vim.opt.endofline = true
