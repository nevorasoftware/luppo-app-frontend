# Luppo App - Frontend Web

Aplicación Web moderna, responsiva y orientada a la aceleración comercial para **Luppo — Plataforma Inteligente de Gestión Comercial**.

## 🎨 Características
- **Framework**: Flutter Web (Dart 3.x)
- **Diseño**: Material 3 con paleta de marca exclusiva Luppo (#112A46, #19A7A0, #183957, #F5F7FA)
- **Responsive**: Adaptado fluidamente a Desktop (1920x1080, 1440x900), Tablet y Mobile Web.
- **Navegación**: Sidebar interactivo en desktop/tablet y navegación adaptativa en mobile.
- **Consumo REST**: Integración total con `luppo-app-backend` (/api/v1).

## 🚀 Requisitos
- Flutter SDK (versión 3.19+)
- Navegadores soportados: Chrome, Edge, Firefox, Safari

## ⚙️ Configuración
El frontend utiliza la variable central `API_BASE_URL` configurada en `lib/config/app_config.dart` o pasada en tiempo de compilación con `--dart-define`:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api/v1
```

## 🛠 Ejecución Local
```bash
# Instalar dependencias
flutter pub get

# Ejecutar en Chrome
flutter run -d chrome
```

## 📦 Build para Producción
```bash
flutter build web --release --dart-define=API_BASE_URL=https://tu-backend-railway.up.railway.app/api/v1
```
