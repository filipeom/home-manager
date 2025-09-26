vim.g.tex_flavor = 'latex'
vim.g.vimtex_error_format = 1  -- Display errors in file-line format
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_view_options = '--synctex-forward %l:%c:%f --unique %p'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_compiler_latexmk = {
  out_dir = '_build',   -- Store output in 'build' directory
  continuous = 1,      -- Auto-recompile on save
  callback = 1,
  executable = 'latexmk',
  options = {
    '-xelatex',
    '-synctex=1',
    '-interaction=nonstopmode',
    '-shell-escape'
  }
}
  -- options = {
  --   '-pdf',
  --   '-shell-escape',
  --   '-verbose',
  --   '-synctex=1',
  --   '-interaction=nonstopmode',
  -- },
-- }
