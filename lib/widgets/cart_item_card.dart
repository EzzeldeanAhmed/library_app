import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Book Cover
              Container(
                width: isSmallScreen ? 60 : 80,
                height: isSmallScreen ? 80 : 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: _getBookGradient(cartItem.book.category),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // Gradient background with icon
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: isSmallScreen ? 20 : 25,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cartItem.book.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 8 : 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Network image overlay
                      Image.network(
                        cartItem.book.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(); // Show gradient if image fails
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: isSmallScreen ? 12 : 16),

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Author
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.book.title,
                          maxLines: isSmallScreen ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cartItem.book.author,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price
                    Text(
                      '\$${cartItem.book.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quantity Controls and Remove Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity Controls
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (cartItem.quantity > 1) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .updateQuantity(cartItem.book.id,
                                          cartItem.quantity - 1);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16,
                              ),
                              child: Text(
                                cartItem.quantity.toString(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .updateQuantity(cartItem.book.id,
                                        cartItem.quantity + 1);
                              },
                              child: Container(
                                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: isSmallScreen ? 14 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Remove Button
                        GestureDetector(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .removeFromCart(cartItem.book.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red[400],
                              size: isSmallScreen ? 18 : 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          colors: [Colors.teal.shade400, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
