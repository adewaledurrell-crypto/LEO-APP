import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/index.dart';
import 'dart:convert';

/// Classe singleton pour gérer la base de données SQLite
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Obtenir l'instance de la base de données
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialiser la base de données
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'waowo_shop.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  /// Créer les tables
  Future<void> _createTables(Database db, int version) async {
    // Table utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        passwordHash TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Table produits
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL NOT NULL,
        reviewCount INTEGER NOT NULL,
        stock INTEGER NOT NULL,
        popularity INTEGER NOT NULL
      )
    ''');

    // Table panier
    await db.execute('''
      CREATE TABLE cart (
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        productName TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    // Table commandes
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        items TEXT NOT NULL,
        totalPrice REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');

    // Pré-remplir la base avec des produits fictifs
    await _seedProducts(db);
  }

  /// Pré-remplir la base avec des produits
  Future<void> _seedProducts(Database db) async {
    final products = _generateMockProducts();
    for (final product in products) {
      await db.insert('products', product.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  /// Générer les produits fictifs (20 produits)
  List<Product> _generateMockProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'Latest Apple smartphone with A17 Pro chip',
        price: 999.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=iPhone+15',
        rating: 4.8,
        reviewCount: 245,
        stock: 50,
        popularity: 95,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24',
        description: 'Premium Android device with advanced camera',
        price: 899.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=Galaxy+S24',
        rating: 4.7,
        reviewCount: 189,
        stock: 40,
        popularity: 90,
      ),
      Product(
        id: '3',
        name: 'Sony WH-1000XM5 Headphones',
        description: 'Premium noise-cancelling wireless headphones',
        price: 399.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=Sony+Headphones',
        rating: 4.9,
        reviewCount: 567,
        stock: 100,
        popularity: 85,
      ),
      Product(
        id: '4',
        name: 'Apple MacBook Pro 16"',
        description: 'Powerful laptop with M3 Max chip',
        price: 2499.99,
        category: 'Computers',
        imageUrl: 'https://via.placeholder.com/300x300?text=MacBook+Pro',
        rating: 4.9,
        reviewCount: 156,
        stock: 25,
        popularity: 92,
      ),
      Product(
        id: '5',
        name: 'Dell XPS 13',
        description: 'Lightweight and powerful ultrabook',
        price: 1299.99,
        category: 'Computers',
        imageUrl: 'https://via.placeholder.com/300x300?text=XPS+13',
        rating: 4.6,
        reviewCount: 234,
        stock: 35,
        popularity: 80,
      ),
      Product(
        id: '6',
        name: 'iPad Air 11"',
        description: 'Versatile tablet for work and creativity',
        price: 649.99,
        category: 'Tablets',
        imageUrl: 'https://via.placeholder.com/300x300?text=iPad+Air',
        rating: 4.7,
        reviewCount: 312,
        stock: 60,
        popularity: 82,
      ),
      Product(
        id: '7',
        name: 'Samsung Galaxy Tab S9',
        description: 'Premium Android tablet with AMOLED display',
        price: 799.99,
        category: 'Tablets',
        imageUrl: 'https://via.placeholder.com/300x300?text=Galaxy+Tab',
        rating: 4.6,
        reviewCount: 198,
        stock: 45,
        popularity: 78,
      ),
      Product(
        id: '8',
        name: 'Apple Watch Ultra',
        description: 'Advanced smartwatch for outdoor enthusiasts',
        price: 799.99,
        category: 'Wearables',
        imageUrl: 'https://via.placeholder.com/300x300?text=Watch+Ultra',
        rating: 4.8,
        reviewCount: 423,
        stock: 80,
        popularity: 88,
      ),
      Product(
        id: '9',
        name: 'Airpods Pro (2nd Gen)',
        description: 'Premium wireless earbuds with ANC',
        price: 249.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=AirPods+Pro',
        rating: 4.8,
        reviewCount: 678,
        stock: 150,
        popularity: 94,
      ),
      Product(
        id: '10',
        name: 'GoPro Hero 12',
        description: 'Professional action camera',
        price: 499.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=GoPro+Hero',
        rating: 4.7,
        reviewCount: 267,
        stock: 55,
        popularity: 81,
      ),
      Product(
        id: '11',
        name: 'DJI Mini 4 Pro Drone',
        description: 'Compact drone with 4K camera',
        price: 759.00,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=DJI+Mini',
        rating: 4.8,
        reviewCount: 445,
        stock: 30,
        popularity: 86,
      ),
      Product(
        id: '12',
        name: 'Logitech MX Master 3S',
        description: 'Professional wireless mouse',
        price: 99.99,
        category: 'Accessories',
        imageUrl: 'https://via.placeholder.com/300x300?text=MX+Master',
        rating: 4.8,
        reviewCount: 512,
        stock: 120,
        popularity: 79,
      ),
      Product(
        id: '13',
        name: 'Mechanical Gaming Keyboard',
        description: 'RGB mechanical keyboard with Cherry MX switches',
        price: 149.99,
        category: 'Accessories',
        imageUrl: 'https://via.placeholder.com/300x300?text=Gaming+Keyboard',
        rating: 4.7,
        reviewCount: 389,
        stock: 75,
        popularity: 76,
      ),
      Product(
        id: '14',
        name: '4K Monitor 32"',
        description: 'Professional grade 4K IPS display',
        price: 599.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=4K+Monitor',
        rating: 4.6,
        reviewCount: 143,
        stock: 20,
        popularity: 72,
      ),
      Product(
        id: '15',
        name: 'USB-C Hub 10-in-1',
        description: 'Multi-port connectivity hub',
        price: 49.99,
        category: 'Accessories',
        imageUrl: 'https://via.placeholder.com/300x300?text=USB+Hub',
        rating: 4.5,
        reviewCount: 234,
        stock: 200,
        popularity: 65,
      ),
      Product(
        id: '16',
        name: 'Portable SSD 2TB',
        description: 'Fast external storage with USB-C',
        price: 199.99,
        category: 'Storage',
        imageUrl: 'https://via.placeholder.com/300x300?text=SSD+Storage',
        rating: 4.7,
        reviewCount: 523,
        stock: 90,
        popularity: 84,
      ),
      Product(
        id: '17',
        name: 'Gaming Chair Pro',
        description: 'Ergonomic gaming chair with lumbar support',
        price: 299.99,
        category: 'Furniture',
        imageUrl: 'https://via.placeholder.com/300x300?text=Gaming+Chair',
        rating: 4.6,
        reviewCount: 278,
        stock: 40,
        popularity: 73,
      ),
      Product(
        id: '18',
        name: 'Desk Lamp LED',
        description: 'Dimmable LED lamp with USB charging',
        price: 79.99,
        category: 'Furniture',
        imageUrl: 'https://via.placeholder.com/300x300?text=Desk+Lamp',
        rating: 4.5,
        reviewCount: 167,
        stock: 110,
        popularity: 68,
      ),
      Product(
        id: '19',
        name: 'Webcam 4K Pro',
        description: 'Professional streaming webcam',
        price: 129.99,
        category: 'Electronics',
        imageUrl: 'https://via.placeholder.com/300x300?text=Webcam+4K',
        rating: 4.7,
        reviewCount: 345,
        stock: 70,
        popularity: 75,
      ),
      Product(
        id: '20',
        name: 'Wireless Charger Pad',
        description: 'Fast charging pad for multiple devices',
        price: 39.99,
        category: 'Accessories',
        imageUrl: 'https://via.placeholder.com/300x300?text=Charger+Pad',
        rating: 4.4,
        reviewCount: 456,
        stock: 250,
        popularity: 62,
      ),
    ];
  }

  // ===== UTILISATEUR =====

  /// Obtenir un utilisateur par email
  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (result.isEmpty) return null;
      return User.fromMap(result.first);
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  /// Créer un nouvel utilisateur
  Future<bool> createUser(User user) async {
    try {
      final db = await database;
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      print('Erreur lors de la création de l\'utilisateur: $e');
      return false;
    }
  }

  /// Mettre à jour un utilisateur
  Future<bool> updateUser(User user) async {
    try {
      final db = await database;
      final result = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return result > 0;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'utilisateur: $e');
      return false;
    }
  }

  // ===== PRODUITS =====

  /// Obtenir tous les produits
  Future<List<Product>> getAllProducts() async {
    try {
      final db = await database;
      final result = await db.query('products');
      return result.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      return [];
    }
  }

  /// Obtenir un produit par ID
  Future<Product?> getProductById(String id) async {
    try {
      final db = await database;
      final result = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isEmpty) return null;
      return Product.fromMap(result.first);
    } catch (e) {
      print('Erreur lors de la récupération du produit: $e');
      return null;
    }
  }

  /// Obtenir les produits par catégorie
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final db = await database;
      final result = await db.query(
        'products',
        where: 'category = ?',
        whereArgs: [category],
      );
      return result.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des produits par catégorie: $e');
      return [];
    }
  }

  /// Rechercher des produits
  Future<List<Product>> searchProducts(String query) async {
    try {
      final db = await database;
      final result = await db.query(
        'products',
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );
      return result.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la recherche de produits: $e');
      return [];
    }
  }

  // ===== PANIER =====

  /// Obtenir tous les articles du panier
  Future<List<CartItem>> getCartItems() async {
    try {
      final db = await database;
      final result = await db.query('cart');
      return result.map((map) => CartItem.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la récupération du panier: $e');
      return [];
    }
  }

  /// Ajouter au panier
  Future<bool> addToCart(CartItem item) async {
    try {
      final db = await database;
      await db.insert(
        'cart',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Erreur lors de l\'ajout au panier: $e');
      return false;
    }
  }

  /// Supprimer du panier
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final db = await database;
      final result = await db.delete(
        'cart',
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
      return result > 0;
    } catch (e) {
      print('Erreur lors de la suppression du panier: $e');
      return false;
    }
  }

  /// Vider le panier
  Future<bool> clearCart() async {
    try {
      final db = await database;
      await db.delete('cart');
      return true;
    } catch (e) {
      print('Erreur lors du vidage du panier: $e');
      return false;
    }
  }

  // ===== COMMANDES =====

  /// Créer une nouvelle commande
  Future<bool> createOrder(Order order) async {
    try {
      final db = await database;
      await db.insert(
        'orders',
        {
          'id': order.id,
          'userId': order.userId,
          'items': jsonEncode(order.items.map((e) => e.toMap()).toList()),
          'totalPrice': order.totalPrice,
          'status': order.status.name,
          'createdAt': order.createdAt.toIso8601String(),
          'updatedAt': order.updatedAt?.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Erreur lors de la création de la commande: $e');
      return false;
    }
  }

  /// Obtenir les commandes par utilisateur
  Future<List<Order>> getOrdersByUserId(String userId) async {
    try {
      final db = await database;
      final result = await db.query(
        'orders',
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );
      return result.map((map) {
        final itemsList = jsonDecode(map['items'] as String) as List<dynamic>;
        return Order(
          id: map['id'] as String,
          userId: map['userId'] as String,
          items: itemsList
              .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
              .toList(),
          totalPrice: (map['totalPrice'] as num).toDouble(),
          status: OrderStatus.values.firstWhere(
            (status) => status.name == map['status'],
            orElse: () => OrderStatus.pending,
          ),
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: map['updatedAt'] != null
              ? DateTime.parse(map['updatedAt'] as String)
              : null,
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des commandes: $e');
      return [];
    }
  }

  /// Mettre à jour le statut de la commande
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final db = await database;
      final result = await db.update(
        'orders',
        {
          'status': status.name,
          'updatedAt': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [orderId],
      );
      return result > 0;
    } catch (e) {
      print('Erreur lors de la mise à jour du statut: $e');
      return false;
    }
  }

  /// Fermer la base de données
  Future<void> close() async {
    _database?.close();
    _database = null;
  }
}
