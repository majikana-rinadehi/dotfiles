# dotfiles

個人用のdotfiles（設定ファイル）を管理するリポジトリです。

## インストール方法

### 方法1: install.shスクリプトを使用
```sh
$ git clone https://github.com/majikana-rinadehi/dotfiles.git
$ cd dotfiles
$ ./install.sh
```

### 方法2: Makeコマンドを使用
```sh
$ git clone https://github.com/majikana-rinadehi/dotfiles.git
$ cd dotfiles
$ make i
```

インストール後、設定を反映させるために**ターミナルを再起動**してください。

## ファイル構成

### 主要な設定ファイル

| ファイル名 | 説明 |
|-----------|------|
| `.zshrc` | Zshの設定ファイル。エイリアス、関数、プラグインの読み込みなど |
| `.bashrc` | Bashの設定ファイル |
| `.shell_common` | Bash/Zsh共通の設定（エイリアス、環境変数など） |
| `.vimrc` | Vimの設定ファイル |
| `.tmux.conf` | tmuxの設定ファイル |
| `.gitconfig` | Gitのグローバル設定（シンボリックリンクで管理） |
| `.p10k.zsh` | Powerlevel10kテーマの設定 |
| `.dircolors` | lsコマンドの色設定 |

### プラグイン

`.plugins/` ディレクトリには以下のZshプラグインが含まれています：

- **powerlevel10k**: 高機能なZshテーマ
- **zsh-autosuggestions**: コマンド履歴に基づく自動補完
- **zsh-syntax-highlighting**: コマンドのシンタックスハイライト

### スクリプト

| ファイル名 | 説明 |
|-----------|------|
| `install.sh` | dotfilesをホームディレクトリにシンボリックリンクを作成するスクリプト |
| `Makefile` | makeコマンド用の設定（`make i`でinstall.shを実行） |

## 設定ファイルの追加方法

新しい設定ファイルを追加する場合：

1. このリポジトリのルートディレクトリに設定ファイルを配置
   ```sh
   $ cp ~/.your_config_file ./
   ```

2. `install.sh`を再実行してシンボリックリンクを作成
   ```sh
   $ ./install.sh
   ```

**注意**: 以下のファイルは自動的に除外されます：
- `.git`
- `.github`
- `.DS_Store`
- `.shell_common`（別途処理されるため）

## 主な機能とエイリアス

### Git関連
- `g`: git
- `ga`: git add
- `gb`: git branch
- `gl`: git log --graph
- `gst`: git status
- `gc`: git add . && git commit
- `gcp`: git add . && git commit -m "Update" && git push

### ディレクトリ移動
- `sd`: ghqとpecoを使用したリポジトリ間の移動
- `..`: 親ディレクトリへ移動
- `...`: 2つ上の親ディレクトリへ移動

### Docker関連
- `d`: docker
- `dc`: docker compose
- `dcu`: docker compose up
- `dcud`: docker compose up -d

### その他の便利な機能
- `mkcd`: ディレクトリを作成して移動
- `findr`: ファイル名の正規表現検索
- `ll`, `la`, `lh`: ls関連のエイリアス

## 今後の設定充実化案

### 1. プラグイン管理の改善
- Zshプラグインマネージャー（zinit, zplugなど）の導入
- プラグインの自動インストール機能

### 2. OS別の設定分離
- macOS/Linux/WSL別の設定ファイル
- OS検出による自動設定切り替え

### 3. バックアップ機能
- 既存の設定ファイルの自動バックアップ
- バックアップからの復元機能

### 4. セットアップの自動化
- 必要なツール（ghq、peco、tmuxなど）の自動インストール
- フォントのインストール自動化

### 5. ドキュメントの充実
- 各エイリアスの詳細な使用例
- トラブルシューティングガイド
- カスタマイズガイド

### 6. テスト機能
- 設定ファイルの妥当性チェック
- シンボリックリンクの整合性確認

### 7. アンインストール機能
- シンボリックリンクの削除スクリプト
- 設定の完全削除オプション

## Git設定の管理

### .gitconfigの仕組み
- `.gitconfig`はシンボリックリンクとしてdotfilesから管理されます
- ユーザー固有の設定（user.name、user.emailなど）は`~/.gitconfig.local`に保存されます
- `.gitconfig`内の`[include]`セクションにより、`.gitconfig.local`が自動的に読み込まれます

### ユーザー設定の方法
```sh
# ユーザー名とメールアドレスの設定
$ git config --file ~/.gitconfig.local user.name "Your Name"
$ git config --file ~/.gitconfig.local user.email "your.email@example.com"

# その他のローカル設定も同様に追加可能
$ git config --file ~/.gitconfig.local core.editor "your-favorite-editor"
```

## iTerm2の設定

### インストール
```sh
# Brewfileを使用してiTerm2をインストール
$ brew bundle

# または個別にインストール
$ brew install --cask iterm2
```

### セットアップ
```sh
# iTerm2の設定をセットアップ
$ ./scripts/setup_iterm2.sh
```

このスクリプトは以下を実行します：
1. iTerm2のインストール（未インストールの場合）
2. 推奨設定ファイルの配置
3. MesloLGS NFフォントのインストール（Powerline対応）
4. カスタム設定フォルダの指定

### 設定内容
- **カラースキーム**: ダークテーマ（カスタム）
- **フォント**: MesloLGS NF 14pt（Powerline対応）
- **スクロールバック**: 10,000行
- **ホットキー**: 設定済み
- **ペイン分割**: ディマー設定
- **マウスレポート**: 有効
- **その他**: tmux統合、コマンド履歴、ペースト履歴

### カスタマイズ
iTerm2の設定は`iterm2/com.googlecode.iterm2.plist`で管理されています。
設定を変更する場合は、iTerm2の設定画面から変更し、設定ファイルをコミットしてください。

### ファイル構成
| ファイル | 説明 |
|---------|------|
| `Brewfile` | iTerm2を含む開発ツールの定義（[Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)） |
| `iterm2/com.googlecode.iterm2.plist` | iTerm2の設定ファイル（カラー、フォント、キーバインド等） |
| `scripts/setup_iterm2.sh` | 自動セットアップスクリプト |
| `scripts/process_iterm2_config.sh` | 設定ファイルの変数置換処理 |

### 参考リンク
- [iTerm2公式サイト](https://iterm2.com/)
- [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts)

## 注意事項

- **秘密情報を含むファイル**（`.aws`、秘密鍵など）は**絶対に**このリポジトリに含めないでください
- 個人的な設定は`.gitconfig.local`などのローカルファイルで管理することを推奨します

## ライセンス

このプロジェクトは個人使用を目的としています。