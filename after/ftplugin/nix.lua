local ft = require("guard.filetype")
ft("nix"):fmt({ cmd = "alejandra", stdin = true })
