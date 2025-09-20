import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';

class BookListHorizontal extends StatelessWidget {
  final String title;
  final List<Book> books;
  final VoidCallback? onSeeAll;

  const BookListHorizontal({
    super.key,
    required this.title,
    required this.books,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth < 400 ? 140.0 : 160.0;
    final itemHeight = screenWidth < 400 ? 240.0 : 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: screenWidth < 400 ? 18 : 22,
                      ),
                ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.teal[600],
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth < 400 ? 12 : 14,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Books List
        SizedBox(
          height: itemHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Container(
                width: itemWidth,
                margin: const EdgeInsets.only(right: 12),
                child: BookCard(book: book),
              );
            },
          ),
        ),
      ],
    );
  }
}
