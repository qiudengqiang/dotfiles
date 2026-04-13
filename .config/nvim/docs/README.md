# Neovim

## 目标结构

- [lua/configs.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/configs.lua:1)
  只做总装配，负责拼出最终配置，不再承载大段具体实现
- [lua/stacks/lsp.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/lsp.lua:1)
  原生 LSP 主链：`vim.lsp.config/enable`、diagnostic、hover、on_attach、LSP keymaps
- [lua/langs](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/langs)
  语言专属 LSP 配置，每个 server 一个文件
- [lua/stacks/format.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/format.lua:1)
  格式化策略：LSP formatting 优先，外部 formatter 兜底
- [lua/stacks/treesitter.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/treesitter.lua:1)
  原生 treesitter 运行时接线，以及 parser 安装管理
- [lua/stacks/tools.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/tools.lua:1)
  安装和开发工具链：`mason`、`dap`、`dap-go`
- [lua/stacks/editor.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/editor.lua:1)
  编辑体验增强：原生 completion/snippet、`autopairs`、`neotest`
- [lua/stacks/ui.lua](/Users/didi/workspace/src/dotfiles/.config/nvim/lua/stacks/ui.lua:1)
  界面与导航：`telescope`、`which-key`、`trouble`、`nvim-tree`、`bufferline`、`lualine`

## 快捷键

基于当前仓库配置整理，面向日常使用，不展开实现细节。

### 约定

- `Leader` 是空格键 `Space`
- `LocalLeader` 也是空格键 `Space`
- `LSP` 类快捷键通常在有语言服务器附着时可用
- `Telescope` / `NvimTree` / `DAP` 一类窗口内还有局部快捷键，见文末

### 全局常用

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `#` | 搜索光标下完整单词 |
| 普通 | `Ctrl-H` | 上一个 buffer |
| 普通 | `Ctrl-L` | 下一个 buffer |
| 普通 | `Ctrl-N` | quickfix 下一项 |
| 普通 | `Ctrl-P` | quickfix 上一项 |
| 普通 | `Ctrl-J` | 向下滚动 7 行 |
| 普通 | `Ctrl-K` | 向上滚动 7 行 |
| 普通 | `Ctrl-E` | 当前行下移 |
| 普通 | `Ctrl-Y` | 当前行上移 |
| 普通 | `Alt-J` | 当前行下移并重新缩进 |
| 普通 | `Alt-K` | 当前行上移并重新缩进 |
| 普通 | `Space Space` | 切换 NvimTree 并定位当前文件 |
| 普通 | `Space -` | 水平分屏 |
| 普通 | `Space \|` | 垂直分屏 |
| 普通 | `Space q` | 关闭当前 buffer 并回到前一个 |
| 普通 | `Space ;` | 清除搜索高亮 |
| 普通 | `Ctrl-Up` | 缩小窗口高度 |
| 普通 | `Ctrl-Down` | 增大窗口高度 |
| 普通 | `Ctrl-Left` | 缩小窗口宽度 |
| 普通 | `Ctrl-Right` | 增大窗口宽度 |
| 普通 | `[c` | 上一个 Git hunk |
| 普通 | `]c` | 下一个 Git hunk |

### 插入模式与命令行

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 插入 | `jk` | 退出插入模式 |
| 插入 | `kj` | 退出插入模式 |
| 插入 | `Ctrl-A` | 行首 |
| 插入 | `Ctrl-E` | 行尾 |
| 插入 | `Ctrl-B` | 左移 |
| 插入 | `Ctrl-F` | 右移 |
| 插入 | `Ctrl-J` | 下移 |
| 插入 | `Ctrl-K` | 上移 |
| 插入 | `Ctrl-D` | 删除字符 |
| 插入 | `Ctrl-L` | 手动触发 LSP completion |
| 命令行 | `Ctrl-A` | 行首 |
| 命令行 | `Ctrl-E` | 行尾 |
| 命令行 | `Ctrl-B` | 左移 |
| 命令行 | `Ctrl-F` | 右移 |
| 命令行 | `Ctrl-J` | 下移 |
| 命令行 | `Ctrl-K` | 上移 |
| 命令行 | `Ctrl-D` | 删除字符 |

### 视觉模式

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 可视 | `<` | 左缩进后保持选区 |
| 可视 | `>` | 右缩进后保持选区 |
| 可视 | `Ctrl-N` | 选中文本下移 |
| 可视 | `Ctrl-P` | 选中文本上移 |
| 可视 | `p` | 用寄存器内容覆盖选区，不污染默认寄存器 |
| 可视块 | `Ctrl-N` | 选中文本块下移 |
| 可视块 | `Ctrl-P` | 选中文本块上移 |

### 跳转与导航

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通/可视/操作待定 | `Leader s` | Flash 模糊跳转 |
| 普通/可视/操作待定 | `Leader S` | Flash Treesitter 跳转 |
| 普通 | `Leader ?` | 显示当前 buffer 局部快捷键 |

