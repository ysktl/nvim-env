-- キーマップ用オプション
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Leader
vim.g.mapleader = ' '

-- JJ
keymap('i', 'jj', '<ESC>', { silent = true, desc = "Insertモードでjjを押すとEsc" })
keymap('i', 'jJ', '<ESC>', { silent = true, desc = "InsertモードでjJを押すとEsc" })

-- ウィンドウの分割
keymap('n', 'sv', '<C-w>v', { desc = "ウィンドウを垂直分割" })
keymap('n', 'ss', '<C-w>s', { desc = "ウィンドウを水平分割" })

-- カレントウィンドウを移動
keymap('n', 'sl', '<C-w>l', { desc = "ウィンドウを右に移動" })
keymap('n', 'sh', '<C-w>h', { desc = "ウィンドウを左に移動" })
keymap('n', 'sj', '<C-w>j', { desc = "ウィンドウを下に移動" })
keymap('n', 'sk', '<C-w>k', { desc = "ウィンドウを上に移動" })

-- ウィンドウの位置を移動
keymap('n', 'sL', '<C-w>L', { desc = "ウィンドウを右に移動" })
keymap('n', 'sH', '<C-w>H', { desc = "ウィンドウを左に移動" })
keymap('n', 'sJ', '<C-w>J', { desc = "ウィンドウを下に移動" })
keymap('n', 'sK', '<C-w>K', { desc = "ウィンドウを上に移動" })

-- タブ
keymap('n', '<Leader>n', ':tabnew<CR>', { desc = "新しいタブを開く" })


-- LSPベースのジャンプ（nvim-lspconfig）
keymap("n", "<Leader>ld", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "[LSP]: 定義を表示" })
keymap("n", "<Leader>ly", vim.lsp.buf.type_definition, { noremap = true, silent = true, desc = "[LSP]: 型定義を表示" })
keymap("n", "<Leader>lr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "[LSP]: リファレンスを表示" })
keymap("n", "<Leader>li", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "[LSP]: 実装を表示" })

-- emmet
keymap("i", "<C-e>", "<Plug>(emmet-expand-abbr)", { silent = true, desc = "[Emmet]: 展開" })

-- LSP カーソル下のエラー内容を表示する
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "[LSP]: カーソル下のエラー内容を表示" })

-- noh エイリアス
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = ":noh" })
