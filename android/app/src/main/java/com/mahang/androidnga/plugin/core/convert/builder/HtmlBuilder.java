package com.mahang.androidnga.plugin.core.convert.builder;

import com.mahang.androidnga.utils.StringUtils;

import java.util.List;

/**
 * Created by Justwen on 2018/8/28.
 */
public class HtmlBuilder {

    private static String sHtmlTemplate;

    private static String sDarkHtmlTemplate;

    private static String getHtmlTemplate(boolean isNightMode) {
        if (isNightMode) {
            if (sDarkHtmlTemplate == null) {
                sDarkHtmlTemplate = StringUtils.getStringFromAssets("html/html_template_dark.html");
            }
            return sDarkHtmlTemplate;
        } else {
            if (sHtmlTemplate == null) {
                sHtmlTemplate = StringUtils.getStringFromAssets("html/html_template.html");
            }
            return sHtmlTemplate;
        }
    }

    public static String build(String ngaHtml, boolean isNightMode, List<String> imageUrls) {

        StringBuilder builder = new StringBuilder();
//        if (row.get_isInBlackList()) {
//            builder.append("<h5>[屏蔽]</h5>");
//        } else if (TextUtils.isEmpty(ngaHtml) && TextUtils.isEmpty(row.getAlterinfo())) {
//            builder.append("<h5>[隐藏]</h5>");
//        } else {
//            if (!TextUtils.isEmpty(row.getSubject())) {
//                builder.append("<div class='title'>").append(row.getSubject()).append("</div><br>");
//            }
//            if (TextUtils.isEmpty(ngaHtml)) {
//                ngaHtml = row.getAlterinfo();
//            }
        builder.append(ngaHtml);
//                    .append(HtmlCommentBuilder.build(row))
//                    .append(HtmlAttachmentBuilder.build(row, imageUrls))
//                    .append(HtmlSignatureBuilder.build(row))
//                    .append(HtmlVoteBuilder.build(row));
//            if (!PhoneConfiguration.getInstance().useOldWebCore()
//                    && builder.length() == row.getContent().length()
//                    && row.getContent().equals(ngaHtml)) {
//                row.setContent(row.getContent().replaceAll("<br/>", "\n"));
//                return null;
//            }
        //      }
        String template = getHtmlTemplate(isNightMode);
        int webTextSize = 18;//PhoneConfiguration.getInstance().getTopicContentSize();
        int emoticonSize = 150;//PhoneConfiguration.getInstance().getEmoticonSize();

        return String.format(template, webTextSize, (int) (webTextSize * 0.9), emoticonSize, builder.toString());
    }
}
