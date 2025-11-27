# WaowoShop - E-Commerce Mobile Application

WaowoShop est une application mobile e-commerce complète développée avec Flutter et Dart, inspirée par Amazon. Elle offre une expérience d'achat moderne, intuitive et performante.

## 📋 Fonctionnalités

### ✅ Fonctionnalités Principales
- **Authentification** : Inscription et connexion sécurisées avec hachage de mot de passe
- **Page d'accueil** : Affichage des catégories, produits recommandés et barre de recherche
- **Catalogue de produits** : 20 produits fictifs avec filtres (catégorie, prix, popularité)
- **Recherche** : Recherche en temps réel par nom et description
- **Panier d'achat** : Gestion complète avec calcul automatique du total
- **Paiement simulé** : Mock checkout avec création de commandes
- **Suivi des commandes** : Historique et suivi du statut
- **Profil utilisateur** : Gestion du compte et statistiques

### 🎨 Design & UI
- Interface minimaliste inspirée d'Amazon
- Palette de couleurs moderne (Blanc, Bleu, Gris)
- Material Design 3
- Navigation fluide avec bottom navigation bar
- Animations légères et transitions fluides

### 🏗️ Architecture
- **Pattern MVVM** : Séparation claire des responsabilités
- **Clean Architecture** : Couches bien organisées
- **Couches** :
  - **UI** : Écrans et widgets
  - **ViewModel** : Logique métier et gestion d'état avec Provider
  - **Repository** : Accès aux données
  - **Data** : Modèles et base de données

## 🗄️ Base de Données

### SQLite Local
- Stockage des utilisateurs, produits, panier et commandes
- 20 produits fictifs pré-remplissent la base
- Structure relationnelle bien organisée

### Tables
- **users** : Stocke les informations utilisateur
- **products** : Catalogue de produits avec images et évaluations
- **cart** : Panier persistant
- **orders** : Historique des commandes

## 📦 Dépendances Principales

```yaml
# State Management
provider: ^6.0.0

# Database
sqflite: ^2.3.0
path: ^1.8.3
path_provider: ^2.1.0

# Networking
http: ^1.1.0
dio: ^5.3.0

# Utilities
uuid: ^4.0.0
crypto: ^3.0.3
intl: ^0.19.0

# UI
google_fonts: ^6.1.0
iconsax: ^0.0.8
cached_network_image: ^3.3.0
```

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK
- Android SDK (pour Android)
- Xcode (pour iOS)

### Étapes d'installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/adewaledurrell-crypto/LEO-APP.git
   cd LEO-APP/waowo_shop
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer les fichiers (si nécessaire)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Lancer l'application en développement**
   ```bash
   flutter run
   ```

## 📱 Build APK

### Pour générer un APK de release

```bash
# Build APK en mode release
flutter build apk --release

# L'APK sera situé à:
# build/app/outputs/flutter-apk/app-release.apk
```

### Pour un APK en mode debug (développement)

```bash
flutter build apk --debug
```

### Pour construire un app bundle Android

```bash
flutter build appbundle --release
```

## 📂 Structure du Projet

```
waowo_shop/
├── lib/
│   ├── core/
│   │   ├── config/          # Configuration de l'app
│   │   ├── theme/           # Thème et couleurs
│   │   └── utils/           # Utilitaires
│   ├── data/
│   │   ├── database/        # SQLite helper
│   │   ├── models/          # Modèles de données
│   │   └── repositories/    # Couche repository
│   ├── presentation/
│   │   ├── screens/         # Écrans (Auth, Home, Cart, Orders, Profile)
│   │   ├── viewmodels/      # ViewModels (MVVM)
│   │   └── widgets/         # Widgets réutilisables
│   └── main.dart            # Point d'entrée
├── android/                 # Configuration Android
├── ios/                     # Configuration iOS
├── assets/                  # Images et ressources
└── pubspec.yaml            # Dépendances Flutter
```

## 🎯 Écrans Disponibles

### 1. **Écran d'Authentification**
   - Login / Sign Up
   - Validation des champs
   - Hachage sécurisé du mot de passe

### 2. **Écran d'Accueil**
   - Liste des catégories
   - Produits recommandés
   - Barre de recherche
   - Filtre par catégorie

### 3. **Écran du Panier**
   - Affichage des articles
   - Modification des quantités
   - Calcul du total
   - Paiement simulé

### 4. **Écran des Commandes**
   - Historique des commandes
   - Suivi du statut
   - Détails des articles

### 5. **Écran du Profil**
   - Informations utilisateur
   - Statistiques de commandes
   - Paramètres de compte
   - Déconnexion

## 🔐 Sécurité

- Hachage SHA-256 des mots de passe
- Validation des entrées utilisateur
- Gestion sécurisée des sessions
- Permissions Android appropriées

## 🚦 Données Fictives

L'application est pré-remplie avec :
- **20 produits** variés (électronique, accessoires, meubles)
- Catégories : Electronics, Computers, Tablets, Wearables, Storage, Furniture, Accessories
- Données réalistes de prix, images et évaluations

### Utilisateurs de Test
```
Email: test@example.com
Password: test123

(Créez votre propre compte via Sign Up)
```

## 💡 Points Techniques Clés

### State Management
- Utilisation de **Provider** pour la gestion d'état réactive
- ChangeNotifier pour les ViewModels
- MultiProvider pour l'injection de dépendances

### Persistence
- SQLite pour le stockage local persistant
- Singleton pattern pour la base de données
- Migrations automatiques

### Architecture
- Séparation nette entre les couches
- Repositories pour l'abstraction des sources de données
- ViewModels pour la logique métier
- Widgets sans état réutilisables

## 🧪 Tests

Pour exécuter les tests :

```bash
flutter test
```

## 📸 Screenshots

L'application inclut :
- Layouts responsifs
- Design Material Design 3
- Animations fluides
- Support du mode dark/light

## 🐛 Dépannage

### Problème : Erreur de base de données
**Solution** : Supprimez l'application et réinstallez-la pour réinitialiser la base de données

### Problème : Les images ne s'affichent pas
**Solution** : Les images utilisent des placeholders en ligne. Assurez-vous d'avoir une connexion Internet

### Problème : Build APK échoue
**Solution** : 
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 📞 Support

Pour toute question ou bug report, veuillez ouvrir une issue sur le repository GitHub.

## 📄 Licence

Ce projet est sous licence MIT.

## 👨‍💻 Auteur

**Adewal Durrell** - E-Commerce Application Developer

## 🙏 Remerciements

- Flutter et Dart communities
- Inspiration Amazon pour le design UX

---

**Dernière mise à jour** : Novembre 2025
**Version** : 1.0.0

Happy Shopping! 🛍️
