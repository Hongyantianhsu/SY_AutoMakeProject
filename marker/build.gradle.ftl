// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    // 全局引入
    apply from: 'buildconfig/dependencies.gradle'

    repositories {
        google()
        mavenCentral()
        // Maven URL地址
        maven { url 'http://172.16.110.31:8081/repository/qsk/' }
        maven{
            url 'http://172.16.110.31:8081/repository/Jcenter/'
        }
        // umeng
        maven { url 'https://repo1.maven.org/maven2/' }
        //华为推送
        maven {url 'http://developer.huawei.com/repo/'}
        // 阿里云  central仓和jcenter仓的聚合仓
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven {
            url "http://repo.baichuan-android.taobao.com/content/groups/BaichuanRepositories/"
        }
    }
    dependencies {
        classpath "com.android.tools.build:gradle:3.4.3"
        // butterknife
        classpath 'com.jakewharton:butterknife-gradle-plugin:10.2.0'
        classpath 'com.meituan.android.walle:plugin:1.1.6'

        classpath developmentDependencies.kotlin_gradle_plugin

        //华为推送agconnect
        classpath 'com.huawei.agconnect:agcp:1.2.1.301'

        //添加 Sensors Analytics android-gradle-plugin 依赖
        classpath 'com.sensorsdata.analytics.android:android-gradle-plugin2:1.0.2'
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        // Maven URL地址
        maven { url 'http://172.16.110.31:8081/repository/qsk/' }
        maven{
            url 'http://172.16.110.31:8081/repository/Jcenter/'
        }
        // umeng
        maven { url 'https://repo1.maven.org/maven2/' }

        //华为推送
        maven {url 'http://developer.huawei.com/repo/'}
        // 阿里云  central仓和jcenter仓的聚合仓
        maven { url 'https://maven.aliyun.com/repository/public' }
        // 华为开源镜像：https://mirrors.huaweicloud.com
        maven { url 'https://repo.huaweicloud.com/repository/maven' }
        maven {
            url "http://repo.baichuan-android.taobao.com/content/groups/BaichuanRepositories/"
        }

        // 私有仓库地址
        maven { url "http://lib.gcssloop.com:8081/repository/gcssloop-central/" }
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}