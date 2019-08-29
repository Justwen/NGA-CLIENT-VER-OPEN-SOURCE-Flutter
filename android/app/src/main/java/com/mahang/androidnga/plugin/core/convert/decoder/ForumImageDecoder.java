package com.mahang.androidnga.plugin.core.convert.decoder;

import com.mahang.androidnga.utils.EmoticonUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Justwen on 2018/8/25.
 */
public class ForumImageDecoder implements IForumDecoder {

    private List<String> mImageUrls = new ArrayList<>();

    private static final String HTML_EMOTICON = "<img class='emoticon' src='file:///android_asset/%s' >";

    private static final String HTML_IMG_DEFAULT = "<img src='file:///android_asset/ic_offline_image.png' >";

    private static final String HTML_IMG_LINK = "<a href='%s'>";

    private static final String REGEX_IMG = IGNORE_CASE_TAG + "<img src='(http\\S+)'>";

    private static final String REGEX_IMG_NO_HTTP = IGNORE_CASE_TAG + "\\[img]\\s*\\.(/[^\\[|\\]]+)\\s*\\[/img]";

    private static final String REPLACE_IMG_NO_HTTP = "<a href='http://%1$s/attachments%2$s'><img src='http://%1$s/attachments%2$s'></a>";

    private static final String REGEX_IMG_WITH_HTTP = IGNORE_CASE_TAG + "\\[img]\\s*(http[^\\[|\\]]+)\\s*\\[/img]";

    private static final String REPLACE_IMG_WITH_HTTP = "<a href='$1'><img src='$1'></a>";

    private static final String NGA_ATTACHMENT_HOST = "img.nga.178.com";

    @Override
    public String decode(String content) {

        String replace = String.format(REPLACE_IMG_NO_HTTP, NGA_ATTACHMENT_HOST, "$1");
        content = content.replaceAll(REGEX_IMG_NO_HTTP, replace);
        content = content.replaceAll(REGEX_IMG_WITH_HTTP, REPLACE_IMG_WITH_HTTP);
        content = content.replaceAll("(http\\S+).gif.(thumb_s|medium|thumb|thumb_ss).jpg", "$1.gif");
        content = content.replaceAll("<a href='(http\\S+).(png|jpg).(thumb_s|medium|thumb|thumb_ss).jpg'", "<a href='$1.$2'");

        Pattern p = Pattern.compile(REGEX_IMG);
        Matcher m = p.matcher(content);
        mImageUrls.clear();
        boolean showImage = true; /*PhoneConfiguration.getInstance().isDownImgNoWifi()
                || DeviceUtils.isWifiConnected(ApplicationContextHolder.getContext());*/
        while (m.find()) {
            String s0 = m.group();
            String s1 = m.group(1);
            String path = EmoticonUtils.getPathByURI(s1);
            if (path != null) {
                String newImgBlock = String.format(HTML_EMOTICON, path);
                content = content.replace(s0, newImgBlock)
                        // 移除可点击状态
                        .replace(String.format(HTML_IMG_LINK, s1), "");
            } else {
                if (!showImage) {
                    content = content.replace(s0, HTML_IMG_DEFAULT);
                }
                s1 = s1.replaceFirst("(http\\S+).(png|jpg).(thumb_s|medium|thumb|thumb_ss).jpg", "$1.$2");
                mImageUrls.add(s1);
            }
        }

        return content;
    }

    @Override
    public List<String> getImageUrls() {
        return mImageUrls;
    }
}
