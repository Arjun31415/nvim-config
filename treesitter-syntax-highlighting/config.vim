lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = {
    "beancount","clojure","commonlisp","c_sharp",
    "cuda","d","devicetree","dot","elixir","erlang","elm",
    "fennel","foam","fusion","go","godot","glsl","glimmer",
    "gowork","gomod","graphql","godot_resource","gdscript","hcl","heex",
    "hjson","julia","kotlin","ledger","llvm","ninja","nix",
    "ocaml","ocaml_interface","ocamllex","pascal","php",
    "pioasm","prisma","pug","ql","query","r","rasi","rst","ruby","rust",
    "scala","sparql","supercollider","surface","svelte","teal",
    "tlaplus","toml","turtle","verilog","vue","yang","zig"
 },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {"rust","go" },
    custom_captures = {
        -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
        ["foo.bar"] = "Identifier",
      },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF