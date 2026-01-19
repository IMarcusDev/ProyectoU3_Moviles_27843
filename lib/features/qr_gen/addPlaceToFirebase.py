import firebase_admin
from firebase_admin import credentials, firestore

# Inicializar Firebase
cred = credentials.Certificate("./venv/serviceKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def add_place():
    doc_ref = db.collection("places").document()  # ID automático

    place = {
        "name": "Lugar de Prueba",
        "description": "Este es un lugar de prueba, únicamente para comprobar si funciona correctamente.",
        "latitude": 0,
        "longitude": 0,
        "interestVector": {
            "culture": 1,
            "gastronomy": 0,
            "hotel": 0,
            "nature": 0
        }
    }

    doc_ref.set(place)

    # Output igual que Dart
    print(f"{doc_ref.id}|{place['name']}")

if __name__ == "__main__":
    add_place()
