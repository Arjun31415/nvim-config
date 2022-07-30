local dap = require('dap')

-- C, Cpp and Rust dap
local cppDap = require('config.Dap.cpp')
dap.adapters.cppdbg = cppDap.cppdb
dap.configurations.cppdbg = cppDap.cppConfig
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp


-- Python
local pythonDap = require('config.Dap.python')
dap.adapters.python = pythonDap.debugpy
dap.configurations.python = pythonDap.pythonConfig
