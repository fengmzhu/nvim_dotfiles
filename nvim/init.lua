-- 基本設定
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- 快捷鍵：<leader>q, wq, qq, qa
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>qq", ":q!<CR>")
vim.keymap.set("n", "<leader>qa", ":qa<CR>")
vim.keymap.set("n", "<leader>qaa", ":qa!<CR>")
vim.keymap.set("n", "<leader>w", ":w!<CR>")
vim.keymap.set("n", "<leader>wq", ":wq!<CR>")

-- lazy.nvim 啟動
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 2. EasyAlign
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = {"n", "x"}, desc = "EasyAlign" },
    },
  },
  -- 3. undotree
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
  },
  -- 4. vimwiki
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
    end,
    keys = {
      { "<leader>ww", ":VimwikiIndex<CR>", desc = "Vimwiki Index" },
    },
  },
  -- 5. lualine.nvim (airline 替代)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end,
  },
  -- 6. LuaSnip (UltiSnips 替代)
  {
    "L3MON4D3/LuaSnip",
    dependencies = {},
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- 9. marks.nvim (Mark 替代)
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup()
    end,
  },
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- colorscheme: catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- 啟動畫面：dashboard-nvim
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        config = {
          week_header = { enable = true },
          shortcut = {
            { desc = "󰊳 Update", group = "Label", action = "Lazy update", key = "u" },
            { desc = " Files", group = "Label", action = "Telescope find_files", key = "f" },
            { desc = " Home", group = "Label", action = "ene | startinsert", key = "h" },
          },
        },
      })
    end,
  },
  -- tmux 無縫切換：vim-tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
})

-- Insert mode: jk 跳回 normal mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" }) 