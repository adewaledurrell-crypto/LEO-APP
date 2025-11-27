# 🚀 WaowoShop - Quick Start Guide

## ⚡ Démarrage rapide en 5 minutes

### Prérequis
- Flutter SDK 3.0+ installé
- Android SDK 21+ ou émulateur
- 2GB d'espace disque libre

### Installation rapide

#### Linux/macOS
```bash
cd waowo_shop
chmod +x setup.sh build.sh
./setup.sh
```

Sélectionnez l'option `1` pour setup + build release

#### Windows
```cmd
cd waowo_shop
build.bat release
```

### Résultat attendu
- ✓ APK généré à `build/app/outputs/flutter-apk/app-release.apk`
- ✓ Taille ~50-80 MB
- ✓ Prêt à être installé sur téléphone/émulateur

---

## 📱 Installation sur téléphone

### Via USB (Recommandé)
```bash
# Connectez votre téléphone Android
flutter devices  # Vérifiez que votre appareil est détecté

# Installez et lancez
flutter run -v
```

### Via APK direct
1. Téléchargez l'APK généré
2. Transférez-le sur votre téléphone
3. Ouvrez le fichier APK
4. Acceptez l'installation

---

## 🎮 Premiers pas dans l'app

### Comptes de test
L'app utilise SQLite local, donc créez votre propre compte :

1. **Écran de login** → Cliquez sur "Sign Up"
2. **Créer un compte**:
   - Nom: `John Doe`
   - Email: `john@example.com`
   - Mot de passe: `password123`
3. **Se connecter** avec le même email/mot de passe

### Explorer l'application
- **Home** : Voir les produits recommandés, rechercher, filtrer par catégorie
- **Products** : Parcourir tous les 20 produits avec filtres par prix
- **Cart** : Ajouter/retirer des articles, voir le total
- **Orders** : Voir l'historique après avoir créé une commande
- **Profile** : Gérer votre profil, voir les statistiques

---

## 🔧 Commandes utiles

```bash
# Installation complète
flutter pub get

# Lancer l'app en développement
flutter run

# Lancer avec mode debug
flutter run --debug

# Build APK release
flutter build apk --release

# Build debug APK
flutter build apk --debug

# Analyser le code
flutter analyze

# Nettoyer
flutter clean
```

---

## 📁 Structure du projet

```
waowo_shop/
├── lib/
│   ├── main.dart              ← Entrée principale
│   ├── core/                  ← Configuration, thème, utilitaires
│   ├── data/                  ← Base de données, modèles, repositories
│   └── presentation/          ← Écrans, ViewModels, widgets
├── android/                   ← Configuration Android
├── pubspec.yaml              ← Dépendances
├── BUILD_GUIDE.md            ← Guide de build complet
├── USER_GUIDE.md             ← Guide utilisateur
└── DEVELOPMENT_NOTES.md      ← Notes techniques
```

---

## 🐛 Troubleshooting

### "Flutter not found"
```bash
# Ajouter Flutter au PATH
export PATH="$PATH:$(pwd)/flutter/bin"
```

### "No device found"
```bash
# Lancer un émulateur
flutter emulators --launch Pixel_5_API_30

# Ou connectez un téléphone en USB
adb devices
```

### "Build failed"
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

---

## 📊 Informations de base de données

L'application crée automatiquement une base SQLite avec :

| Table | Enregistrements | Description |
|-------|-----------------|-------------|
| users | 0 (au départ) | Utilisateurs créés |
| products | 20 | Produits pré-chargés |
| cart | Variable | Articles du panier |
| orders | Variable | Historique des commandes |

---

## 🎨 Palette de couleurs

- **Primaire** : Bleu (`#1976D2`)
- **Secondaire** : Bleu clair (`#42A5F5`)
- **Accent** : Orange (`#FFB74D`)
- **Fond** : Blanc cassé (`#FAFAFA`)
- **Texte** : Gris foncé (`#212121`)

---

## 📦 20 Produits pré-chargés

Catégories :
- Electronics (8 produits)
- Computers (2 produits)
- Tablets (2 produits)
- Wearables (1 produit)
- Accessories (4 produits)
- Storage (1 produit)
- Furniture (2 produits)

---

## ✨ Fonctionnalités clés

✅ Authentification (signup/login)
✅ Recherche et filtres
✅ Panier avec calcul automatique
✅ Paiement simulé
✅ Suivi des commandes
✅ Profil utilisateur
✅ 20 produits fictifs
✅ Architecture MVVM
✅ Base de données locale

---

## 📚 Documentation complète

- **BUILD_GUIDE.md** : Instructions de build détaillées
- **USER_GUIDE.md** : Guide utilisateur complet
- **ARCHITECTURE.md** : Architecture et conception
- **DEVELOPMENT_NOTES.md** : Notes techniques pour développeurs
- **CHANGELOG.md** : Historique des versions

---

## 🔗 Ressources utiles

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite Flutter](https://flutter.dev/docs/development/data-and-backend/sqlite)

---

## 💡 Prochaines étapes

1. **Explorez le code** : Lisez les fichiers commentés dans `lib/`
2. **Modifiez le design** : Changez les couleurs dans `lib/core/theme/`
3. **Ajoutez des produits** : Éditez `lib/data/database/database_helper.dart`
4. **Intégrez une API** : Remplacez les repositories par des appels HTTP
5. **Publiez** : Uploadez sur Google Play Store

---

## ⚖️ Licence

MIT License - Libre d'utilisation et de modification

---

## 📧 Support

Pour toute question ou problème :
1. Consultez la documentation correspondante
2. Vérifiez le DEVELOPMENT_NOTES.md
3. Ouvrez une issue sur GitHub

**Bon développement! 🎉**
