# 📱 Mi Primera App: Generador de Palabras (Namer App)

Proyecto académico desarrollado para la asignatura de **Desarrollo de Aplicaciones para Dispositivos Móviles**.

---

## 🎯 Objetivo del Proyecto
Crear una aplicación móvil funcional en Flutter que permita la generación de pares de palabras aleatorias, gestionando el estado de la aplicación mediante arquitecturas reactivas y adaptando la interfaz de forma responsiva a diferentes tamaños de pantalla.

## ⚠️ Problema que resuelve
El proyecto resuelve la necesidad de implementar una gestión de estado eficiente en aplicaciones móviles, permitiendo que la interfaz de usuario se actualice automáticamente ante cambios en los datos (como la adición de favoritos) sin necesidad de reconstrucciones manuales complejas.

## 🛠 Tecnologías Utilizadas
* **Framework:** Flutter (Material Design 3)
* **Lenguaje:** Dart
* **Gestión de Estado:** `provider`[cite: 2]
* **Dependencias Externas:** `english_words` (suministro de datos léxicos)[cite: 2]

## 🧠 Conceptos Aplicados
* **Arquitectura de Estado:** Implementación de `ChangeNotifierProvider` como nodo superior para la gestión centralizada de datos[cite: 2].
* **Diseño Responsivo:** Uso de `LayoutBuilder` y `NavigationRail` para ajustar la interfaz según el ancho de la ventana[cite: 2].
* **Composición de Widgets:** Abstracción estética mediante `BigCard` y estandarización de listas con `ListView`[cite: 2].
* **Accesibilidad:** Integración de `semanticsLabel` para compatibilidad con lectores de pantalla[cite: 2].

---

## 📸 Capturas de Pantalla

| Vista | Descripción |
| :--- | :--- |
| **Generador (Home)** | Visualización de pares de palabras con opciones de "Like" y "Next". |
| **Favoritos** | Lista desplazable de los elementos seleccionados por el usuario. |

*(Nota: Asegúrate de reemplazar estas descripciones con las imágenes reales de tu proyecto).*

---

## 🚀 Instrucciones de Ejecución

1. **Requisitos:** Tener instalado el SDK de Flutter y el entorno de desarrollo (VS Code).
2. **Creación:** Utilizar el comando `Flutter: New Project` desde la paleta de comandos.
3. **Dependencias:** Asegurarse de incluir `english_words` y `provider` en el archivo `pubspec.yaml`[cite: 2].
4. **Ejecución:**
```bash
   flutter run