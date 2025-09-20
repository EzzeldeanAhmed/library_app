import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/book_model.dart';
import '../providers/books_provider.dart';
import '../providers/cart_provider.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Book Cover
          SliverAppBar(
            expandedHeight: isSmallScreen ? 300 : 400,
            pinned: true,
            backgroundColor: Colors.teal,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'book_${book.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _getBookGradient(book.category),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60), // Space for app bar
                            Icon(
                              Icons.menu_book,
                              size: isSmallScreen ? 80 : 100,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                book.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Network image fallback
                      Positioned.fill(
                        child: Image.network(
                          book.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(); // Show gradient background if image fails
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(); // Show gradient background while loading
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<BooksProvider>(
                builder: (context, booksProvider, child) {
                  final isFavorite = booksProvider.isFavorite(book.id);
                  return IconButton(
                    onPressed: () {
                      booksProvider.toggleFavorite(book);
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),

          // Book Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Author
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 24 : 28,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'by ${book.author}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                  ),

                  const SizedBox(height: 16),

                  // Rating and Reviews
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < book.rating.floor()
                                ? Icons.star
                                : index < book.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: isSmallScreen ? 18 : 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${book.rating} (${book.reviewCount} reviews)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.price,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 18 : 20,
                                  ),
                        ),
                        Text(
                          '\$${book.price.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 24 : 28,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          book.category,
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _getCategoryIcon(book.category),
                        color: Colors.teal,
                        size: isSmallScreen ? 20 : 24,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    l10n.description,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 18 : 20,
                        ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    book.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                  ),

                  const SizedBox(
                      height: 140), // Increased space for bigger bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar with Bigger Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 350) {
                // Stack buttons vertically on very small screens with bigger size
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAddToCartButton(context, isSmallScreen),
                    const SizedBox(height: 16),
                    _buildBuyNowButton(context, isSmallScreen),
                  ],
                );
              } else {
                // Side by side buttons with bigger size
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildAddToCartButton(context, isSmallScreen),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildBuyNowButton(context, isSmallScreen),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, bool isSmallScreen) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(book.id);
        return ElevatedButton.icon(
          onPressed: () {
            if (!isInCart) {
              cartProvider.addToCart(book);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${book.title} added to cart'),
                  backgroundColor: Colors.teal,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isInCart ? Colors.grey : Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical:
                  isSmallScreen ? 18 : 22, // Increased from 12/16 to 18/22
              horizontal: isSmallScreen ? 16 : 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // Increased border radius
            ),
            elevation: isInCart ? 2 : 4,
          ),
          icon: Icon(
            isInCart ? Icons.check_circle : Icons.add_shopping_cart,
            size: isSmallScreen ? 20 : 24, // Increased icon size
          ),
          label: Text(
            isInCart ? 'In Cart' : l10n.addToCart,
            style: TextStyle(
              fontSize:
                  isSmallScreen ? 16 : 18, // Increased from 14/16 to 16/18
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuyNowButton(BuildContext context, bool isSmallScreen) {
    final l10n = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: () {
        // Add to cart if not already added, then navigate to payment
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        if (!cartProvider.isInCart(book.id)) {
          cartProvider.addToCart(book);
        }

        // Navigate to main screen with cart tab selected
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 18 : 22, // Increased from 12/16 to 18/22
          horizontal: isSmallScreen ? 16 : 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Increased border radius
        ),
        elevation: 4,
      ),
      icon: Icon(
        Icons.flash_on,
        size: isSmallScreen ? 20 : 24, // Increased icon size
      ),
      label: Text(
        l10n.buyNow,
        style: TextStyle(
          fontSize: isSmallScreen ? 16 : 18, // Increased from 14/16 to 16/18
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  LinearGradient _getBookGradient(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'history':
        return LinearGradient(
          colors: [Colors.brown.shade400, Colors.brown.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'science fiction':
        return LinearGradient(
          colors: [Colors.cyan.shade400, Colors.cyan.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'biography':
        return LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'self help':
        return LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'mystery':
        return LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return Icons.auto_stories;
      case 'history':
        return Icons.history_edu;
      case 'science fiction':
        return Icons.rocket_launch;
      case 'biography':
        return Icons.person;
      case 'self help':
        return Icons.psychology;
      case 'mystery':
        return Icons.help_outline;
      default:
        return Icons.book;
    }
  }
}