### 文件与搜索

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader ff` | `Telescope find_files` |
| 普通 | `Leader fg` | `Telescope live_grep` |
| 普通 | `Leader fb` | `Telescope buffers` |
| 普通 | `Leader fh` | `Telescope help_tags` |
| 普通 | `Leader fp` | `Telescope projects` |
| 普通 | `Leader pp` | 切到项目根目录 |

### LSP 与代码操作

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `K` | Hover 文档 |
| 普通 | `gd` | 跳到定义 |
| 普通 | `gi` | 跳到实现 |
| 普通 | `gr` | 查找引用 |
| 普通 | `Leader rn` | 重命名 |
| 普通 | `Leader ca` | Code Action |
| 普通 | `Leader =` | 格式化当前 buffer |

### Git

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader gs` | `:Git` 状态页 |
| 普通 | `Leader gb` | `:Git blame` |
| 普通 | `Leader gd` | `:Gvdiffsplit` |
| 普通 | `Leader gh` | 当前文件历史 |
| 普通 | `Leader gH` | 仓库历史 |
| 普通 | `Leader gv` | 切换 Diffview |
| 普通 | `Leader cb` | gitblame 当前行 |

### 诊断、配置与工具

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader cx` | Trouble 诊断面板 |
| 普通 | `Leader cr` | 重新加载当前 Neovim 配置 |

### 测试

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader tt` | 运行当前位置测试 |
| 普通 | `Leader tf` | 运行当前文件测试 |
| 普通 | `Leader to` | 打开测试输出浮窗 |
| 普通 | `Leader tl` | 切换测试摘要 |
| 普通 | `Leader td` | 用 DAP 跑测试 |
| 普通 | `Leader tp` | 切换测试输出面板 |

### 调试

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader dt` | 调试当前测试 |
| 普通 | `Leader dl` | 重跑上一次调试 |
| 普通 | `Leader dB` | 设置日志断点 |
| 普通 | `Leader db` | 切换断点 |
| 普通 | `Leader dk` | 评估变量 |
| 普通 | `Leader df` | 打开 DAP 浮窗 |
| 普通 | `F1` | 调试当前测试 |
| 普通 | `F2` | 切换 DAP UI |
| 普通 | `F5` | Continue |
| 普通 | `Shift-F5` | Terminate |
| 普通 | `Ctrl-Shift-F5` | Restart |
| 普通 | `F6` | Step Over |
| 普通 | `F7` | Step Into |
| 普通 | `F8` | Step Out |
| 普通 | `F9` | 调用栈向上 |
| 普通 | `Shift-F9` | 调用栈向下 |

### Quickfix

| 模式 | 快捷键 | 作用 |
| --- | --- | --- |
| 普通 | `Leader qo` | 打开 quickfix |
| 普通 | `Leader qc` | 关闭 quickfix |
| 普通 | `Leader qn` | quickfix 下一项 |
| 普通 | `Leader qp` | quickfix 上一项 |

### Completion 使用方式

当前已经改成 `Neovim 0.12.1` 原生 completion 习惯：

- `Ctrl-L`：手动触发补全
- `Ctrl-N` / `Ctrl-P`：在候选中上下移动
- `Ctrl-Y`：确认当前候选
- `Enter`：正常换行，不负责确认候选

### Telescope 提示框局部快捷键

#### 插入模式

| 快捷键 | 作用 |
| --- | --- |
| `Enter` | 打开当前项 |
| `Ctrl-Q` | 发送到 quickfix 并打开 |
| `Ctrl-N` | 下一项 |
| `Ctrl-P` | 上一项 |
| `Ctrl-C` | 关闭 |
| `Down` / `Up` | 上下移动 |
| `Ctrl-X` | 水平分屏打开 |
| `Ctrl-V` | 垂直分屏打开 |
| `Ctrl-T` | 新标签页打开 |
| `Ctrl-U` | 预览窗口上滚 |
| `Ctrl-D` | 预览窗口下滚 |
| `PageUp` / `PageDown` | 结果列表翻页 |
| `Tab` | 选择当前项并移到下一项 |
| `Shift-Tab` | 选择当前项并移到上一项 |
| `Alt-Q` | 发送已选项到 quickfix 并打开 |
| `Ctrl-L` | 补全 tag |
| `Ctrl-/` | 显示帮助 |

#### 普通模式

| 快捷键 | 作用 |
| --- | --- |
| `Esc` | 关闭 |
| `Enter` | 打开当前项 |
| `Ctrl-Q` | 发送到 quickfix 并打开 |
| `Ctrl-X` | 水平分屏打开 |
| `Ctrl-V` | 垂直分屏打开 |
| `Ctrl-T` | 新标签页打开 |
| `Tab` | 选择当前项并移到下一项 |
| `Shift-Tab` | 选择当前项并移到上一项 |
| `Alt-Q` | 发送已选项到 quickfix 并打开 |
| `Ctrl-N` / `Ctrl-P` | 上下移动 |
| `H` / `M` / `L` | 顶部 / 中间 / 底部 |
| `gg` / `G` | 首项 / 末项 |
| `Ctrl-U` / `Ctrl-D` | 预览窗口滚动 |
| `PageUp` / `PageDown` | 结果列表翻页 |
| `?` | 显示帮助 |

### NvimTree 局部快捷键

这些是在 NvimTree 窗口内额外生效的键：

| 快捷键 | 作用 |
| --- | --- |
| `C` | 以当前节点为根目录 |
| `h` | 收起父目录 |
| `l` | 打开文件/目录 |
| `y` | 复制节点 |
| `c` | 创建文件或目录 |
| `v` | 垂直分屏打开 |
| `s` | 水平分屏打开 |

## 说明

- 这份文档只记录当前仓库里显式配置的快捷键
- 插件自带但未覆写的默认键位没有全部展开
- 如果后面继续调整配置，建议同步更新这份文档
