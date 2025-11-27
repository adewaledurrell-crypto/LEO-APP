# WaowoShop - Notes de Développement

## Vue d'ensemble du projet

WaowoShop est une application mobile e-commerce complète développée en Flutter/Dart, conçue pour démontrer une architecture moderne, des pratiques de codage exemplaires et une expérience utilisateur fluide.

## Structure du projet

### Répertoires principaux

```
lib/
├── main.dart                    # Entrée principale de l'application
├── core/                        # Configuration et utilitaires centralisés
│   ├── config/                 # Configuration de l'app
│   ├── theme/                  # Thème et design system
│   └── utils/                  # Utilitaires réutilisables
├── data/                        # Couche données
│   ├── database/               # SQLite et gestion de la base
│   ├── models/                 # Modèles de données
│   └── repositories/           # Repositories pour l'accès aux données
└── presentation/                # Couche présentation
    ├── screens/                # Écrans/Pages
    ├── viewmodels/             # ViewModels (logique métier)
    └── widgets/                # Widgets réutilisables
```

## Architecture - MVVM (Model-View-ViewModel)

### Principes clés

1. **Séparation des préoccupations** : Chaque couche a une responsabilité unique
2. **Testabilité** : Les ViewModels peuvent être testés indépendamment de l'UI
3. **Réutilisabilité** : Code modulaire et réutilisable
4. **Maintenabilité** : Structure claire et facile à maintenir

### Flux de données

```
User Input (UI)
       ↓
   Screen (Écran)
       ↓
ViewModel (Logique)
       ↓
Repository (Accès données)
       ↓
Database (Stockage)
```

## Modèles de données

### User
- `id` : Identifiant unique
- `name` : Nom de l'utilisateur
- `email` : Email (unique)
- `passwordHash` : SHA-256 hash du mot de passe
- `phone` : Numéro de téléphone (optionnel)
- `address` : Adresse (optionnel)
- `createdAt` : Date de création

### Product
- `id` : Identifiant unique
- `name` : Nom du produit
- `description` : Description
- `price` : Prix en USD
- `category` : Catégorie
- `imageUrl` : URL de l'image
- `rating` : Évaluation (0-5)
- `reviewCount` : Nombre d'avis
- `stock` : Quantité en stock
- `popularity` : Score de popularité

### CartItem
- `id` : Identifiant unique
- `productId` : Référence au produit
- `quantity` : Quantité
- `price` : Prix unitaire
- `subtotal` (calculé) : Quantité × Prix

### Order
- `id` : Identifiant unique
- `userId` : Référence à l'utilisateur
- `items` : Liste des articles (CartItems)
- `totalPrice` : Prix total
- `status` : Statut (pending, processing, shipped, delivered, cancelled)
- `createdAt` : Date de création
- `updatedAt` : Dernière mise à jour

## ViewModels expliqués

### AuthViewModel
Gère l'authentification et la session utilisateur
- `currentUser` : Utilisateur connecté
- `isAuthenticated` : Vérifie si l'utilisateur est connecté
- Méthodes : `login()`, `signUp()`, `logout()`

### ProductViewModel
Gère le catalogue de produits et les filtres
- `allProducts` : Liste complète
- `filteredProducts` : Produits filtrés
- `selectedCategory` : Catégorie sélectionnée
- Méthodes : `loadProducts()`, `filterByCategory()`, `searchProducts()`

### CartViewModel
Gère le panier d'achat
- `cartItems` : Articles du panier
- `totalPrice` : Total calculé automatiquement
- Méthodes : `addToCart()`, `removeFromCart()`, `clearCart()`

### OrderViewModel
Gère les commandes
- `orders` : Historique des commandes
- `totalOrders`, `pendingOrders`, `deliveredOrders` : Statistiques
- Méthodes : `createOrder()`, `loadOrders()`, `updateOrderStatus()`

## État et réactivité

### Utilisation de Provider

L'application utilise `Provider` pour la gestion d'état:

```dart
// Écouter les changements
Consumer<ProductViewModel>(
  builder: (context, viewModel, _) {
    // Rebuild automatique quand viewModel change
    return GridView(
      itemCount: viewModel.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = viewModel.filteredProducts[index];
        return ProductCard(product: product);
      },
    );
  },
)
```

### ChangeNotifier

