package ${packageName};

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Handler
import androidx.multidex.MultiDex
import com.black.lib_common.utils.ActivityManager
import com.black.lib_common.utils.UIUtils

class MyApplication: Application() {
    var mActivityCount : Int = 0;
    var mHandler: Handler = Handler()

    private val killAppRunnable = Runnable {
        System.exit(0)
    }

    override fun onCreate() {
        super.onCreate()
        //此处必须设置
        UIUtils.init(this);
//        设置加载图
//        UIUtils.setLoadingRes(R.mipmap.ic_launcher)
//        设置错误图
//        UIUtils.setErrorImg(R.mipmap.ic_launcher)
//        设置占位图
//        UIUtils.setIcPlaceHolderRes(R.mipmap.ic_launcher)
//        设置错误页面图片、文字
//        UIUtils.setErrorText(R.mipmap.ic_launcher, R.color.white);
        registerLifeCycle()
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    fun registerLifeCycle(){
        registerActivityLifecycleCallbacks(object: Application.ActivityLifecycleCallbacks {
            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
                ActivityManager.getInstance().addActivity(activity);

            }

            override fun onActivityStarted(activity: Activity) {
                if (mActivityCount == 0){// 回到前台
                    if ("vivo".equals(Build.BRAND, ignoreCase = true)) {
                        mHandler.removeCallbacksAndMessages(null)
                    }
                }
                mActivityCount++;
            }

            override fun onActivityResumed(activity: Activity) {
            }

            override fun onActivityPaused(activity: Activity) {

            }

            override fun onActivityStopped(activity: Activity) {
                mActivityCount--;
                if (mActivityCount == 0){// 切换到了后台
                    if ("vivo".equals(Build.BRAND, ignoreCase = true)) {
                        mHandler.postDelayed(killAppRunnable, 600 * 1000L)
                    }
                }
            }

            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {

            }

            override fun onActivityDestroyed(activity: Activity) {
                ActivityManager.getInstance().removeActivity(activity)
            }

        });
    }
}