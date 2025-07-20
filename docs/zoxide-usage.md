# Zoxideの基本的な使い方

Zoxideは、頻度と最近のアクセス時間に基づいてスマートなディレクトリ移動を提供するツールです。

## インストール

このdotfilesでは、`.zshrc`読み込み時に自動でbrewからインストールされます。

```bash
# 手動インストールする場合
brew install zoxide
```

## 基本的な使い方

### zコマンド（基本のディレクトリ移動）

```bash
# 通常のcd代替
z foo              # "foo"を含むディレクトリに移動
z foo bar          # "foo"と"bar"を含むディレクトリに移動
z foo/bar          # "foo/bar"を含むディレクトリに移動

# 部分一致でスマート移動
z proj             # ~/projects に移動（過去に訪問済みの場合）
z doc              # ~/Documents に移動
z down             # ~/Downloads に移動
```

### ziiコマンド（インタラクティブ選択）

```bash
zii                # 訪問履歴から選択
zii foo            # "foo"を含むディレクトリから選択
```

注意: `zi`コマンドはzinitと競合するため、このdotfilesでは`zii`として設定されています。

### よく使うコマンド

```bash
# データベース操作
zoxide query       # 現在のデータベースを表示
zoxide query foo   # "foo"にマッチするパスを表示
zoxide remove ~/some/path  # パスをデータベースから削除

# 統計情報
zoxide query --stats       # 統計情報を表示
```

## 設定済みエイリアス

このdotfilesでは以下のエイリアスが設定されています：

```bash
alias cd='z'       # cdコマンドをzoxideに置き換え
```

## 便利な使い方

### 1. プロジェクト間の素早い移動
```bash
# 一度訪問すれば、部分名で移動可能
cd ~/src/github.com/user/my-awesome-project
# 以降は以下で移動可能
z awesome
z project
z my-awesome
```

### 2. 深い階層への直接移動
```bash
# 従来: cd ~/very/deep/directory/structure/target
# zoxide: z target  （過去に訪問済みなら）
```

### 3. 類似名ディレクトリの区別
```bash
# project1, project2, project3 がある場合
z project1         # 最も頻繁にアクセスするプロジェクトに移動
zii project        # インタラクティブに選択
```

## データベースの管理

```bash
# データベースを表示
zoxide query --list

# 特定のパスを削除
zoxide remove /path/to/remove

# データベースをクリア（注意）
zoxide query --list | xargs -I {} zoxide remove {}
```

## トラブルシューティング

### zoxideが期待通りに動作しない場合

1. データベースの確認
```bash
zoxide query --stats
```

2. 手動でディレクトリを追加
```bash
zoxide add /path/to/directory
```

3. 設定の再読み込み
```bash
source ~/.zshrc
```

### パフォーマンスの最適化

```bash
# 古い履歴をクリーンアップ
zoxide query --list | head -n -100 | xargs -I {} zoxide remove {}
```

## 参考リンク

- [Zoxide公式GitHub](https://github.com/ajeetdsouza/zoxide)
- [Zoxide公式ドキュメント](https://github.com/ajeetdsouza/zoxide/wiki)