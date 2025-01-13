-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- Plugins
lvim.plugins = {
    "mfussenegger/nvim-jdtls", -- Java Language Server
    "catppuccin/nvim",         -- Catppuccin theme
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            vim.fn["mkdp#util#install"]()
            vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
        end,
    }, -- Markdown preview plugin
}

-- Theme and transparency settings
lvim.colorscheme = "catppuccin"
lvim.transparent_window = true

-- Skip Java language server automatic configuration
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

-- Treesitter Setup
lvim.builtin.treesitter.ensure_installed = {
    "java", -- Java language support
}

-- Language Server Manager
require("lvim.lsp.manager").setup("marksman")
require("lvim.lsp.manager").setup("ltex", {
    filetypes = { "markdown" },
    settings = {
        ltex = {
            language = "en-US",
        },
    },
})

-- Formatters and Linters for Markdown
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

-- Debug Adapter Protocol (DAP) Config for Java
local dap = require("dap")
dap.configurations.java = {
    {
        name = "Remote Debug",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1", -- Remote machine IP (if needed)
        port = 8000,            -- JDWP port
    },
}

-- File Explorer (NvimTree) Settings
lvim.builtin.nvimtree.setup.view.width = 70

-- Keybindings for Visual Mode
lvim.keys.visual_mode["<Tab>"] = ">gv"
lvim.keys.visual_mode["<S-Tab>"] = "<gv"

-- General Vim Settings
vim.opt.tabstop = 4           -- Number of spaces for <Tab>
vim.opt.shiftwidth = 4        -- Number of spaces for auto-indent
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.textwidth = 80        -- Max line length
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.tabstop = 2  -- Markdown uses 2 spaces for tab
        vim.opt_local.shiftwidth = 2 -- Indentation for Markdown
        vim.opt_local.expandtab = true -- Still convert tabs to spaces
    end,
})

-- Search pattern clean-up
lvim.keys.normal_mode["<leader>n"] = ":nohlsearch<CR>"

-- LuaSnip Configuration for snippet management
local luasnip = require "luasnip"
luasnip.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged,InsertLeave",
    region_check_events = "CursorMoved,InsertEnter",
}

-- Unlink snippets when they are deleted in Insert/Visual mode
lvim.keys.insert_mode["<C-l>"] = "<C-o>$<cmd>silent! LuaSnipUnlinkCurrent<CR>"
lvim.keys.insert_mode["<C-j>"] = "<C-o>o<cmd>silent! LuaSnipUnlinkCurrent<CR>"

-- ToggleTerm keymaps (for terminal windows)
function _G.set_toggleterm_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- Apply ToggleTerm keymaps only for specific terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        -- Only apply keymaps to ToggleTerm, excluding other terminal buffers (e.g., LazyGit)
        if bufname:match("term://.*toggleterm#") and not bufname:match("lazygit") then
            set_toggleterm_keymaps()
        end
    end,
})
