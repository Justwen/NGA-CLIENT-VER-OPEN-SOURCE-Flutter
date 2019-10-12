import os

class FlutterBuilder:

    def __init__(self):
        pass

    def build(self):
        os.system("flutter build apk --target-platform android-arm64")

if __name__ == "__main__":
    builder = FlutterBuilder()
    builder.build()