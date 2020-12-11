1. layabox 引擎使用 2.0.2beta

命令行发布

1.安装nodejs 推荐使用node版本管理工具,laya官方推荐安装的是10.*版本的node,我安装的是10.9.0版本的node,安装不了的话，可以使用淘宝镜像 https://github.com/nvm-sh/nvm https://github.com/coreybutler/nvm-windows
2.安装gulp-cache和layaair-cmd https://github.com/jgable/gulp-cache https://ldc.layabox.com/doc/?nav=zh-ts-3-4-2 https://www.npmjs.com/package/layaair-cmd https://www.npmjs.com/package/layaair2-cmd
3.配置脚本里的变量(如果提示找不到xxxx.json,可以在layaair ide界面操作一次生成对应的xxx.json)

注意: 使用界面发布后再用命令行发布会在编译处报错，再运行一次命令行就可以正常运行了