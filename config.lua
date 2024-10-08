-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.plugins = {
  "mfussenegger/nvim-jdtls",
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })


lvim.builtin.treesitter.ensure_installed = {
  "java",
}

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
-- clean search pattern 
lvim.keys.normal_mode["<leader>n"] = ":nohlsearch<CR>"
