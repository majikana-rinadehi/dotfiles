" 行番号設定
set number

" エンコーディング設定
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

" ターミナルの文字コードを設定
set termencoding=utf-8

" 日本語表示を可能にする
set helplang=ja

" o で改行を追加できるようにする
nnoremap O :<C-u>call append(expand('.'), '')<Cr>j
