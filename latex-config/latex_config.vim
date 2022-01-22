let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,bibtex,pdf'
let g:Tex_CompileRule_pdf = 'pdflatex --synctex=-1 -src-specials -interaction=nonstopmode -file-line-error-style $*'
let g:livepreview_use_biber = 1
filetype plugin on
filetype plugin indent on
let g:vimtex_view_general_viewer = 'okular'