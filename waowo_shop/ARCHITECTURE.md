# WaowoShop - Documentation Technique

## Architecture Globale

### Pattern MVVM (Model-View-ViewModel)

```
┌─────────────────────────────────────────────────────────┐
│                     UI Layer (Flutter)                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ LoginScreen  │  │  HomeScreen  │  │  CartScreen  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
              ↓ Consomme (Provider)
┌─────────────────────────────────────────────────────────┐
│              ViewModel Layer (Logique)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ AuthViewModel│  │ProductViewModel│ │CartViewModel│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
              ↓ Utilise
┌─────────────────────────────────────────────────────────┐
│             Repository Layer (Données)                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │UserRepository│  │ProductRepository│CartRepository│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
              ↓ Accède
┌─────────────────────────────────────────────────────────┐
│            Data Layer (SQLite)                          │
│            DatabaseHelper (Singleton)                   │
└─────────────────────────────────────────────────────────┘
```

## Composants Principaux

### 1. **Modèles de Données** (`lib/data/models/`)

#### User.dart
```dart
class User {
  String id;           // UUID unique
  String name;         // Nom complet
  String email;        // Email unique
  String passwordHash; // SHA-256 hashé
  String? phone;       // Numéro de téléphone optionnel
  String? address;     // Adresse optionnelle
  DateTime createdAt;  // Date de création
}
```

#### Product.dart
```dart
class Product {
  String id;           // UUID unique
  String name;         // Nom du produit
  String description;  // Description détaillée
  double price;        // Prix en USD
  String category;     // Catégorie
  String imageUrl;     // URL de l'image
  double rating;       // Évaluation (0-5)
  int reviewCount;     // Nombre d'avis
  int stock;          // Quantité en stock
  int popularity;     // Score de popularité (0-100)
}
```

#### CartItem.dart
```dart
class CartItem {
  String id;           // UUID unique
  String productId;    // Référence au produit
  String productName;  // Nom du produit
  double price;        // Prix unitaire
  String imageUrl;     // Image du produit
  int quantity;        // Quantité dans le panier
}
```

#### Order.dart
```dart
class Order {
  String id;           // UUID unique
  String userId;       // Référence à l'utilisateur
  List<CartItem> items; // Articles commandés
  double totalPrice;   // Prix total
  OrderStatus status;  // Statut (pending, processing, shipped, delivered)
  DateTime createdAt;  // Date de création
  DateTime? updatedAt; // Dernière mise à jour
}

enum OrderStatus {
  pending,      // En attente
  processing,   // En traitement
  shipped,      // Expédié
  delivered,    // Livré
  cancelled     // Annulé
}
```

### 2. **Base de Données** (`lib/data/database/`)

#### DatabaseHelper (Singleton)

Responsabilités :
- Initialisation de SQLite
- Gestion du cycle de vie de la base de données
- CRUD operations pour toutes les entités
- Pré-remplissage avec 20 produits fictifs

**Méthodes principales** :
```dart
// Utilisateurs
Future<User?> getUserByEmail(String email)
Future<bool> createUser(User user)
Future<bool> updateUser(User user)

// Produits
Future<List<Product>> getAllProducts()
Future<Product?> getProductById(String id)
Future<List<Product>> getProductsByCategory(String category)
Future<List<Product>> searchProducts(String query)

// Panier
Future<List<CartItem>> getCartItems()
Future<bool> addToCart(CartItem item)
Future<bool> removeFromCart(String cartItemId)
Future<bool> clearCart()

// Commandes
Future<bool> createOrder(Order order)
Future<List<Order>> getOrdersByUserId(String userId)
Future<bool> updateOrderStatus(String orderId, OrderStatus status)
```

### 3. **Repositories** (`lib/data/repositories/`)

#### UserRepository
- Enregistrement et connexion sécurisés
- Hachage SHA-256 des mots de passe
- Gestion du profil utilisateur

#### ProductRepository
- Récupération des produits
- Filtrage par catégorie, prix, popularité
- Recherche en temps réel
- Tri et tri personnalisé

#### CartRepository
- Gestion du panier local
- Ajouter/supprimer/vider

