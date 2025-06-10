return {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
        require("competitest").setup({
            received_contests_directory = "$(CWD)",
            received_contests_problems_path = "$(JAVA_TASK_CLASS).$(FEXT)",
        })
    end,
    event = "VeryLazy",
}
