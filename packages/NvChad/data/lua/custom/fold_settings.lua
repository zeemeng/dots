-- ABOUT FOLDING
-- The folding method can be set with the 'foldmethod' option.
--
-- There are six methods to select folds:
--	manual		manually define folds [This is the default]
--	indent		more indent means a higher fold level
--	expr		specify an expression to define folds
--	syntax		folds defined by [language syntax files]
--	diff		folds for unchanged text
--	marker		folds defined by markers in the text
--
-- Ideally, "precise" folding based on language syntax seems preferable,
-- however in practice, not all language syntax files define folds. Even for
-- some that do define folds, they might be rudimentary. Therefore, using
-- "indent" as the default "foldmethod", and if particular standard language syntax
-- files define folds, have "foldmethod" be set to "syntax" either automatically by
-- the syn file, or do it explicitly.
--
-- Refs:
-- https://vim.fandom.com/wiki/Folding
-- https://vim.fandom.com/wiki/Check_your_syntax_files_for_configurable_options
-- https://neovim.io/doc/user/fold.html
-- https://neovim.io/doc/user/syntax.html#%3Asyn-fold
-- https://vimhelp.org/syntax.txt.html
-- https://github.com/Konfekt/FastFold?tab=readme-ov-file#example-setup
--
-- NEOVIM SPECIFICS
-- Neovim provides enhanced folding capabilities via "nvim-treesitter", which uses 
-- the "expr" fold method by providing an "expr" evaluation function that generates
-- fold based on the syntax tree.
--
-- Refs:
-- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
-- https://stackoverflow.com/questions/77220511/neovim-fold-code-with-foldmethod-syntax-or-foldmethod-expr-depending-on-tre

local M = {}

local opt = vim.opt

opt.foldmethod = "indent"
opt.foldlevelstart = 99

-- Display a more useful summary of the folded content. See ref:
-- https://www.reddit.com/r/neovim/comments/sofaax/is_there_a_way_to_change_neovims_way_of/
M.custom_foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart)
  local numOfLines = vim.v.foldend - vim.v.foldstart
  local fillCount = vim.fn.winwidth("%") - #line - #tostring(numOfLines) - 14
  return line .. "  " .. string.rep(".", fillCount) .. " (" .. numOfLines .. " L)"
end
vim.opt.foldtext = "v:lua.require'custom.fold_settings'.custom_foldtext()"
vim.opt.fillchars = {
  fold = " ",  -- removes trailing dots. Mind that there is a whitespace after the " "
  eob = " ",  -- ensure that the "~" end-of-buffer markers do not appear
}

-- FOLDING FROM STANDARD SYN FILES
-- Automatic `set foldmethod=syntax` by syn files
vim.g.baan_fold=1
vim.g.baan_fold_block=1
vim.g.baan_fold_sql=1
vim.g.clojure_fold = 1
vim.g.fortran_fold = 1
vim.g.fortran_fold_conditionals = 1
vim.g.javaScript_fold = 1
vim.g.perl_fold = 1
vim.g.perl_fold_blocks = 1
vim.g.php_folding = 1
vim.g.r_syntax_folding = 1
vim.g.rst_fold_enabled = 1
vim.g.ruby_fold = 1
vim.g.sh_fold_enabled= 7
vim.g.tex_fold_enabled = 1
vim.g.vimsyn_folding = "afhHl"
vim.g.zsh_fold_enable = 1

-- Require explicit `set foldmethod=syntax`
vim.g.html_syntax_folding = 1
vim.g.xml_syntax_folding = 1
-- For C, you can add these lines in a file in the "after" directory in "runtimepath".
-- For Unix this would be: ~/.vim/after/syntax/c.vim. 
--     syn sync fromstart
--     set foldmethod=syntax

-- FOLDING NEEDED FROM EXTERNAL SYN FILES (e.g. from vim-polyglot, etc.)
-- vim.g.markdown_folding = 1
-- vim.g.rust_fold = 1

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function(ev)
    local ft = ev.match

    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    elseif ft == "c" or ft == "html" or ft == "xml" then
      vim.opt.foldmethod = "syntax"
      vim.cmd("syn sync fromstart")
    end
  end,
})

return M

