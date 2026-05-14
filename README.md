# 🔮 Metacognition — 破界

**破界期刊** — 认知之外，思维之疆。跨域思考认知科学、哲学、投资、陌生领域。

> *"认知的边界，不在于知道多少，而在于敢于面对多少未知。"*

## 关于期刊

大脑是一台预测机器，用过去的经验生成对世界的「最佳猜测」。舒适区就是预测误差最小的区域。破界期刊的目标是主动制造「预测误差」——带你进入不熟悉的领域，让大脑被迫进入学习模式。

## 站点

- 🌐 **首页**：`barretlee.github.io/metacognition/`
- 🔍 **站内搜索**：`Cmd+K` 或点击导航栏 🔍
- 🌓 **暗亮主题**：自动跟随系统，可手动切换
- 🌐 **中英双语**：每篇文章独立中文 `.md` + 英文 `.en.md`
- 💬 **评论**：Giscus（GitHub Discussions），点击「💬 加载评论」后 GitHub 登录

## 技术架构

| 层 | 方案 |
|---|---|
| 托管 | GitHub Pages（源：`docs/`） |
| 路由 | SPA + 404.html fallback + sessionStorage |
| 渲染 | 纯 JS Markdown 解析器（零依赖） |
| 搜索 | 预构建 `search-index.json` + 前端实时筛选 |
| 离线 | Service Worker（`sw.js`） |
| SEO | Open Graph / Twitter Card / JSON-LD / Sitemap |
| 字体 | Latin 自托管（JetBrains Mono + Noto Serif），中文 CDN（Noto Serif SC） |

## 文章列表

| 日期 | 标题 |
|------|------|
| 2026-05-15 | 看不见的系统在运行你 — VO₂max、确认偏误、叙事传输与稀土博弈 |
| 2026-05-14 | 大脑是一台幻觉机器 — 预测加工理论如何颠覆认知 |
| 2026-05-10 | 睡眠债务是复利计息的 |
| 2026-05-07 | Prompt Engineering 的哲学边界 |
| 2026-05-03 | 注意力是 21 世纪的石油 |
| 2026-04-29 | 你越优化系统，系统越可能崩溃 — 复杂系统的反直觉法则 |
| 2026-04-26 | 你的记忆在骗你 — 峰终定律 |
| 2026-04-22 | 记忆不再属于你 — 认知卸载 |
| 2026-04-19 | 委托的悖论 — 当你训练分身时，分身也在反向训练你 |
| 2026-04-16 | 软件正在退化为器官 — Agent 如何吃掉所有工具 |

## 文件结构

```
docs/
├── index.html           # SPA 主入口
├── 404.html             # SPA fallback（sessionStorage 传参）
├── editions.json        # 文章索引（双语）
├── search-index.json    # 预构建搜索索引
├── sw.js                # Service Worker
├── sitemap.xml          # SEO
├── favicon.ico
├── fonts.css / fonts/   # 字体
└── issues/
    ├── YYYY-MM-DD.md    # 中文文章
    └── YYYY-MM-DD.en.md # 英文文章
```

---

*Built by Barret Lee · Powered by curiosity*
