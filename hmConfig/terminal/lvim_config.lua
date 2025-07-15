-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.opt.relativenumber = true -- relative line numbers

-- lvim options
lvim.builtin.lir.active = false -- i use oil.nvim

-- disable line moving
lvim.keys.normal_mode["<A-k>"] = false
lvim.keys.normal_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-j>"] = false
lvim.keys.visual_block_mode["<A-k>"] = false

-- Set the backspace option
vim.o.backspace = 'indent,eol,start'

lvim.keys.insert_mode["<A-Up>"] = false
lvim.keys.insert_mode["<A-Down>"] = false
lvim.keys.insert_mode["<A-Left>"] = false
lvim.keys.insert_mode["<A-Right>"] = false

lvim.keys.insert_mode["<Esc><Up>"] = false
lvim.keys.insert_mode["<Esc><Down>"] = false
lvim.keys.insert_mode["<Esc><Left>"] = false
lvim.keys.insert_mode["<Esc><Right>"] = false

lvim.keys.insert_mode["<C-BS>"] = "<C-W>"
lvim.keys.normal_mode["<C-n>"] = "<cmd>noh<cr>"
lvim.keys.normal_mode["<leader>f"] = "<cmd>Telescope find_files<cr>"
lvim.builtin.which_key.mappings["f"] = {}
lvim.lsp.buffer_mappings.normal_mode["<leader>la"] = nil;


-- Custom function to open folder in oil.nvim, file normally
local function open_in_oil_or_edit(node)
  if node.type == "directory" then
    vim.cmd("Oil " .. node.absolute_path)
  else
    require("nvim-tree.api").node.open.edit()
  end
end

lvim.builtin.nvimtree.setup.on_attach = function(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings (optional if you want to keep them)
  api.config.mappings.default_on_attach(bufnr)

  -- Override `o` key
  vim.keymap.set("n", "o", function()
    local node = api.tree.get_node_under_cursor()
    if node then
      open_in_oil_or_edit(node)
    end
  end, opts("Open in Oil"))
end

lvim.plugins = {
  { -- autosave
    "Pocco81/auto-save.nvim",
    config = true,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open neogit" }
    }
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = true,
    keys = {
      { "<leader>la", function() require("tiny-code-action").code_action() end, desc = "Code action" }
    }
  },
  {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      picker = "telescope",
    },
    keys = {
      { "<leader>sm", function() require('cppman').search() end, desc = "Open cpp manual" }
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      max_width = 40,
      render = "wrapped-compact",
      background_colour = "#000000",
    },
    lazy = false,
    init = function()
      vim.notify = require("notify");
    end
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    cmd = "Scratch",
  },
  {
    "neovim/nvim-lspconfig",
    name = "lspconfig.nixd",
    ft = { "nix" },
    opts = {},
    config = function(_, opts)
      require("lspconfig").nixd.setup(opts)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
  },
  {
    "gennaro-tedesco/nvim-peekup",
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true, -- replaces netrw
        view_options = {
          show_hidden = true,
        },
        keymaps = {
        },
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>z", "<cmd>ZenMode<cr>" },
    },
  },
}
