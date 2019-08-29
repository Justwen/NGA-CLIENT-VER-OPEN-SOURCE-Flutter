package com.mahang.androidnga.utils;

import android.content.Context;

public class ContextUtils {

    private static Context sContext;

    public static void setContext(Context context) {
        sContext = context.getApplicationContext();
    }

    public static Context getContext() {
        return sContext;
    }
}
