class Resources {
  static String getDrawable(String resName, {String format = "png"}) {
    return 'assets/images/$resName.$format';
  }
}
