" vim-plug 自動インストール
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" プラグイン設定
call plug#begin('~/.vim/plugged')

" ファイル操作系
Plug 'preservim/nerdtree'                  " ファイルエクスプローラー
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                     " ファジーファインダー

" 編集補助系
Plug 'tpope/vim-surround'                   " 囲み文字の操作
Plug 'tpope/vim-commentary'                 " コメントアウト

" UI改善系
Plug 'itchyny/lightline.vim'                " ステータスライン

" Git連携
Plug 'tpope/vim-fugitive'                   " Git操作

call plug#end()

" エンコーディング設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

" ターミナルの文字コードを設定
set termencoding=utf-8

" 日本語表示を可能にする
set helplang=ja

" 基本設定
set nocompatible            " Vim互換モードを無効化
set number                  " 行番号
set cursorline              " カーソル行のハイライト
set tabstop=4               " タブ幅
set shiftwidth=4            " 自動インデント幅
set expandtab               " タブをスペースに変換
set autoindent              " 自動インデント
syntax on                   " シンタックスハイライト
set background=dark         " ダーク背景向けカラー

" 検索系
set hlsearch                " ハイライト検索
set incsearch               " インクリメンタル検索
set ignorecase              " 小文字検索を大文字と区別しない
set smartcase               " 大文字入力時は大文字のみ検索

" 編集操作
set backspace=indent,eol,start " バックスペース強化
set clipboard=unnamedplus      " システムクリップボード連携

" カラースキーム（例desert）
colorscheme desert

" リーダーキーの設定
let mapleader = "\<Space>"

" ====================
" プラグイン設定
" ====================

" NERDTree設定
nnoremap <leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1              " 隠しファイルを表示
let NERDTreeIgnore=['\.git$', '\.DS_Store$']  " 無視するファイル

" fzf.vim設定
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>r :Rg<CR>
let g:fzf_layout = { 'down': '40%' }  " fzfウィンドウのレイアウト

" vim-commentary設定
" gcc で現在行をコメントアウト
" gc{motion} で指定範囲をコメントアウト
" ビジュアルモードで gc でコメントアウト

" lightline設定
set laststatus=2
set noshowmode  " モード表示を消す（lightlineが表示するため）
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" vim-fugitive設定
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
