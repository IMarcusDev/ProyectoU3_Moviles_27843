# 🌍 Sosa App - Turismo Inteligente con RA y Geolocalización

> **Examen Unidad 3 - Desarrollo de Aplicaciones Móviles** > **Universidad de las Fuerzas Armadas (ESPE)**

Este proyecto es una aplicación móvil desarrollada en **Flutter** que permite a los usuarios explorar lugares turísticos de Quito utilizando mapas interactivos, filtros inteligentes y una experiencia de **Realidad Aumentada (RA)** para ubicar destinos en el entorno real.

## 📌 Requisitos

### Descripción
Guía turística con rutas personalizadas, ubicaciones destacadas, realidad aumentada y recomendaciones basadas en los intereses del usuario.  
Ideal para **cantones, ciudades o provincias turísticas**.

---

### 🛠️ Tecnologías Afinadas

- **Flutter**
- **Google Maps / Mapbox**
- **ARCore / ARKit**
- **Firebase Cloud Storage**
- **Algoritmo de recomendación** (KNN / embeddings)

---

### 📦 Módulos

- Mapa turístico interactivo
- Rutas personalizadas según intereses
- Información turística en **Realidad Aumentada (RA)**
- Filtros:
  - Hoteles
  - Gastronomía
  - Naturaleza
  - Cultura
- Calificaciones y comentarios

## 📋 Evaluación del Proyecto

Se solicita la entrega de los siguientes componentes:

1. **Informe Final**  
   - Valoración: **3 puntos**  
   - Corresponde al **examen teórico**.

2. **Despliegue de la Aplicación**  
   - Valoración: **4 puntos**  
   - Corresponde al **examen práctico**.  
   - Se evaluará la **funcionalidad completa** de la aplicación.

3. **Informe 3.2**  
   - Valoración: **4 puntos**  
   - Corresponde al **deber del tercer parcial**.

---

### 📊 Puntaje Total

- **Total del tercer parcial:** **8 puntos**

---

### ⚠️ Consideraciones Importantes

4. En caso de **no presentar el proyecto**, el estudiante obtendrá **0 puntos** en:
   - Informe Final (examen teórico)
   - Informe 3.2
   - Aplicación (examen práctico)

5. Adicionalmente, **cualquier incumplimiento grave** será sancionado con una **amonestación de 0 puntos** en todos los trabajos correspondientes al parcial.


---


## 🚀 Funcionalidades Implementadas

La aplicación cumple con los requerimientos técnicos avanzados solicitados para el examen:

### 1. 🗺️ Exploración en Mapa (Mapbox Maps Flutter)
* Integración de **`mapbox_maps_flutter`** para visualización de mapas vectoriales de última generación.
* **Geolocalización en tiempo real** del usuario.
* Marcadores interactivos para cada lugar turístico.
* **Filtros Dinámicos:** Barra superior para filtrar por categorías (*Gastronomía, Cultura, Naturaleza, Hoteles*).

### 2. 🧠 Motor de Recomendación (Lógica "IA")
* Algoritmo personalizado (`RecommendationEngine`) que ordena los lugares basándose en:
    * **Vectores de Interés:** Coincidencia matemática entre los gustos del usuario y las etiquetas del lugar.
    * **Calidad:** Ponderación basada en el Rating (estrellas) del lugar.

### 3. 📷 Realidad Aumentada (AR Guide)
* Uso de la **Cámara** y sensores del dispositivo (**Brújula/Magnetómetro** y GPS).
* Cálculo matemático de **Azimut (Bearing)** y distancia (Fórmula de Haversine).
* Superposición de etiquetas flotantes sobre la imagen de la cámara indicando dónde están los lugares y a qué distancia se encuentran.

### 4. ⭐ Sistema de Reseñas y Calificaciones
* Conexión con **Firebase Firestore**.
* Transacciones atómicas para calcular el promedio de estrellas en tiempo real.
* Modal de detalles con información, foto y botón para calificar.

---

## 🏗️ Arquitectura del Proyecto

El código sigue los principios de **Clean Architecture** para garantizar mantenibilidad y escalabilidad.

```text
lib/
├── core/                   # Núcleo compartido
│   ├── logic/              # Algoritmos puros (Motor de recomendación)
│   ├── router/             # Configuración de rutas (GoRouter)
│   ├── services/           # Servicios externos (GPS Location)
│   └── utils/              # Matemáticas para AR (GeoMath)
│
├── features/               # Módulos principales
│   ├── map_exploration/    # Módulo del Mapa
│   │   ├── data/           # Modelos y Repositorios (Firebase impl)
│   │   ├── domain/         # Entidades y Contratos (Abstracción)
│   │   └── presentation/   # UI (Screens, Widgets, Providers)
│   │
│   └── ar_guide/           # Módulo de Realidad Aumentada
│       └── pages/          # Pantalla de Cámara y superposición
│
├── firebase_options.dart   # Configuración generada por FlutterFire
└── main.dart               # Punto de entrada
```

## 🧩 Tecnologías Clave

- **Gestor de Estado:** `flutter_riverpod` (Providers reactivos).
- **Navegación:** `go_router`.
- **Mapas:** `mapbox_maps_flutter` (SDK v1.0+).
- **Backend:** Firebase Firestore.
- **Sensores:** `geolocator`, `flutter_compass`, `camera`.

---

## ⚙️ Configuración para Desarrolladores (IMPORTANTE)

Para clonar y ejecutar este proyecto, **cada miembro del equipo debe configurar las claves secretas**, las cuales **no se suben al repositorio** por razones de seguridad.

---

## 1. Requisitos Previos

- Flutter SDK instalado.
- Cuenta en **Mapbox** con:
  - Token Público  
  - Token Secreto *(scope: Downloads)*
- Proyecto en **Firebase** configurado.

---

## 2. Configurar Mapbox (Android)

Debido a que el SDK de Mapbox es **privado**, se requieren **dos pasos críticos** para que Gradle pueda descargar las dependencias.

---

### A) Archivo `android/local.properties`

Crea o edita este archivo en tu máquina local  
> ⚠️ Este archivo está **ignorado por git**

Agrega tu **Token Secreto** (`sk...`) y la versión mínima de Android:

```properties
sdk.dir=/Ruta/A/Tu/Android/Sdk
flutter.sdk=/Ruta/A/Tu/Flutter/Sdk

# --- CONFIGURACIÓN OBLIGATORIA SOSA APP ---
# Mapbox requiere mínimo API 21
flutter.minSdkVersion=21

# Token secreto (Downloads:Read) para descargar el SDK
MAPBOX_DOWNLOADS_TOKEN=sk.eyJ1Ijo.......(TU_TOKEN_SECRETO_AQUI)
```

### B) Archivo `android/app/src/main/AndroidManifest.xml`

Asegúrate de que los permisos estén activos  
*(ya incluidos en el repositorio)*:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 3. Configurar Firebase

Si al clonar el repositorio el archivo  
`lib/firebase_options.dart` **no existe** o genera error, ejecuta:

```bash
flutterfire configure
```
Durante la configuración, selecciona:
- Proyecto: examen-u3
- Plataformas: Android / iOS

## 📝 Notas Finales

### Datos Iniciales

Si el mapa aparece vacío, verifica que la colección `places` en Firestore tenga documentos.

**Campos requeridos:**

- `name`
- `category`
- `latitude`
- `longitude`
- `rating`
- `interestVector`

Puedes usar el script **DataSeeder** o crear los documentos manualmente.

---

### Pruebas de AR

La Realidad Aumentada requiere un **dispositivo físico** con sensores.  
❌ No funciona correctamente en emuladores Android/iOS.
