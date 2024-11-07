return {
  "ethanholz/nvim-lastplace",
  config = function()
    require("nvim-lastplace").setup({
      lastplace_open_folds = true,
    })
  end,
}
