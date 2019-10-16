# Autotest_platform

Autotest_platform 是一款基于 POM 模式开发的 Web UI 自动化测试平台，通过选择绑定好的 selenium 的关键字，比如打开 url，左键点击，输入文本等等这些动作，背后的代码已在后端封装好，前端只需要像填表格来设计测试案例即可。此外，由于平台是基于 POM 模式的设计，项目，页面，元素，定位都可拆分管理，我们可以更为方便维护我们的测试脚本，当产品发生迭代的时候，我们只需要修改对应页面对应元素的定位即可，无需重新设计涉及到这个元素的所有测试案例。数据库当中已封装了 selenium 常见的关键字，可以在 ./Autotest_platform/PageObject/Base.py 里面自行添加自己需要的 selenium 关键字，甚至是更为复杂的自定义函数。./Autotest_platform/PageObject/Base_m.py 为手机端函数的封装，需要开启 Appium 连接手机。

平台采用 RabbitMQ + celery 的方式执行测试案例，支持异步分布执行测试案例，也支持开启定时任务。

平台构建相关技术栈：python + django + mysql + RabbitMQ + celery + selenium

平台后端 POM 原理层脚本 Demo 展示：[pom_autotest](https://github.com/ShaoNianyr/pom_autotest)

## 平台功能展示
    1. 首页用图标展示项目以及测试汇总的数据：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/index.png">

    2. 测试案例可分项目管理，多个测试项目之间均可通用 "selenium关键字封装"项目 封装好的关键字：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/projectManager.png">

    3. 采用 POM 模式设计，每个项目对应管理多个页面，每个页面对应管理多个页面元素的定位：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/pageManager.png">
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/elementManager.png">

    4. selenium 的动作也从测试案例中单独抽出来，作为一个函数来调用，同一个动作可以供多个测试案例一起使用，比如每个测试案例里面的输入文本的动作，都可以直接调用这个 "输入文本" 的关键字，关键字封装在 ./Autotest_platform/PageObject/Base.py 里面，对外暴露出两个参数，也就是输入的定位，以及输入的内容，设计测试案例的时候只需要对应填入这两个参数，它就会自动执行对应的 selenium 语句。 Appium 对应的关键字封装在 ./Autotest_platform/PageObject/Base_m.py 里面。

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/seleniumManager.png">
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/setSelenium.png">

    5. 支持浏览器有头执行案例，也支持浏览器无头执行案例，便于调试。也支持对手机端测试案例的执行，需开启 Appium 以及 adb 连接到手机，获取你要打开的应用和手机设备型号，并在 ./Product/models/models.py 如下代码的对应位置修改填写：
        from appium import webdriver
        desired_caps = {

            'platformName': 'Android',

            'platformVersion': '9',

            'deviceName': '13b7cc66',

            'appPackage': 'com.android.browser',

            'appActivity': 'com.android.browser.BrowserActivity',

            "noReset": True,

            "noSign": True

        }
        browser = webdriver.Remote('http://127.0.0.1:4723/wd/hub', desired_caps)
        time.sleep(2)
        return browser


    6. 支持一键快速复制测试案例：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/copyTesecase.png">

    7. 支持断言 url 以及 元素两种方式，支持完全匹配和包含匹配两种断言力度，支持测试案例设计过程中的参数化设计：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/assertValue.png">

    8. 支持测试案例的前置登录操作，可以在登录配置当中设置：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/loginSetting.png">

    9. 生成的测试结果中可展示多种详细的信息报告：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/testReport.png">

    10. 支持选择任意的测试案例构建测试集合，支持定时任务测试集合构建：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/timeSetting.png">

## Windows 安装部署

### 1. 获取项目代码

首先在 d 盘根目录获取源代码，然后切换至项目的根目录：
（如果代码不在 d 盘根目录，后续的相关路径请按照自己的路径来修改，此处以 d 盘根目录为例部署）

```bash
    cd d:
    git clone https://github.com/ShaoNianyr/Autotest_platform.git
    cd Autotest_platform
```
### 2. python3.6 pip 包安装
此处要先安装好 python3.6 环境，由于我有多个版本，所以设置的 python3.6 的环境变量为 python36。

```bash
    python36 -m pip install -r requirements.txt
```
如果你没有设置 pip 镜像，建议执行如下安装 pip 包指令：

```bash
python36 -m pip install -r requirements.txt -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
```
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/installPyRequirements.png">

### 3. Mysql5.7 安装：
这里我提供一个 docker-compose.yml 文件，可以帮你快速构建平台所需的 Mysql 数据库镜像，初始化设置并本地挂载数据库的内容。

首先安装 Docker Desktop，并在设置里面勾选 d 盘允许数据挂载。

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/dockerSharedDrives.png">

然后执行指令：

```bash
    docker-compose up
```

如果本地有安装到 Mysql 占用了端口导致启动失败，可以先执行指令杀死端口。

```bash
    netstat -ano|findstr "3306" 
    taskkill /pid xxxx -t -f  (xxxx 为你 3306 端口对应的pid)
    docker-compose up
```

一切正常，最终可以看到：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/dockerMysql.png">

接下来我们可以安装 Navicat Premium 12，连接我们的 docker mysql 镜像，将 autotest.sql 文件导入。当然你也可以直接手写 sql 语句建库导入。

在 Navicat Premium 12 中新建连接，如图所示设置：

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/linkDockerMysql.png">

点开我们的数据库，右键然后运行文件，执行如下设置，并导入 autotest.sql:

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/selectAutotestDatabase.png">
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/runSqlFile.png">
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/runSqlFileSetting.png">

成功以后，我们的数据库就具备 Demo 的数据在里面了。

如果想用本地 Mysql，新建如下的数据库名，并将代码修改你的 Mysql 的密码，再把 sql 文件导入即可。

<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/djangoSettingDatabase.png">

代码位置： ./Autotest_platform/settings.py

### 4. RabbitMQ 安装：
-   [RabbitMQ下载与安装(window版)](https://www.jianshu.com/p/3d43561bb3ee)

安装完毕以后，浏览器输入 http://localhost:15672 ，输入用户名：guest，密码：guest，你就可以进入到测试案例执行的消息队列的管理界面。

### 5. 启动 Django 项目：

因为之前已经导入过 sql 文件，就不需要再执行 python36 manage.py makesmigrations 这些指令，表格和数据都有了，所以直接执行：
```bash
    python36 manage.py runserver
```
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/loginPage.png">
打开网址 http://127.0.0.1:8000/login/ ，输入账号和密码：
```bash
    初始用户名: 少年
    初始密码： sn123456
```
接下来即可顺利进入到首页：
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/index.png">

账户的管理在 Django 后台 http://127.0.0.1:8000/admin/ 里面：
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/djangoUsersManager.png">

### 6. 启动 celery 异步执行测试案例：

当你点击执行案例的时候，平台会将测试案例放到消息队列当中等待执行，等你开启 celery 的 worker 模式时，才会开始执行命令。具体执行如下指令：（注意要处于项目根目录下）
```bash
    python36 manage.py celeryd -l info
```
<img src="https://github.com/ShaoNianyr/Autotest_platform/blob/master/pictures/runCelery.png">

### 7. 启动 celery 定时执行测试案例：
```bash
    python36 manage.py celerybeat -l info 
```
定时时间在 ./Autotest_platform/settings.py 中设置：
```bash
    CELERYBEAT_SCHEDULE = {
        'timing': {
            'task': 'Product.tasks.timingRunning',
            # 'schedule': crontab(hour=10, minute=30),
            'schedule': timedelta(seconds=300),
        },
    }
```

# 贡献

-   [ATP - UI 自动化测试用例管理平台](https://testerhome.com/topics/14676)