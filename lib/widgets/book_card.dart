import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../providers/books_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/book_details_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Cover
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          // Book Cover Image
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: _getBookGradient(book.category),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.menu_book,
                                  size: isSmallScreen ? 40 : 50,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    book.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 10 : 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Favorite Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Consumer<BooksProvider>(
                              builder: (context, booksProvider, child) {
                                final isFavorite =
                                    booksProvider.isFavorite(book.id);
                                return GestureDetector(
                                  onTap: () {
                                    booksProvider.toggleFavorite(book);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Rating Badge
                          if (book.rating > 0)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      book.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Book Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Flexible(
                          child: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Author
                        Flexible(
                          child: Text(
                            book.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Price and Add to Cart
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '\$${book.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ),
                            Consumer<CartProvider>(
                              builder: (context, cartProvider, child) {
                                final isInCart = cartProvider.isInCart(book.id);
                                return GestureDetector(
                                  onTap: () {
                                    if (!isInCart) {
                                      cartProvider.addToCart(book);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${book.title} added to cart'),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          isInCart ? Colors.grey : Colors.teal,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isInCart
                                          ? Icons.check
                                          : Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  LinearGradient _getBookGradient(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'history':
        return LinearGradient(
          colors: [Colors.brown.shade400, Colors.brown.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'science fiction':
        return LinearGradient(
          colors: [Colors.cyan.shade400, Colors.cyan.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'biography':
        return LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'self help':
        return LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'mystery':
        return LinearGradient(
          colors: [Colors.indigo.shade400, Colors.indigo.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
