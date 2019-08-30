
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:nga_open_source/model/bean/topic_content_bean_entity.dart';


void main() {

  String url = "https://bbs.nga.cn/read.php?tid=18358557&page=1&__output=8";
  Options options = new Options();
  options.headers = Map();
  String cid = "Z8fg9e2qspaeuqpd6hmqeuf978dd0ek7oagcgsg8";
  String uid = "38060336";
  options.headers["Cookie"] = "ngaPassportUid=$uid; ngaPassportCid=$cid";
  options.responseType = ResponseType.bytes;


  new Dio().get(url, options: options).then((response){

    String result = /*"{\"alterinfo\":\"[E1567159061 0 0]       \"}";*/gbk.decode(response.data);//gbk.decode(response.data);
//    File file = new File("E:\\test.txt");
//    file.writeAsString(result);

  //  result = "{ \"test\": \"[32312] \"}";
    result = result.replaceAll("]	", "]");

    //print(result);
   // result = result.replaceAll("[E1567150487 0 0]", "");
    try {
      Map json = jsonDecode(result);
      TopicContentBeanEntity bean = TopicContentBeanEntity.fromJson(json);
      print(bean.data.tR.listData[1].content);
    } catch (e,s) {
      print('exception details:\n $e');
      //print('stack trace:\n $s');


    }
  });
}