#### OrderRepository
- Création de commandes
- Récupération de l'historique
- Mise à jour du statut

### 4. **ViewModels** (`lib/presentation/viewmodels/`)

#### AuthViewModel
```dart
class AuthViewModel extends ChangeNotifier {
  User? currentUser;
  bool isLoading;
  String? errorMessage;
  bool isAuthenticated;
  
  Future<bool> signUp({...})
  Future<bool> login({...})
  void logout()
}
```

**Flux** :
1. Utilisateur entre email et mot de passe
2. ViewModel valide les données
3. Repository exécute la logique métier
4. Database persiste les données
5. ViewModel notifie les listeners
6. UI se met à jour

#### ProductViewModel
```dart
class ProductViewModel extends ChangeNotifier {
  List<Product> allProducts;
  List<Product> filteredProducts;
  List<String> categories;
  String selectedCategory;
  String searchQuery;
  double minPrice, maxPrice;
  
  Future<void> loadProducts()
  void filterByCategory(String category)
  void searchProducts(String query)
  void filterByPrice(double min, double max)
  void resetFilters()
}
```

#### CartViewModel
```dart
class CartViewModel extends ChangeNotifier {
  List<CartItem> cartItems;
  double totalPrice; // Calculé automatiquement
  int itemCount;     // Calculé automatiquement
  
  Future<void> loadCart()
  Future<void> addToCart({...})
  Future<void> removeFromCart(String id)
  Future<void> updateQuantity(String id, int qty)
  Future<void> clearCart()
}
```

#### OrderViewModel
```dart
class OrderViewModel extends ChangeNotifier {
  List<Order> orders;
  int totalOrders;
  int pendingOrders;
  int deliveredOrders;
  
  Future<void> loadOrders(String userId)
  Future<bool> createOrder({...})
  Future<bool> updateOrderStatus(...)
}
```

### 5. **Écrans UI** (`lib/presentation/screens/`)

#### Auth Flow
- **LoginScreen** : Écran unique pour login et signup
- Validation des champs
- Gestion des erreurs
- Transition fluide

#### Main Navigation
```
MainScreen (Stateful)
  ├── 0: HomeScreen (produits recommandés)
  ├── 1: HomeScreen (catégories)
  ├── 2: CartScreen (panier)
  ├── 3: OrdersScreen (commandes)
  └── 4: ProfileScreen (profil)
```

#### Détails des écrans

**HomeScreen**
- Barre de recherche
- Filtres de catégorie
- GridView de produits
- Badge du panier

**CartScreen**
- Liste scrollable des articles
- Modification des quantités
- Calcul du total
- Bouton de paiement

**OrdersScreen**
- Liste des commandes par date
- Indicateurs de statut colorés
- Détails des articles
- Total par commande

**ProfileScreen**
- Avatar et infos utilisateur
- Statistiques (total, livrés, en attente)
- Options de profil
- Bouton de déconnexion

### 6. **Widgets Réutilisables** (`lib/presentation/widgets/`)

#### ProductCard
```dart
ProductCard(
  productId: String,
  name: String,
  price: double,
  imageUrl: String,
  rating: double,
  onTap: () {},
  onAddToCart: () {},
)
```

## Flux de Données

### Inscription Utilisateur
```
LoginScreen
  ↓ (Email, Nom, Mot de passe)
AuthViewModel.signUp()
  ↓
UserRepository.signUp()
  ↓ (Hachage SHA-256)
DatabaseHelper.createUser()
  ↓ (Insert dans SQLite)
AuthViewModel notifyListeners()
  ↓
MainScreen (Navigation)
```

### Ajout au Panier
```
HomeScreen (ProductCard)
  ↓ (Clique sur "Add")
CartViewModel.addToCart()
  ↓
CartRepository.addToCart()
  ↓
DatabaseHelper.addToCart()
  ↓
CartViewModel notifyListeners()
  ↓ (Mises à jour totalPrice, itemCount)
Badge du panier se met à jour
SnackBar de confirmation
```

