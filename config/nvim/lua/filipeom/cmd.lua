local autocmd = vim.api.nvim_create_autocmd

-- On entering a buffer go to last known cursor position
-- autocmd("BufWinEnter", {
--   pattern = { "*" },
--   command = 'silent! normal! g`"',
-- })

-- On entering a buffer restore last view
autocmd("BufWinEnter", {
  pattern = { "*.md" },
  command = 'loadview',
})

-- On leaving create the view
autocmd("BufWinLeave", {
  pattern = { "*.md" },
  command = 'mkview',
})

-- Remove whitespace before saving file
autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- Invoke dune on 'ocaml' filetypes
autocmd("Filetype", {
  pattern = { "ocaml", "dune" },
  command = [[ setlocal makeprg=dune\ build\ @all ]]
})

-- Invoke cargo on 'rust' filetypes
autocmd("Filetype", {
  pattern = { "rust", "toml" },
  command = [[ setlocal makeprg=cargo\ build ]]
})
