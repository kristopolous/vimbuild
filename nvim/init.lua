-- Set leader key
-- sudo apt-get install -y ripgrep fd-find clangd
-- npm -g install typescript-language-server pyright prettier bash-language-server intelephense
-- pipx install black python-lsp-server php-cs-fixer
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.smartindent = false
vim.opt.autoindent = false
vim.cmd("filetype plugin indent on")
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.signcolumn = "no"

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Pyright with diagnostics off
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              diagnosticMode = "off",
            },
          },
        },
      })

      -- Typescript LSP
      lspconfig.ts_ls.setup({}) -- fallback if ts_ls fails to work

      -- Other language servers
      for _, server in ipairs({ "intelephense", "bashls", "clangd" }) do
        lspconfig[server].setup({})
      end
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.clang_format,
        },
        formatting = {
          format_on_save = false,
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format buffer" })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      
      -- Telescope keymaps
      vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
    end,
  },

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
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
      })
    end,
  },

  {
    "NMAC427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({
        auto_cmd = true,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "lua", "python", "javascript", "typescript", 
          "php", "bash", "c", "cpp", "json", "html", "css"
        },

      })
    end,
  },

  { "nvim-lua/plenary.nvim" },
})


-- Keymaps
vim.keymap.set("n", "<F8>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<M-w>", ":w<CR>", { silent = true, desc = "Save file" })
vim.keymap.set("n", "<M-q>", ":q<CR>", { silent = true, desc = "Quit window" })

