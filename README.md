# make_mruby_framework_for_iOS
制作一个mruby的framework，可以在iOS中运行ruby(mruby)代码

1.获取mruby  
[https://github.com/mruby/mruby](https://github.com/mruby/mruby)

2.切换到stable分支

3.使用本项目的build_config.rb替换mruby项目中的build_config.rb文件

4.在mruby主目录执行`make`命令

5.进入./build目录，将build_framework.rb脚本拷贝进目录并执行

6.将看到mruby.framework

7.由于头文件加载的路径顺序问题，编译应该过不了，根据报错将framework中的`#include "xxx.h"`改成`#include <MRuby/..>`或反过来改正

8.可能需要将build settings中的Allow Non-modular Includes In Framework Modules设置成YES