Les ViewModels étendent `ChangeNotifier`:

```dart
class MyViewModel extends ChangeNotifier {
  void updateData() {
    // Modification des données
    data = newData;
    // Notifier les listeners
    notifyListeners();
  }
}
```

## Base de données SQLite

### Initialisation

La base de données s'initialise automatiquement au premier lancement:

1. Création des tables (users, products, cart, orders)
2. Pré-remplissage des 20 produits fictifs
3. Persistance des données entre les sessions

### Requêtes courantes

```dart
// Créer un utilisateur
await userRepository.signUp(name, email, password);

// Récupérer tous les produits
List<Product> products = await productRepository.getAllProducts();

// Ajouter au panier
await cartRepository.addToCart(cartItem);

// Créer une commande
await orderRepository.createOrder(order);
```

## Sécurité

### Mot de passe
- Hachage SHA-256 (non stockage en clair)
- Validation minimale de 6 caractères
- Confirmation pendant la saisie

### Données sensibles
- Stockage local uniquement (pas de serveur dans la démo)
- Pas de données sensibles en logs en production
- Validation des entrées utilisateur

## Performance

### Optimisations

1. **Lazy loading** : Les produits se chargent à la demande
2. **Caching** : Les données sont cachées localement
3. **Images** : URLs utilisées (pas d'images embarquées)
4. **ListView/GridView** : Virtualization des listes longues

### Gestion de la mémoire

```dart
@override
void dispose() {
  // Nettoyer les ressources
  _controller.dispose();
  super.dispose();
}
```

## Conventions de code

### Nommage
- Classes : PascalCase (e.g., `ProductCard`)
- Fonctions/variables : camelCase (e.g., `getProducts()`)
- Constantes : UPPER_SNAKE_CASE (e.g., `MAX_PRICE`)

### Documentation
- Commentaire `///` pour la documentation publique
- Commentaire `//` pour les notes internes
- Chaque classe/méthode doit avoir une documentation

### Format
- Indentation : 2 espaces
- Longueur max de ligne : 80 caractères (idéalement)
- Imports organisés : dart, package, relative

## Testing (à implémenter)

### Test unitaire (ViewModel)
```dart
test('ProductViewModel should load products', () async {
  final viewModel = ProductViewModel();
  await viewModel.loadProducts();
  expect(viewModel.allProducts.length, greaterThan(0));
});
```

### Test de widget
```dart
testWidgets('ProductCard displays product info', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(home: ProductCard(product: mockProduct)),
  );
  expect(find.text('Product Name'), findsOneWidget);
});
```

## Extensibilité

### Ajouter une nouvelle fonctionnalité

1. **Créer le modèle** (`lib/data/models/`)
2. **Créer le repository** (`lib/data/repositories/`)
3. **Créer le ViewModel** (`lib/presentation/viewmodels/`)
4. **Créer l'écran/widget** (`lib/presentation/screens/`)
5. **Ajouter la navigation** (`main.dart`)

### Intégration API future

```dart
// Remplacer les repositories pour utiliser API
class ProductRepository {
  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse(ApiConfig.productsEndpoint));
    return response.statusCode == 200
        ? jsonDecode(response.body)
        : throw Exception('Failed to load');
  }
}
```

## Déploiement

### Pré-déploiement
- [ ] Vérifier la version (pubspec.yaml)
- [ ] Tester sur device réel
- [ ] Vérifier les permissions
- [ ] Vérifier les logs en production

### Build
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### Distribution
- Google Play Store (via Google Play Console)
- Direct APK (sideloading)

## Améliorations futures

1. **Backend API** : Intégrer une véritable API REST
2. **Paiement réel** : Stripe/PayPal integration
3. **Push notifications** : Firebase Cloud Messaging
4. **Analytics** : Firebase Analytics
5. **Tests** : Suite complète de tests unitaires et d'intégration
6. **Offline support** : Meilleure gestion du mode offline
7. **Favoris** : Système de produits favoris
8. **Commentaires** : Système d'avis utilisateurs
9. **Notifications** : Historique des notifications
10. **Multi-langue** : Support i18n

## Support

Pour des questions ou des bugs :
- Ouvrir une issue sur GitHub
- Consulter la documentation Flutter : https://flutter.dev
- Consulter les guides Dart : https://dart.dev
