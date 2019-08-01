import os

image_dir = "assets/images"

for item in os.listdir(image_dir):
    print("    - " + image_dir + "/" + item)