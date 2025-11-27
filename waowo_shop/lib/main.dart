import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waowo_shop/core/theme/app_theme.dart';
import 'package:waowo_shop/presentation/viewmodels/auth_viewmodel.dart';
import 'package:waowo_shop/presentation/viewmodels/cart_viewmodel.dart';
import 'package:waowo_shop/presentation/viewmodels/order_viewmodel.dart';
import 'package:waowo_shop/presentation/viewmodels/product_viewmodel.dart';
import 'package:waowo_shop/presentation/screens/auth/login_screen.dart';
import 'package:waowo_shop/presentation/screens/home/home_screen.dart';
import 'package:waowo_shop/presentation/screens/cart/cart_screen.dart';
import 'package:waowo_shop/presentation/screens/orders/orders_screen.dart';
import 'package:waowo_shop/presentation/screens/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
      ],
      child: MaterialApp(
        title: 'WaowoShop',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Écran principal avec navigation
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        // Si l'utilisateur n'est pas authentifié, afficher l'écran de connexion
        if (!authVM.isAuthenticated) {
          return LoginScreen(
            onLoginSuccess: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          );
        }

        // Sinon, afficher la navigation principale
        return Scaffold(
          body: _buildBody(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(onNavigate: _navigateTo);
      case 1:
        return HomeScreen(onNavigate: _navigateTo);
      case 2:
        return const CartScreen();
      case 3:
        return const OrdersScreen();
      case 4:
        return ProfileScreen(
          onLogout: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        );
      default:
        return HomeScreen(onNavigate: _navigateTo);
    }
  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
