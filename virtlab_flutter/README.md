# VirtLab — Flutter (migrado desde Kodular/App Inventor)

## Qué es esto

Todo el código Dart (`lib/`) está completo: las 14 pantallas del flujo
completo (Splash → Bienvenida → Login/Registro → Personalización →
Menú → Química/Física/Biología → Preguntas → Labi → Logros → Perfil →
Acerca de), con el contenido real de los 14 experimentos migrado
textualmente del `.aia` original, más autenticación, Firestore,
Storage, FCM, personalización con vista previa en vivo, daltonismo y
sistema de logros funcional (incluye el logro "Sin prisa" que en el
original estaba a medio implementar).

## Lo que NO pude hacer en este entorno (y por qué)

Este chat no tiene acceso a internet ni al SDK de Flutter/Android, así
que **no pude**:

1. Correr `flutter create` para generar las carpetas nativas
   `android/` e `ios/` — este proyecto solo trae `lib/`, `pubspec.yaml`
   y `assets/`, no una app Android compilable todavía.
2. Correr `flutter pub get` (no hay red para bajar los paquetes).
3. Compilar, probar en un dispositivo/emulador, ni generar el APK
   final — la Fase 4 (Pruebas) y Fase 5 (Generar APK) de tu
   especificación quedan pendientes de correr de tu lado.
4. Configurar Authentication/Firestore/Storage en la consola real de
   Firebase — el `google-services.json` que subiste solo tiene la API
   key del proyecto `labi-2622a`, sin Auth ni reglas configuradas.

## Opción A — Compilar el APK en la nube con GitHub Actions (sin instalar nada)

Ya incluí el workflow en `.github/workflows/build-apk.yml`. Pasos:

1. Crea un repositorio nuevo en GitHub (puede ser privado) y sube
   **todo** el contenido de este zip tal cual (arrastra la carpeta
   completa en la web de GitHub, o usa `git push` si tienes Git).
2. En el repo: **Settings → Secrets and variables → Actions → New
   repository secret**.
   - Nombre: `GOOGLE_SERVICES_JSON_BASE64`
   - Valor: pega el contenido del archivo `google-services-base64.txt`
     que te compartí junto con este zip (ya es tu `google-services.json`
     real, codificado en base64 — el workflow lo decodifica solo).
3. Ve a la pestaña **Actions** del repo → selecciona "Build VirtLab
   APK" → **Run workflow**.
4. Cuando termine (unos 5-8 minutos), entra a esa ejecución y baja el
   artefacto **virtlab-apk** — ahí está tu `app-release.apk`, listo
   para instalar en cualquier Android.

Nota: el APK saldrá firmado con la clave de debug de Flutter, lo cual
es perfecto para probar en cualquier dispositivo. Para publicarlo en
Google Play vas a necesitar firmarlo con tu propio keystore de
producción (te ayudo con eso cuando llegues a ese paso).

## Opción B — Compilarlo tú localmente

```bash
# 1. Descomprime este zip y entra a la carpeta
cd virtlab_flutter

# 2. Genera las carpetas nativas SIN pisar lib/ ni pubspec.yaml
flutter create --org com.virtlab --project-name virtlab .

# 3. Copia tu google-services.json real a android/app/google-services.json

# 4. En android/build.gradle añade el classpath de Google services,
#    y en android/app/build.gradle aplica el plugin
#    com.google.gms.google-services (guía oficial de FlutterFire).

# 5. Instala dependencias
flutter pub get

# 6. Compila el APK
flutter build apk --release
```

## Cosas que necesitan una decisión tuya antes de producción

- **API key de Gemini expuesta**: el `.aia` original traía la key de
  Gemini escrita en texto plano. No la reutilicé en este código —
  debes regenerarla en Google AI Studio y, en vez de llamarla
  directo desde el cliente, desplegar una Cloud Function que la
  guarde como secreto de servidor. `lib/services/labi_service.dart`
  ya está escrito para llamar a esa función; falta desplegarla.
- **Recordatorios diarios de FCM**: el envío en sí (🧪🔬🏆🎯) necesita
  un cron en el backend (Cloud Scheduler + Cloud Functions, por
  ejemplo) que llame a la API de FCM — un dispositivo no puede
  "programarse a sí mismo" notificaciones mientras la app está
  completamente cerrada.
- **Logro "Sin prisa" (logro_lento)**: en el proyecto original ese tag
  se leía/escribía pero nunca tuvo tarjeta ni condición visible en
  Logros. Implementé una condición razonable (tardar más de 3 minutos
  respondiendo) inferida del temporizador que sí existía en
  Q_Preguntas — confírmala o ajústala si el equipo tenía otra idea.
- Los íconos `logrocolor_5/6/7/8/10.png` (y sus versiones gris) no
  corresponden a ningún logro definido en el proyecto original — están
  en `assets/` por si quieren usarlos para logros nuevos, pero no
  inventé nombres ni condiciones para ellos.
