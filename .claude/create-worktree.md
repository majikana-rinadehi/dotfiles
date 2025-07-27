# ワークツリー作成・移動コマンド

新しいワークツリーを作成し、そのワークツリーに移動するClaudeコマンドです。

## 使用方法

```
/create-worktree ブランチ名
```

## 実行内容

以下の手順を実行します：

1. 現在のgit状態を確認
2. 必要に応じて変更をコミットまたはスタッシュ
3. mainブランチの最新版を取得
4. 新しいワークツリーを作成
5. 作成したワークツリーに移動

```bash
# 現在の状態を確認
git status

# mainブランチに移動して最新版を取得
git checkout main
git pull origin main

# ワークツリーを作成
wt create $1

# ワークツリーに移動（パスを調整）
cd ../$1
```

## 例

```
/create-worktree feature/issue-42-new-feature
```

このコマンドにより、`feature/issue-42-new-feature`という名前のワークツリーが作成され、そのディレクトリに移動します。