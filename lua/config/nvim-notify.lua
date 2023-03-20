local nvim_notify = require("notify")
--[[ nvim_notify.setup({
  -- Animation style
  stages = "fade_in_slide_out",
  -- Default timeout for notifications
  timeout = 3000,
  max_height = function() return math.floor(vim.o.lines * 0.75) end,
  max_width = function() return math.floor(vim.o.columns * 0.75) end,
  background_color = nil,
}) ]]
vim.notify = nvim_notify
