package com.mahang.androidnga.utils;

import android.content.res.AssetManager;

import java.io.IOException;
import java.io.InputStream;

public class StringUtils {

    public static String getStringFromAssets(String path) {
        AssetManager assetManager = ContextUtils.getContext().getAssets();
        try (InputStream is = assetManager.open(path)) {
            int length = is.available();
            byte[] buffer = new byte[length];
            is.read(buffer);
            return new String(buffer, "utf-8");
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }
}
