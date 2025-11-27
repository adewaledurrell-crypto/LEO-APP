# WaowoShop - Guide de Build APK

## 📋 Prérequis

### Environnement de Développement
- **Flutter SDK** 3.0.0 ou supérieur
- **Dart SDK** (inclus avec Flutter)
- **Android SDK** 21 ou supérieur (minSdkVersion)
- **Java Development Kit (JDK)** 11 ou supérieur
- **Gradle** (géré par Flutter)

### Vérification des Outils

```bash
# Vérifier Flutter
flutter --version

# Vérifier Dart
dart --version

# Vérifier la configuration Flutter
flutter doctor
```

## 🔧 Configuration Initiale

### 1. Cloner le Repository

```bash
git clone https://github.com/adewaledurrell-crypto/LEO-APP.git
cd LEO-APP/waowo_shop
```

### 2. Installer les Dépendances Flutter

```bash
flutter pub get
```

Cela va :
- Télécharger tous les packages listés dans `pubspec.yaml`
- Générer les fichiers `pubspec.lock`
- Configurer les dépendances natives

### 3. Générer les Fichiers Requis (optionnel)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Vérifier l'Installation

```bash
flutter analyze
```

Cette commande vérifie :
- La syntaxe Dart
- Les avertissements
- Les erreurs potentielles

## 📱 Build APK

### Option 1 : Build de Release (Recommandé pour Installation)

```bash
flutter build apk --release
```

**Résultat** :
```
build/app/outputs/flutter-apk/app-release.apk
```

Taille approximative : **30-50 MB**

#### Caractéristiques :
- ✅ Code optimisé et minifié
- ✅ Taille plus petite
- ✅ Performance maximale
- ✅ Approprié pour distribution Google Play
- ❌ Pas d'outils de debug

### Option 2 : Build de Debug (Pour Tests)

```bash
flutter build apk --debug
```

**Résultat** :
```
build/app/outputs/flutter-apk/app-debug.apk
```

Taille approximative : **50-80 MB**

#### Caractéristiques :
- ✅ Temps de build plus rapide
- ✅ Outils de debug disponibles
- ✅ Facile à développer et tester
- ❌ Fichier plus volumineux
- ❌ Performance réduite

### Option 3 : Build Split APK (Par Architektur)

```bash
flutter build apk --split-per-abi --release
```

**Résultats** :
```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  (~20 MB)
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk    (~25 MB)
build/app/outputs/flutter-apk/app-x86-release.apk          (~25 MB)
```

**Avantages** :
- Fichiers plus petits
- Téléchargement plus rapide
- Optimal pour chaque architecture

### Option 4 : Build App Bundle (Pour Google Play)

```bash
flutter build appbundle --release
```

**Résultat** :
```
build/app/outputs/bundle/release/app-release.aab
```

**Avantages** :
- Format offciel Google Play
- Génération automatique des APK
- Compression optimale
- Soumission simple à Google Play

## 📝 Process Complet de Build

```bash
# 1. Nettoyer les builds précédents
flutter clean

# 2. Récupérer les dépendances
flutter pub get

# 3. Vérifier les problèmes
flutter analyze

# 4. Formatter le code (optionnel)
flutter format lib/

# 5. Compiler l'APK
flutter build apk --release

# 6. Vérifier le fichier généré
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

## 📲 Installation sur Appareil

### Prérequis
- Téléphone Android connecté via USB
- Débogage USB activé
- ADB (Android Debug Bridge) disponible

### Activation du Débogage USB

1. Ouvrir **Paramètres** → **À propos du téléphone**
2. Appuyer 7 fois sur **Numéro de version**
3. Retour aux **Paramètres** → **Options de développeur**
4. Activer **Débogage USB**

### Installation

#### Méthode 1 : Avec Flutter (Recommandé)

```bash
# Lister les appareils disponibles
flutter devices

# Installer et lancer l'APK
flutter install --release
```

#### Méthode 2 : Avec ADB

```bash
# Installer l'APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou forcé (mettre à jour)
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Lancer l'application
adb shell am start -n com.waowoshop.waowo_shop/.MainActivity
```

#### Méthode 3 : Transfert Manuel

1. Copier `app-release.apk` sur le téléphone
2. Ouvrir le fichier APK dans le gestionnaire de fichiers
3. Autoriser l'installation depuis "Sources inconnues"
4. Appuyer sur "Installer"

## 🔍 Vérification et Tests

### Tests d'Installation

```bash
# Vérifier que l'app est installée
adb shell pm list packages | grep waowo_shop

