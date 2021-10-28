plugins {
    id 'com.android.application'
    id 'com.jakewharton.butterknife'
    id 'walle'
    id 'com.sensorsdata.analytics.android'

    id 'kotlin-android'
    id 'kotlin-android-extensions'
    id 'kotlin-kapt'

    id 'com.huawei.agconnect'
}

task deve(type: Exec, dependsOn: 'installFirDebug') {
    commandLine 'adb', 'shell', 'am', 'start', '-n', '${packageName}/.MainActivity'
}
task online(type: Exec, dependsOn: 'installFirRelease') {
    commandLine 'adb', 'shell', 'am', 'start', '-n', '${packageName}/.MainActivity'
}

android {
    compileSdkVersion zzcCompileSdkVersion
    buildToolsVersion zzcBuildToolsVersion

    defaultConfig {
        applicationId "${packageName}"
        minSdkVersion zzcMinSdkVersion
        targetSdkVersion zzcTargetSdkVersion
        versionCode propVersionCode.toInteger()
        versionName propVersionName
        multiDexEnabled true

        flavorDimensions "versionCode"

        ndk {
            // 设置支持的 SO 库构架
            abiFilters 'armeabi-v7a', 'arm64-v8a' // 'armeabi', 'x86', 'x86_64', 'arm64-v8a', 'mips', 'mips64'
        }
        packagingOptions {
            doNotStrip "*/armeabi-v7a/*.so"
//            doNotStrip "*/x86/*.so"
            doNotStrip "*/arm64-v8a/*.so"
//            doNotStrip "*/x86_64/*.so"
//            doNotStrip "armeabi.so"
        }

        //arouter需要的配置
        javaCompileOptions {
            annotationProcessorOptions {
                arguments = [AROUTER_MODULE_NAME: project.getName()]
            }
        }

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    signingConfigs {
        release {
            storeFile file('../keystore/zuzuChe_release.keystore')
            storePassword "zuzuChe.com"
            keyAlias "zuzuChe"
            keyPassword "20110701"

            v1SigningEnabled true
            v2SigningEnabled true
        }
    }

    buildTypes {
        release {
            // 签名配置
            signingConfig signingConfigs.release
            // 去除无用资源
            shrinkResources propShrinkResources.toBoolean()
            // 是否debug信息
            debuggable propDebuggable.toBoolean()
            // zip对齐
            zipAlignEnabled propZipAlignEnabled.toBoolean()
            // 代码混淆
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }

        debug {
            signingConfig signingConfigs.release
            debuggable true
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    // 自定义导出的APK名称(gradle3.0+的api变化了)
    applicationVariants.all { variant ->
        variant.outputs.all {
            def buildType = variant.buildType.name // 构建类型 release/debug
            // 文件名称:应用名-构建类型_渠道号.apk
            outputFileName = "com_black_takeout.apk"
        }
    }

    // walle配置

    productFlavors {
        fir {
            manifestPlaceholders = [
                    UMENG_CHANNEL_VALUE: "fir",
                    JPUSH_PKGNAME      : "${packageName}",

                    JPUSH_APPKEY       : "ccff44cd852de933264003b9",//值来自开发者平台取得的AppKey
                    JPUSH_CHANNEL      : "default_developer",

                    XIAOMI_APPKEY      : "MI-5491997462814",//小米平台注册的appkey
                    XIAOMI_APPID       : "MI-2882303761519974814",//小米平台注册的appid

                    MEIZU_APPKEY       : "MZ-f6c22f1655fc480f88fb1f1f1cfd799c", // 魅族平台注册的appkey
                    MEIZU_APPID        : "MZ-117297", // 魅族平台注册的appid

                    OPPO_APPKEY        : "OP-234966cd0db04ad7a5f8b5c2daff50ac", // OPPO平台注册的appkey
                    OPPO_APPID         : "OP-30571147", // OPPO平台注册的appid
                    OPPO_APPSECRET     : "OP-3f9e62584a524ba991f04648f99cb8fe",//OPPO平台注册的appsecret

                    VIVO_APPKEY        : "4309398f-5554-40d6-80f4-e86839c38c73", // VIVO平台注册的appkey
                    VIVO_APPID         : "105493178", // VIVO平台注册的appid
            ]
        }
    }

    repositories {
        flatDir {
            dirs 'libs'
            dirs '../lib_pay/libs'
        }
    }

    compileOptions {
        encoding "utf-8"
    }
}

dependencies {
    implementation fileTree(include: ['*.jar'], dir: 'libs')
    implementation 'androidx.appcompat:appcompat:1.2.0'
    implementation 'com.google.android.material:material:1.2.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.0.1'
    testImplementation 'junit:junit:4.+'
    androidTestImplementation 'androidx.test.ext:junit:1.1.2'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.3.0'
    implementation('com.qsk:common:3.5.4@aar') { transitive = true }
    implementation('com.qsk:libtab:2.1.3@aar') { transitive = true }
    implementation('com.qsk:libtitlebar:1.3.0@aar') { transitive = true }
    implementation('com.qsk:libweb:3.0.3@aar') { transitive = true }
    implementation('com.qsk:librouter:3.0.6@aar') { transitive = true }
    //    implementation ('com.qsk:libumeng:3.2.1@aar'){transitive=true}
//    implementation('com.qsk:libpay:1.2.0@aar'){transitive=true}
    // 极光推送
    implementation('com.qsk:libjpush:1.2.0@aar') { transitive = true }
    // 头条适配方案
    implementation 'me.jessyan:autosize:1.2.1'
    implementation developmentDependencies.walle
    // 下拉刷新
    implementation developmentDependencies.smartRefreshLayout
    implementation developmentDependencies.smartRefresh_header
    implementation developmentDependencies.photoView
    implementation developmentDependencies.rclayout

    // ======================== 阿里系 end ========================

    kapt developmentDependencies.arouter_compiler
    kapt developmentDependencies.butterKnife_compiler

}