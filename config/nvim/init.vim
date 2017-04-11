set runtimepath+=~/.config/nvim
runtime! userautoload/*.vim

if !&compatible
   set nocompatible
endif
set runtimepath+=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.config/nvim/dein'))
  " パッケージ管理
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('tpope/vim-endwise')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('Shougo/unite.vim.git')
  call dein#add('Shougo/vimshell.git')
  call dein#add('vim-scripts/taglist.vim.git')
  call dein#add('itchyny/lightline.vim')

  call dein#add('Shougo/deoplete.nvim')
  " Ruby
  "call dein#add('osyo-manga/vim-monster')
  " Python
  call dein#add('davidhalter/jedi-vim')
  " TeX
  call dein#add('lervag/vimtex')
  call dein#add('thinca/vim-quickrun')

  " 静的解析
  call dein#add('scrooloose/syntastic')
  call dein#add('kevinw/pyflakes-vim')

  " elixir
  call dein#add('elixir-lang/vim-elixir')

  " カラースキーマ
  call dein#add('w0ng/vim-hybrid')
  call dein#add('tomasr/molokai')
  call dein#add('miyakogi/seiya.vim')
call dein#end()

let g:deoplete#enable_at_startup = 1
let g:quickrun_config = {
\   'tex': {
\       'command': 'latexmk',
\       'exec': ['%c -gg -pdfdvi %s', 'open %s:r.pdf']
\   },
\}

let g:deoplete#omni_patterns = {}
"let g:deoplete#omni_patterns.ruby =
"\ ['[^. *\t]\.\w*', '\h\w*::']

" --------------------------------
" 基本設定
" --------------------------------
" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on

syntax on
set autoindent
set title
set incsearch
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/" 全角スペースの表示
set number
set title
set ruler

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
set autoindent
set expandtab
set shiftwidth=4
set smarttab
set tabstop=4
set mouse=
" backspaceキーの挙動を設定する
" indent        : 行頭の空白の削除を許す
" eol           : 改行の削除を許す
" start         : 挿入モードの開始位置での削除を許す
set backspace=indent,eol,start
set laststatus=2
set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=%l,%c%V%8P

" 空白文字の可視化
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" <TAB>: completion.                                         
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" カラースキーム
set t_Co=256
set background=dark
colorscheme hybrid
highlight Normal ctermbg=none
