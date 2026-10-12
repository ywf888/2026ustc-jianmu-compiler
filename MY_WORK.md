# 个人作业分支（my-work）

本分支基于课程仓库的 `main` 分支，用于存放你自己的作业、实验与笔记。
`main` / `lab0` / `warmup` 三个分支是课程官方内容的镜像，**请勿直接改动**，个人内容都放在这里。

## 目录建议

- `my-work/` —— 个人代码、实验、解答（可按 lab 再分子目录）
- `notes/` —— 学习笔记
- `homework/` —— 作业提交物

你可以自由增删文件，只要不改动课程自带的文件结构即可。

## 与课程更新保持同步

课程仓库（USTC GitLab）已设为本地 `upstream` remote。需要拉取课程最新内容时：

```bash
git fetch upstream
git merge upstream/main     # 把课程 main 的更新合入当前 my-work 分支
```

如有冲突，按提示解决后提交即可。

## 推送到 GitHub

```bash
git push origin my-work
```

切换回课程分支查看原内容：

```bash
git checkout main      # 或 lab0 / warmup
```
