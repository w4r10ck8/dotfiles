vim.fn.jobstart("npm run typecheck 2>&1", {
  cwd = vim.fn.getcwd(),
  stdout_buffered = true,
  on_stdout = function(_, data)
    vim.notify(vim.inspect(data), vim.log.levels.INFO, { title = "TC output" })
  end,
})
