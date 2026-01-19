import sys
import qrcode
import re

place_id = sys.argv[1]
place_name = sys.argv[2]

safe_name = re.sub(r'[^a-zA-Z0-9_-]', '_', place_name)

img = qrcode.make(place_id)
img.save(f"img/{safe_name}.png")

print(f'Se generó la imagen {safe_name}')
