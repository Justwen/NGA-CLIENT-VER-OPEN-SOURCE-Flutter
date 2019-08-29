import 'package:dio/dio.dart';
import 'package:nga_open_source/model/user_model.dart';
import 'package:nga_open_source/plugin/UtilsPlugin.dart';

class TopicContentModel {
  Dio dio = new Dio();

  void loadContent(int tid, int page, Function callback) async {
    String url = _buildUrl();
    print(url);
    Options options = new Options();
    options.headers = _buildHeader();
    options.responseType = ResponseType.plain;
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(tid, page));

      print(response.data);
      UtilsPlugin().unicodeDecoding(response.data).then((result) {
        print(result);
      });
    } catch (e) {
      print(e);
    }
  }

  String _buildUrl() {
    StringBuffer buffer = new StringBuffer();
    buffer.write("https://bbs.nga.cn/read.php?");
    return buffer.toString();
  }

  Map<String, dynamic> _buildParam(int tid, int page) {
    Map<String, dynamic> param = Map();
    param["__output"] = "11";
    param["page"] = page;
    param["tid"] = tid;
    return param;
  }

  Map<String, String> _buildHeader() {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    return header;
  }
}
