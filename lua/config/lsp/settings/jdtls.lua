-- nvim-lspconfig's lsp/jdtls.lua supplies cmd (with a per-project `-data`
-- workspace) and the root markers, so only settings belong here. Extra JVM
-- flags go in JDTLS_JVM_ARGS, which it forwards as --jvm-arg=.

return {
    init_options = {
        extendedClientCapabilities = {
            -- Without this, accepting a completion for an unimported type
            -- inserts the identifier but not the import statement.
            resolveAdditionalTextEditsSupport = true,
        },
    },
    settings = {
        java = {
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            inlayHints = { parameterNames = { enabled = "all" } },

            -- "automatic" re-imports the whole reactor on every pom change,
            -- which is minutes of CPU on a large multi-module repo.
            configuration = { updateBuildConfiguration = "interactive" },

            -- gI/gR cover this; the counts above every method are noise.
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },

            -- Never collapse to a wildcard; checkstyle rejects star imports.
            sources = {
                organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
            },

            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "org.junit.jupiter.api.Assumptions.*",
                    "org.mockito.Mockito.*",
                    "org.mockito.ArgumentMatchers.*",
                    "org.assertj.core.api.Assertions.*",
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },
        },
    },
}
