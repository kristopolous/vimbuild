-- Set leader key
vim.g.mapleader = " "

-- Basic Neovim options
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Disable built-in indent guessing — we'll rely on Treesitter + guess-indent
vim.opt.smartindent = false
vim.opt.autoindent = false
vim.cmd("filetype plugin indent on") -- enable filetype indent scripts for fallback

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

-- Plugin setup
require("lazy").setup({
   -- LSP config plugin
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- Pyright with diagnostics off
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              diagnosticMode = "off",  -- disables error/warning messages
            },
          },
        },
      })

      lspconfig.ts_ls.setup({})

      -- Other language servers with default config
      local servers = { "intelephense", "bashls", "clangd" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({})
      end
    end,
  },

  -- null-ls for external formatters and linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.clang_format,
        },
      })
    end,
  },

  -- Telescope for fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
  -- guess-indent for automatic indentation detection
  {
    "NMAC427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({
        auto_cmd = true,
      })
    end,
  },

  -- Treesitter for highlighting & indenting
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

  -- null-ls for formatting
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.black,
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = false })
      end, { desc = "Format buffer" })
    end,
  },

  -- Plenary dependency for null-ls
  { "nvim-lua/plenary.nvim" },
})

-- Optional: format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})


vim.keymap.set("n", "<F8>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set('n', '<M-w>', ':w<CR>', { silent = true, desc = "Save file" })
vim.keymap.set('n', '<M-q>', ':q<CR>', { silent = true, desc = "Quit window" })
