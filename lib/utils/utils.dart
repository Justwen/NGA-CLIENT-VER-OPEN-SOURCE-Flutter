import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class StringUtils {
  static const String ANONYMOUS_PART_1 = "甲乙丙丁戊己庚辛壬癸子丑寅卯辰巳午未申酉戌亥";

  static const String ANONYMOUS_PART_2 =
      "王李张刘陈杨黄吴赵周徐孙马朱胡林郭何高罗郑梁谢宋唐许邓冯韩曹曾彭萧蔡潘田董袁于余叶蒋杜苏魏程吕丁沈任姚卢傅钟姜崔谭廖范汪陆金石戴贾韦夏邱方侯邹熊孟秦白江阎薛尹段雷黎史龙陶贺顾毛郝龚邵万钱严赖覃洪武莫孔汤向常温康施文牛樊葛邢安齐易乔伍庞颜倪庄聂章鲁岳翟殷詹申欧耿关兰焦俞左柳甘祝包宁尚符舒阮柯纪梅童凌毕单季裴霍涂成苗谷盛曲翁冉骆蓝路游辛靳管柴蒙鲍华喻祁蒲房滕屈饶解牟艾尤阳时穆农司卓古吉缪简车项连芦麦褚娄窦戚岑景党宫费卜冷晏席卫米柏宗瞿桂全佟应臧闵苟邬边卞姬师和仇栾隋商刁沙荣巫寇桑郎甄丛仲虞敖巩明佘池查麻苑迟邝 ";

  static bool isEmpty(String data) => data == null || data == "";

  static String convertAnonymousName(String name) {
    StringBuffer buffer = new StringBuffer();
    int i = 6;
    for (int j = 0; j < 6; j++) {
      int pos;
      if (j == 0 || j == 3) {
        pos = int.tryParse(name.substring(i + 1, i + 2), radix: 16);
        buffer.write(ANONYMOUS_PART_1[pos]);
      } else {
        pos = int.tryParse(name.substring(i, i + 2), radix: 16);
        buffer.write(ANONYMOUS_PART_2[pos]);
      }
      i += 2;
    }
    return buffer.toString();
  }

  static String toBinaryArray(Uint8List bytes) {
    int byteLength = 8;
    StringBuffer builder = new StringBuffer();
    for (int i = 0; i < byteLength * bytes.length; i++) {
      builder.write(
          (bytes[i ~/ byteLength] << i % byteLength & 0x80) == 0 ? '0' : '1');
    }
    return builder.toString();
  }
}

class ContextUtils {
  static BuildContext buildContext;
}

class ToastUtils {
  static void showToast(String msg) {
    Toast.show(msg, ContextUtils.buildContext);
  }
}
