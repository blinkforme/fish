### 打包需知

#### 安卓包

* 确保打包机器已经安装好 JDK、SDK，如果没有安装，自行搜索一下安装教程

* 环境配置：依次点击unity的导航栏的操作菜单  **Arthas -->> PathConfig** , 弹出配置窗口之后对路径进行配置。 

  * Bundle_output_path：资源包保存路径
  * apk_output_path : 安卓包打包完成保存路径

* 新增打包脚本：

  * mac 或linux 平台运行build.sh.   （已测试，可用）

  * windows平台  build.bat （暂未测试）

  * 运行前，进入脚本进行相关配置

    ```shell
    #设置Unity3d项目目录
    UNITY3D_PROJECT_PATH="./"
    #设置Unity3d执行的编译方法
    UNITY3D_BUILD_METHOD="ProjectTools.AutoBuildAPK.BuildLocalAPK"
    #设置Unity3d exe文件路径
    UNITY3D_EXE_PATH="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
    #Unity3d项目打包后生成的APK路径
    UNITY3D_OUTPUT_PATH="./Build/Android/"
    ###########配置结束###########
    ```

    

* 远程版本信息管理配置：

  ```json
  {
      "Windows":{
          "Platform":"Windows",
          "Version":"0_0_0_1",
          "UpdateUrl":"https://cdn-byh5.jjhgame.com/Unity_Fish/"
      },
      "OSX":{
          "Platform":"OSX",
          "Version":"0_2_0_3",
          "UpdateUrl":"http://192.168.89.23:8000/"
      },
      "iOS":{
          "Platform":"iOS",
          "Version":"0_2_0_4",
          "UpdateUrl":"http://cdn-byh5.jjhgame.com/Unity_Fish/"
      },
      "Android":{
          "Platform":"Android",
          "Version":"0_2_0_4",
          "UpdateUrl":"https://cdn-byh5.jjhgame.com/Unity_Fish/"
      }
  }
  ```
  
  * 拷贝上面的配置信息，命名为Version.json 上传到cdn对应的更新目录下即可、测试版本目前名称叫TestVersion.json
  
* 环境配置完成之后，打本地安卓包：

  * 依次点击Unity的导航栏菜单选择 **Build -->> 安卓热更包 ，然后等待打包完成即可
  * 需要注意的是，本地测试安卓包，不会下载远程资源，仅使用当前打包内容的资源，ab包的资源保存在 StreamingAssets目录下

* 打远程热更裸包：

  * 依次点击Unity的导航栏菜单选择 **Build -->> xxx热更包** 线上热更新包，此时会在配置好的资源保存路径中生成对应的版本资源包， 将资源包上传到cdn对应目录即可



### 自定义宏开关

* **INSTALL_XCODE**:  macos使用，对应是否按转了xcode软件
* **ENABLE_DOWNLOAD_ASSETBUNDLE**: 打包时使用，是否需要下载远程资源，本地单机包，不需要打开。其他时候默认打开
* **FAIRYGUI_TOLUA**：使用FGUI必须打开
* **FAIRYGUI_TEST**：对FGUI进行测试的时候，可以在inspecter看到更多的参数，打包时可以选择关闭

* **PROJECT_DEBUG**：debug模式下，可以查看debug信息，正式包需要关闭
* **CLOSE_LUA_LOG**：开启 关闭所有lua的日志信息