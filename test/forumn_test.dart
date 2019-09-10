void main() {
//  String url = "https://bbs.nga.cn/read.php?tid=18335755&page=1&__output=8";
//  Options options = new Options();
//  options.headers = Map();
//  String cid = "Z8fg9e2qspaeuqpd6hmqeuf978dd0ek7oagcgsg8";
//  String uid = "38060336";
//  options.headers["Cookie"] = "ngaPassportUid=$uid; ngaPassportCid=$cid";
//  options.responseType = ResponseType.bytes;
//
//  new Dio().get(url,
//      options: options).then((response){
//    var result=  gbk.decode(response.data).replaceAll("	", " ");
//    print(result);
//
//  });

  int time = 1565760195062;
  time = 1565717027 * 1000;
  DateTime postDate = DateTime.fromMillisecondsSinceEpoch(time);
  // print(.toString());

  Duration diff = DateTime.now().difference(postDate);
  if (diff.inDays >= 365) {
    print(postDate.toString());
  } else if (diff.inDays >= 1) {
    print(
        "${postDate.month}-${postDate.day} ${postDate.hour}:${postDate.minute}");
  } else if (diff.inHours >= 1) {
    print("${diff.inHours}小时前");
  } else if (diff.inMinutes >= 1) {
    print("${diff.inMinutes}前");
  } else if (diff.inMinutes < 0) {
    print("刚刚");
  }
}