### Création de Commande
```
CartScreen (Bouton Checkout)
  ↓
OrderViewModel.createOrder()
  ↓
OrderRepository.createOrder()
  ↓
DatabaseHelper.createOrder()
  ↓
CartViewModel.clearCart()
  ↓
OrderViewModel notifyListeners()
  ↓
Confirmation et navigation
```

## Gestion d'État

### Provider Pattern
```dart
// app_main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => ProductViewModel()),
    ChangeNotifierProvider(create: (_) => CartViewModel()),
    ChangeNotifierProvider(create: (_) => OrderViewModel()),
  ],
  child: MaterialApp(...),
)
```

### Consommation dans les Widgets
```dart
// Lecture simple
final authVM = context.read<AuthViewModel>();

// Écoute des changements
Consumer<AuthViewModel>(
  builder: (context, authVM, child) {
    return Text(authVM.currentUser?.name ?? 'Guest');
  },
)

// Avec dépendances multiples
Consumer2<AuthViewModel, OrderViewModel>(
  builder: (context, authVM, orderVM, _) { ... }
)
```

## Sécurité

### Hachage de Mot de Passe
```dart
import 'package:crypto/crypto.dart';

String hash = sha256.convert(password.codeUnits).toString();
```

### Validation
- Email valide (format)
- Mot de passe non vide
- Nom complet requis

### Persistence
- Pas de stockage de mots de passe en clair
- UUID pour les IDs uniques
- Timestamps pour l'audit

## Performance

### Optimisations
- GridView.builder pour les listes longues
- SingleChildScrollView pour les écrans
- Images avec placeholder
- Lazy loading des produits
- Mise en cache des images (cached_network_image)

### State Management
- Notificateurs ciblés (ChangeNotifier)
- Consumer sélectif des widgets
- Évite les rebuilds inutiles

## Extension Future

### Fonctionnalités Potentielles
1. **Paiement Réel** : Stripe, PayPal
2. **Notifications Push** : FCM, OneSignal
3. **Wishlist** : Sauvegarde des favoris
4. **Évaluations** : Système de notes
5. **Chat** : Support utilisateur
6. **Analytics** : Suivi des actions
7. **Offline Mode** : Synchronisation
8. **Social Login** : Google, Facebook

## Tests

### Tests Unitaires
```dart
test('AuthViewModel login with valid credentials', () async {
  final viewModel = AuthViewModel();
  final result = await viewModel.login(
    email: 'test@example.com',
    password: 'password123'
  );
  expect(result, isTrue);
  expect(viewModel.isAuthenticated, isTrue);
});
```

### Tests d'Intégration
```dart
testWidgets('Add to cart flow', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  // Test le flux complet
});
```

## Commandes de Build

```bash
# Development
flutter run

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release

# Clean build
flutter clean
flutter pub get
flutter build apk --release

# Analyze code
flutter analyze

# Format code
flutter format lib/
dart format lib/
```

## Structure des Fichiers Finaux

```
waowo_shop/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── config/
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── utils/
│   ├── data/
│   │   ├── database/
│   │   │   └── database_helper.dart
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── product.dart
│   │   │   ├── cart_item.dart
│   │   │   ├── order.dart
│   │   │   └── index.dart
│   │   └── repositories/
│   │       ├── user_repository.dart
│   │       ├── product_repository.dart
│   │       ├── cart_repository.dart
│   │       └── order_repository.dart
│   └── presentation/
│       ├── screens/
│       │   ├── auth/
│       │   │   └── login_screen.dart
│       │   ├── home/
│       │   │   └── home_screen.dart
│       │   ├── cart/
│       │   │   └── cart_screen.dart
│       │   ├── orders/
│       │   │   └── orders_screen.dart
│       │   └── profile/
│       │       └── profile_screen.dart
│       ├── viewmodels/
│       │   ├── auth_viewmodel.dart
│       │   ├── product_viewmodel.dart
│       │   ├── cart_viewmodel.dart
│       │   └── order_viewmodel.dart
│       └── widgets/
│           └── product_card.dart
├── android/
├── ios/
├── assets/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
└── README.md
```

---

**Version** : 1.0.0
**Dernière mise à jour** : Novembre 2025
