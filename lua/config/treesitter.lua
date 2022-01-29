require("nvim-treesitter.configs").setup({
    ensure_installed = {"python", "cpp", "lua", "vim","java","typescript","javascript","html","css"},
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
     }, -- List of parsers to ignore installing
     
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {"rust","go" }, -- list of language that will be disabled
    },
  })