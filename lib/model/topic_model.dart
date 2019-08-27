import 'package:dio/dio.dart';
//import 'package:nga_open_source/plugin/UtilsPlugin.dart';

import 'board_model.dart';
import 'user_model.dart';

class TopicModel {
  Dio dio = new Dio();

  void loadPage(Board board, int page, Function callback) async {
    String url = _buildUrl(board, page);
    print(url);
    Options options = new Options();
    options.headers = _buildHeader();
    try {
      Response response = await dio.get(url,
          options: options, queryParameters: _buildParam(board, page));
//      UtilsPlugin utilsPlugin = new UtilsPlugin();
//      print(response.toString());
//      utilsPlugin.gbk(response.data.toString()).then((result){
//        print(result);
//      });
    } catch (e) {
      print(e);
    }
  }

  String _buildUrl(Board board, int page) {
    StringBuffer buffer = new StringBuffer();
    buffer.write("https://bbs.nga.cn/thread.php?");
    return buffer.toString();
  }

  Map<String, dynamic> _buildParam(Board board, int page) {
    Map<String, dynamic> param = Map();
    param["__output"] = "8";
    param["page"] = page;
    if (board.stid != 0) {
      param["stid"] = board.stid;
    } else if (board.fid != 0) {
      param["fid"] = board.fid;
    }
    return param;
  }

  Map<String, String> _buildHeader() {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    return header;
  }
}
