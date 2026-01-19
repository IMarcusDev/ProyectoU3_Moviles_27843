import firebase_admin
import json
import sys
import qrcode
import re
from firebase_admin import credentials, firestore

# Inicializar Firebase
cred = credentials.Certificate("./venv/serviceKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def add_place(place: map):
  doc_ref = db.collection("places").document()  # ID automático

  doc_ref.set(place)

  return doc_ref.id

if __name__ == "__main__":
  with open('lugares_pichincha.json') as f:
    data = json.load(f)

    for place in data:
      place_id = add_place(place)

      safe_name = re.sub(r'[^a-zA-Z0-9_-]', '_', place['name'])

      img = qrcode.make(place_id)
      img.save(f"img/{safe_name}.png")

      print(f'Se generó la imagen {safe_name}')
