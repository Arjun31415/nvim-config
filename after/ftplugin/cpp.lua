local ft = require("guard.filetype")
ft("cpp"):fmt("clang-format"):lint("clang-tidy")
