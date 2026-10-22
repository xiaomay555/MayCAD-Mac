# 来源与依赖

本项目的绘图逻辑和移植工作由作者在 Codex 协助下整理。通用版不包含私人图纸、原 DWS／CTB、字体、客户图块或源图提取的精细门窗／衣架轮廓；相关符号在公开版使用程序化基础图形。

- AutoCAD for Mac 是运行环境，由使用者自行取得，不随本项目分发。
- 开发时的 AI 连接使用 [adamshels1/autocad-mcp](https://github.com/adamshels1/autocad-mcp)。本仓库仅链接来源，不复制其源码或将其列入本项目 MIT 授权；手动使用命令不依赖该连接。
- `qp-render.swift` 使用 macOS 的 Foundation、CoreGraphics 和 ImageIO；安装时本机构建，不附带系统框架或编译器。
- 操作体验参考日常 CAD 命令和用户提出的工作流程；本项目不包含海龙插件源码，也不代表海龙官方产品。
- 用户自行导入的字体、打印样式、标准模板和图块由其各自来源和授权约束，不因与本项目一起使用而改用本项目许可证。