# Vérifier l'APK
adb shell dumpsys package com.waowoshop.waowo_shop
```

### Logs de Debug

```bash
# Voir les logs en temps réel
flutter logs

# Ou avec ADB
adb logcat
```

### Performance

```bash
# Profiler de performance
flutter run --profile

# Benchmarking
flutter run --benchmark
```

## 🚀 Configuration de Google Play

### Prérequis
- Compte Google Play Console
- Identité de signature configurée
- Politique de confidentialité

### Signature de l'APK

```bash
# Créer une clé de signature (une seule fois)
keytool -genkey -v -keystore ~/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Configurer Flutter pour utiliser la clé
# Créer android/key.properties
```

### Contenu de `android/key.properties`

```properties
storePassword=VOTRE_MOT_DE_PASSE
keyPassword=VOTRE_MOT_DE_PASSE
keyAlias=upload
storeFile=CHEMIN_VERS_KEY.JKS
```

### Build Signé

```bash
flutter build appbundle --release
```

## 📊 Taille et Optimisations

### Vérifier la Taille

```bash
# Taille du fichier APK
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Détails de la taille
flutter build apk --release --analyze-size
```

### Optimisations

```bash
# Minification Dart
flutter build apk --release -t lib/main.dart

# Suppression du code inutilisé
flutter build apk --release --tree-shake-icons
```

## 🐛 Dépannage

### Problème : Erreur de Build

**Symptôme** : Build échoue avec erreur Gradle

```bash
# Solution
flutter clean
flutter pub get
flutter build apk --release
```

### Problème : Erreur de Signature

**Symptôme** : "Certificate is not yet valid"

**Solution** :
```bash
# Supprimer le build et recréer
flutter clean
rm -rf build/
flutter build apk --release
```

### Problème : Erreur de Mémoire

**Symptôme** : "OutOfMemoryError" pendant le build

**Solution** :
```bash
# Augmenter la mémoire Gradle
export GRADLE_OPTS="-Xmx4096m"
flutter build apk --release
```

### Problème : APK Ne S'installe Pas

**Symptôme** : "App not installed" sur l'appareil

**Solutions** :
```bash
# Vérifier la compatibilité Android
adb shell getprop ro.build.version.sdk

# Réinstaller
adb uninstall com.waowoshop.waowo_shop
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Problème : Les Images Ne S'affichent Pas

**Symptôme** : Images manquantes dans l'app

**Solution** : Les images utilisent des URLs en ligne
- Vérifier la connexion internet
- Remplacer les URLs par des images locales dans `assets/`

## 📋 Checklist Avant Publication

- [ ] Flutter et Dart à jour (`flutter upgrade`)
- [ ] Tous les tests passent (`flutter test`)
- [ ] Code analysé (`flutter analyze`)
- [ ] APK de release builded et testé
- [ ] Version number mis à jour dans `pubspec.yaml`
- [ ] Changelog documenté
- [ ] Screenshots et descriptions prêts
- [ ] Politique de confidentialité rédigée
- [ ] Conditions d'utilisation rédigées

## 📞 Commandes Utiles

```bash
# Voir la version
flutter --version

# Vérifier les appareils
flutter devices

# Exécuter en mode release
flutter run --release

# Profiler
flutter run --profile

# Nettoyer
flutter clean

# Mettre à jour Flutter
flutter upgrade

# Vérifier les dépendances
flutter pub outdated

# Mettre à jour les dépendances
flutter pub upgrade

# Analyser
flutter analyze

# Formatter
flutter format lib/

# Tester
flutter test
```

## 📚 Ressources Utiles

- [Flutter Build Documentation](https://flutter.dev/docs/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android Developers](https://developer.android.com/)
- [Flutter Release Notes](https://flutter.dev/docs/release/release-notes)

## 💾 Sauvegarde et Versioning

### Système Versionning Recommandé

Format : `MAJOR.MINOR.PATCH+BUILD`

Exemple : `1.0.0+1` → `1.0.5+5` → `2.0.0+10`

```yaml
# pubspec.yaml
version: 1.0.0+1
```

### Changelog

Créer `CHANGELOG.md` :

```markdown
## [1.0.0] - 2025-11-27
### Added
- Initial release de WaowoShop
- Authentification utilisateur
- Catalogue de 20 produits
- Panier d'achat
- Suivi des commandes

### Fixed
- Bug d'affichage des images

### Changed
- Interface UI optimisée
```

---

**Dernière mise à jour** : Novembre 2025
**Version** : 1.0.0
