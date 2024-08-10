;; extends
; References:
; https://neovim.io/doc/user/treesitter.html#treesitter-query-modeline
; https://neovim.io/doc/user/treesitter.html#treesitter-highlight
; https://www.reddit.com/r/neovim/comments/m8zedt/how_to_change_a_particular_syntax_token_highlight/
; https://www.youtube.com/watch?v=v3o9YaHBM4Q
; TJ explains more advanced usage of Treesitter parsing to implement custom behaviours. More importantly in a buffer of the targeted filetype, hit ':e' to reload Treesitter changes.

(import_from_statement
  module_name: (dotted_name
    (identifier) @module.builtin)
  name: (dotted_name))

(import_statement
  name: (dotted_name
    (identifier) @module.builtin))

