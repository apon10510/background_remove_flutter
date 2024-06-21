from rembg import remove
from PIL import Image

def remove_background(file):
    input_image = Image.open(file.stream)
    return remove(input_image)