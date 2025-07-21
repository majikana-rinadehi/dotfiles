# Vimプラグイン使用ガイド

このドキュメントでは、導入したVimプラグインの基本的な使い方を説明します。

## インストール方法

新しい環境でプラグインをインストールするには、Vimを起動して以下のコマンドを実行します：

```vim
:PlugInstall
```

## プラグイン一覧と使い方

### 1. NERDTree（ファイルエクスプローラー）

**基本操作：**
- `<Space>n` - NERDTreeの表示/非表示を切り替え
- `o` - ファイルを開く（カーソル位置のファイル）
- `t` - 新しいタブでファイルを開く
- `i` - 水平分割でファイルを開く
- `s` - 垂直分割でファイルを開く
- `I` - 隠しファイルの表示/非表示を切り替え
- `R` - ツリーを更新

### 2. fzf.vim（ファジーファインダー）

**キーマッピング：**
- `<Space>f` - カレントディレクトリ以下のファイルを検索
- `<Space>g` - Gitリポジトリ内のファイルを検索
- `<Space>b` - 開いているバッファを検索
- `<Space>r` - ripgrepを使用してファイル内容を検索

**fzfウィンドウ内での操作：**
- `Ctrl-j/k` - 選択の移動
- `Enter` - ファイルを開く
- `Ctrl-t` - 新しいタブで開く
- `Ctrl-x` - 水平分割で開く
- `Ctrl-v` - 垂直分割で開く

### 3. vim-surround（囲み文字の操作）

**基本操作：**
- `cs"'` - ダブルクォートをシングルクォートに変更
- `cs'<q>` - シングルクォートを`<q>`タグに変更
- `cst"` - タグをダブルクォートに変更
- `ds"` - ダブルクォートを削除
- `ysiw)` - カーソル位置の単語を括弧で囲む
- `yss)` - 行全体を括弧で囲む

**ビジュアルモード：**
- `S"` - 選択範囲をダブルクォートで囲む

### 4. vim-commentary（コメントアウト）

**基本操作：**
- `gcc` - 現在行をコメントアウト/解除
- `gc{motion}` - 指定範囲をコメントアウト
  - `gcap` - 段落をコメントアウト
  - `gc5j` - 現在行から5行下までをコメントアウト
- ビジュアルモードで`gc` - 選択範囲をコメントアウト

### 5. lightline.vim（ステータスライン）

自動的に有効になり、以下の情報を表示します：
- 現在のモード（Normal/Insert/Visual等）
- Gitブランチ名（vim-fugitiveと連携）
- ファイル名
- 変更状態
- ファイルタイプ
- カーソル位置

### 6. vim-fugitive（Git操作）

**キーマッピング：**
- `<Space>gs` - Git status（`:Git`）
- `<Space>gc` - Git commit
- `<Space>gp` - Git push
- `<Space>gl` - Git log
- `<Space>gd` - 現在のファイルのdiffを表示

**Git statusウィンドウでの操作：**
- `-` - ファイルをステージング/アンステージング
- `=` - ファイルのdiffを表示
- `Enter` - ファイルを開く

## トラブルシューティング

### プラグインがインストールされない場合

1. インターネット接続を確認
2. Vimを再起動して`:PlugInstall`を実行
3. エラーメッセージを確認

### キーマッピングが動作しない場合

1. `.vimrc`が正しく読み込まれているか確認：`:echo $MYVIMRC`
2. プラグインがインストールされているか確認：`:PlugStatus`
3. キーマッピングの競合を確認：`:verbose map <Space>`

## 参考リンク

- [vim-plug](https://github.com/junegunn/vim-plug)
- [NERDTree](https://github.com/preservim/nerdtree)
- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [vim-surround](https://github.com/tpope/vim-surround)
- [vim-commentary](https://github.com/tpope/vim-commentary)
- [lightline.vim](https://github.com/itchyny/lightline.vim)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)