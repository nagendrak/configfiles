vim.g.mapleader = ","

local set = vim.opt -- set options

local TAB_WIDTH = 2
set.tabstop = TAB_WIDTH -- how many columns a tab should be made up of in editor view
set.softtabstop = TAB_WIDTH -- number of spaces to be inserted/deleted upon a tab
set.shiftwidth = TAB_WIDTH -- spacing used for indentation
set.expandtab = true -- use spaces when tab is pressed

-- Disable mouse support by default
vim.opt.mouse = ""

-- Toggle mouse on/off (<leader>tm)
vim.keymap.set("n", "<leader>tm", function()
  if vim.opt.mouse:get()["a"] or vim.opt.mouse:get()["n"] then
    vim.opt.mouse = ""
    vim.notify("Mouse disabled", vim.log.levels.INFO)
  else
    vim.opt.mouse = "a"
    vim.notify("Mouse enabled (all modes)", vim.log.levels.INFO)
  end
end, { desc = "Toggle mouse mode" })

-- Sync unnamed register with system clipboard
vim.opt.clipboard = "unnamedplus"

-- Configure built-in OSC 52 clipboard provider
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
