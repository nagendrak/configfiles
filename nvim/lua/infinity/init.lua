vim.g.mapleader = ","

local set = vim.opt -- set options

local TAB_WIDTH = 2
set.tabstop = TAB_WIDTH -- how many columns a tab should be made up of in editor view
set.softtabstop = TAB_WIDTH -- number of spaces to be inserted/deleted upon a tab
set.shiftwidth = TAB_WIDTH -- spacing used for indentation
set.expandtab = true -- use spaces when tab is pressed
