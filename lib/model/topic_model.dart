import 'package:dio/dio.dart';

import 'board_model.dart';
import 'user_model.dart';

class TopicModel {
  void loadPage(Board board, int page, Function callback) async {
    String url = _buildUrl(board, page);
    print(url);
    try {
      Response response = await Dio().get(url, queryParameters: _buildHeader());
      print(response);
    } catch (e) {
      print(e);
    }
  }

  String _buildUrl(Board board, int page) {
    StringBuffer buffer = new StringBuffer();

    buffer.write("http://bbs.nga.cn/thread.php?");

    print(board.stid.toString() + " 4");
    if (board.stid != 0) {
      buffer.write("&stid=${board.stid}");
    } else if (board.fid != 0) {
      buffer.write("&fid=${board.fid}");
    }

    buffer.write("&page=$page");

    return buffer.toString();
  }

  Map<String, String> _buildHeader() {
    Map<String, String> header = Map();
    header["Cookie"] = UserModel.getInstance().getCookie();
    header["__output"] = "8";
    header["__lib"] = "topic_favor";
    header["__act"] = "topic_favor";
    return header;
  }
}
