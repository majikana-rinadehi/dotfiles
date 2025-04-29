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
