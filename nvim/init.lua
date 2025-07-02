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
-- <leader>ev: open init.lua
vim.keymap.set("n", "<leader>ev", ":edit $MYVIMRC<CR>", { desc = "Edit init.lua" })

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
      require("lualine").setup({
        options = { theme = "auto" },
        sections = {
          lualine_c = { { 'filename', path = 2 } }, -- Show absolute file path
        },
      })
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
  -- orgmode for org files
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      -- Set orgfiles folder path for reuse
      local orgfiles_path = '/mnt/c/Users/greed/Dropbox/Favorite/Notes/orgfiles'
      local org_refile_path = orgfiles_path .. '/refile.org'

      require('orgmode').setup({
        org_agenda_files = orgfiles_path .. '/**/*',
        org_default_notes_file = org_refile_path,
      })
      vim.keymap.set("n", "<leader>on", function()
        vim.cmd('edit ' .. org_refile_path)
      end, { desc = "Open org default notes file" })
      vim.keymap.set("n", "<leader>fo", function()
        require('telescope.builtin').find_files({ cwd = orgfiles_path })
      end, { desc = "Find Org Files" })
    end,
  },
  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-n>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                local prompt = current_picker:_get_prompt()
                local cwd = current_picker.cwd or vim.loop.cwd()
                actions.close(prompt_bufnr)
                if prompt ~= nil and prompt ~= "" then
                  local path = cwd .. "/" .. prompt
                  vim.cmd('edit ' .. vim.fn.fnameescape(path))
                else
                  vim.notify("No file name provided!", vim.log.levels.WARN)
                end
              end,
            },
          },
        },
      })
    end,
  },
  -- neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files by default
          },
        },
      })
    end,
  },
})

-- Insert mode: jk 跳回 normal mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

vim.opt.swapfile = false 

-- Remap Orgmode checkbox toggle from <C-Space> to <Leader>c in org files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    vim.keymap.set('n', '<Leader><Space>', function()
      require("orgmode").action("org_mappings.toggle_checkbox")
    end, { buffer = true, desc = 'Toggle Org checkbox (Leader+Space)' })
  end,
}) 

-- Telescope keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" })
vim.keymap.set("n", "<leader>fo", function()
  require('telescope.builtin').find_files({ cwd = orgfiles_path })
end, { desc = "Find Org Files" }) 
