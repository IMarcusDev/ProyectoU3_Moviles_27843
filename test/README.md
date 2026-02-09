# Pruebas de la Aplicación de Turismo

Este directorio contiene todas las pruebas unitarias y de widgets para la aplicación de turismo.

## Estructura de Pruebas

### 1. Pruebas Unitarias de Modelos (`core/data/models/`)
- **user_model_test.dart**: Pruebas para el modelo de usuario
  - Conversión desde/hacia JSON
  - Conversión desde/hacia entidad User
  - Método copyWith
  - Validación de campos opcionales

- **place_model_test.dart**: Pruebas para el modelo de lugar
  - Conversión desde/hacia JSON
  - Conversión desde/hacia entidad Place
  - Manejo de coordenadas (enteros y decimales)
  - Método copyWith

- **preferences_model_test.dart**: Pruebas para el modelo de preferencias
  - Creación de preferencias vacías
  - Conversión desde/hacia JSON
  - Conversión desde/hacia entidad Preferences
  - Método copyWith con parámetros posicionales

### 2. Pruebas Unitarias de Entidades (`core/domain/entities/`)
- **user_test.dart**: Pruebas para la entidad User
  - Creación de usuarios con factory method
  - Método copyWith
  - Validación de campos opcionales

- **place_test.dart**: Pruebas para la entidad Place
  - Conversión a PlaceMin
  - Validación de vectores de preferencias
  - Manejo de diferentes tipos de lugares

- **preferences_test.dart**: Pruebas para la entidad Preferences
  - Validación de preferencias (isValid)
  - Conversión a/desde lista
  - Creación de preferencias vacías
  - Orden correcto de atributos

- **place_min_test.dart**: Pruebas para la entidad PlaceMin
  - Almacenamiento de timestamps
  - Comparación de fechas
  - Lugares escaneados recientemente

### 3. Pruebas Unitarias de Entidades de Features (`features/map_exploration/`)
- **tourist_place_test.dart**: Pruebas para TouristPlace
  - Equatable para comparación de igualdad
  - Vectores de interés complejos
  - Manejo de imágenes y ratings
  - Validación de props

### 4. Pruebas de Lógica de Negocio (`core/utils/logic/`)
- **utils_test.dart** (expandido): Pruebas para VectorUtils
  - Normalización de vectores
  - Manejo de vector cero (excepción)
  - Valores negativos
  - Similitud por coseno (0 a 1, -1 para opuestos)
  - Vectores ortogonales
  - Vectores de preferencias

- **recommendation_engine_test.dart**: Pruebas para RecommendationEngine
  - Recomendaciones basadas en intereses del usuario
  - Ordenamiento por rating cuando no hay preferencias
  - Bonus de calidad en recomendaciones
  - Manejo de claves faltantes en vectores de interés
  - Múltiples categorías de interés
  - Listas vacías

### 5. Pruebas de Widgets (`core/presentation/widgets/`)
- **place_rating_widget_test.dart**: Pruebas para PlaceRatingWidget
  - Renderizado inicial
  - Selección de estrellas (1-5)
  - Cambio de rating
  - Botón submit habilitado/deshabilitado
  - Callback onSubmit con rating correcto
  - Estilos y decoración
  - Múltiples interacciones

- **tourist_place_tile_test.dart**: Pruebas para TouristPlaceTile
  - Renderizado de nombre y icono
  - Formateo de tiempo relativo:
    - "Visto recientemente" (< 1 minuto)
    - "Visto hace X minuto(s)" (< 1 hora)
    - "Visto hace X hora(s)" (< 24 horas)
    - "Visto hace X día(s)" (< 7 días)
    - "Visto el DD/MM/YYYY" (> 7 días)
  - Callback onTap
  - Estilos y layout
  - Múltiples lugares

## Ejecutar las Pruebas

### Todas las pruebas
```bash
flutter test
```

### Pruebas específicas
```bash
# Pruebas de modelos
flutter test test/core/data/models/

# Pruebas de entidades
flutter test test/core/domain/entities/

# Pruebas de lógica
flutter test test/core/utils/logic/

# Pruebas de widgets
flutter test test/core/presentation/widgets/

# Una prueba específica
flutter test test/core/data/models/user_model_test.dart
```

### Con cobertura
```bash
flutter test --coverage
```

Para ver el reporte de cobertura:
```bash
# Instalar lcov si no lo tienes
sudo apt-get install lcov  # Linux
brew install lcov           # macOS

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir en navegador
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## Cobertura de Pruebas

Las pruebas cubren:

### Modelos (100%)
- ✅ Serialización/Deserialización JSON
- ✅ Conversión entre modelos y entidades
- ✅ Métodos copyWith
- ✅ Campos opcionales y requeridos

### Entidades (100%)
- ✅ Constructores y factory methods
- ✅ Validación de datos
- ✅ Métodos de utilidad (toList, fromList, isValid, etc.)
- ✅ Conversiones entre entidades relacionadas

### Lógica de Negocio (100%)
- ✅ Algoritmos de normalización de vectores
- ✅ Similitud por coseno
- ✅ Motor de recomendaciones
- ✅ Manejo de casos edge (vectores vacíos, claves faltantes, etc.)

### Widgets (100%)
- ✅ Renderizado inicial
- ✅ Interacciones del usuario
- ✅ Estados del widget
- ✅ Callbacks y eventos
- ✅ Estilos y layout
- ✅ Formateo de datos

## Notas Importantes

1. **VectorUtils**: La función `normalize` lanza una excepción cuando se intenta normalizar un vector cero. Esto está probado y es el comportamiento esperado.

2. **RecommendationEngine**: Cuando no hay preferencias del usuario, los lugares se ordenan por rating. Cuando hay preferencias, se calcula un score basado en la similitud de intereses más un bonus de calidad.

3. **PlaceRatingWidget**: El botón submit solo se habilita cuando se ha seleccionado al menos una estrella.

4. **TouristPlaceTile**: El formateo de tiempo es relativo y se adapta según cuánto tiempo ha pasado desde el último escaneo.

5. **Preferences**: El método `copyWith` usa parámetros posicionales, no nombrados. Asegúrate de pasar los valores en el orden correcto: hotel, gastronomy, nature, culture.

## Total de Pruebas

- **Pruebas Unitarias de Modelos**: 3 archivos, ~30 tests
- **Pruebas Unitarias de Entidades**: 4 archivos, ~30 tests
- **Pruebas de Lógica**: 2 archivos, ~25 tests
- **Pruebas de Widgets**: 2 archivos, ~40 tests

**Total: ~125 pruebas** que cubren toda la funcionalidad importante de la aplicación.
