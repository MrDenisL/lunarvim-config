-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
    "mfussenegger/nvim-jdtls",
    "catppuccin/nvim",
}
lvim.colorscheme = "catppuccin"
lvim.transparent_window = true
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })


lvim.builtin.treesitter.ensure_installed = {
    "java",
}
require("lvim.lsp.manager").setup("marksman")

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup {
  {
    name = "prettier",
    filetypes = { "markdown" }, -- Only for Markdown files
  },
}

local linters = require("lvim.lsp.null-ls.linters")
linters.setup {
  {
    name = "markdownlint",
    filetypes = { "markdown" },
  },
}

require("lvim.lsp.manager").setup("ltex", {
  filetypes = { "markdown" }, -- Enable only for Markdown files
  settings = {
    ltex = {
      language = "en-US", -- Set your preferred language
    },
  },
})
local dap = require("dap")

dap.configurations.java = {
    {
        -- Name of the configuration as it appears in the DAP menu
        name = "Remote Debug",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1", -- Replace with the IP address of the remote machine, if necessary
        port = 8000,            -- Default port for JDWP (Java Debug Wire Protocol)
        -- Optional: Specify the project root
    },
}
lvim.builtin.nvimtree.setup.view.width = 70
-- Indent selected lines with Tab and unindent with Shift-Tab in visual mode
lvim.keys.visual_mode["<Tab>"] = ">gv"
lvim.keys.visual_mode["<S-Tab>"] = "<gv"
-- Set tab width
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces
-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.tabstop = 2       -- Tab counts as 2 spaces
    vim.opt_local.shiftwidth = 2    -- Indentation uses 2 spaces
    vim.opt_local.expandtab = true  -- Still converts tabs to spaces
  end,
})
-- clean search pattern
lvim.keys.normal_mode["<leader>n"] = ":nohlsearch<CR>"

-- LuaSnip autocommand to unlink snippets if deleted
vim.api.nvim_exec([[
  augroup CustomLuaSnip
    au!
    au TextChanged,InsertLeave * lua require'luasnip'.unlink_current_if_deleted()
  augroup END
]], false)
lvim.keys = vim.tbl_deep_extend("force", lvim.keys, {
    insert_mode = {
        ["<C-l>"] = "<C-o>$<cmd>silent! LuaSnipUnlinkCurrent<CR>",
        ["<C-j>"] = "<C-o>o<cmd>silent! LuaSnipUnlinkCurrent<CR>",
    }
})
local luasnip = require "luasnip"

luasnip.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,InsertLeave", -- or maybe "InsertLeave"
    region_check_events = "CursorMoved,InsertEnter", -- or maybe "InsertEnter"
}

function _G.set_toggleterm_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    -- Only apply keymaps to ToggleTerm and exclude LazyGit or other terminals
    if bufname:match("term://.*toggleterm#") and not bufname:match("lazygit") then
      set_toggleterm_keymaps()
    end
  end,
})
