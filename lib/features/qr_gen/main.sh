#!/bin/bash

PLACE_DATA=$(python3 addPlaceToFirebase.py)

PLACE_ID=$(echo "$PLACE_DATA" | cut -d'|' -f1)
PLACE_NAME=$(echo "$PLACE_DATA" | cut -d'|' -f2)

python3 generateImgQR.py "$PLACE_ID" "$PLACE_NAME"
