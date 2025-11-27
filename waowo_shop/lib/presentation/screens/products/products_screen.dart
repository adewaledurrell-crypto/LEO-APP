import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/viewmodels/product_viewmodel.dart';
import '../../../presentation/viewmodels/cart_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import '../../../presentation/widgets/product_card.dart';

/// Écran de catalogue de produits
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  double _minPrice = 0;
  double _maxPrice = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, productVM, _) {
          return Column(
            children: [
              // Filtres
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: productVM.categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(category),
                        selected: productVM.selectedCategory == category,
                        onSelected: (selected) {
                          productVM.filterByCategory(category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Grille de produits
              Expanded(
                child: productVM.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productVM.filteredProducts.isEmpty
                        ? const Center(
                            child: Text('No products found'),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount:
                                productVM.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  productVM.filteredProducts[index];
                              return ProductCard(
                                productId: product.id,
                                name: product.name,
                                price: product.price,
                                imageUrl: product.imageUrl,
                                rating: product.rating,
                                onTap: () {
                                  // Navigate to product details
                                },
                                onAddToCart: () {
                                  context
                                      .read<CartViewModel>()
                                      .addToCart(
                                        productId: product.id,
                                        productName:
                                            product.name,
                                        price: product.price,
                                        imageUrl:
                                            product.imageUrl,
                                      );
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.name} added to cart',
                                      ),
                                      duration:
                                          const Duration(
                                            seconds: 2,
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter by Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Slider(
                    value: _minPrice,
                    min: 0,
                    max: _maxPrice,
                    onChanged: (value) {
                      setState(() {
                        _minPrice = value;
                      });
                    },
                  ),
                  Slider(
                    value: _maxPrice,
                    min: _minPrice,
                    max: 10000,
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProductViewModel>()
                            .filterByPrice(
                              min: _minPrice,
                              max: _maxPrice,
                            );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
