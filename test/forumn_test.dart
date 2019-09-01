

import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';


void main() {

  String url = "https://bbs.nga.cn/read.php?tid=18335755&page=1&__output=8";
  Options options = new Options();
  options.headers = Map();
  String cid = "Z8fg9e2qspaeuqpd6hmqeuf978dd0ek7oagcgsg8";
  String uid = "38060336";
  options.headers["Cookie"] = "ngaPassportUid=$uid; ngaPassportCid=$cid";
  options.responseType = ResponseType.bytes;

  new Dio().get(url,
      options: options).then((response){
    var result=  gbk.decode(response.data).replaceAll("	", " ");
    print(result);

  });



}


