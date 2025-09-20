import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/books_provider.dart';
import '../widgets/book_card.dart';
import 'books_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    final crossAxisCount = screenSize.width < 350 ? 1 : 2;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(l10n.categories),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<BooksProvider>(
        builder: (context, booksProvider, child) {
          final categories = booksProvider.categories;

          if (categories.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.search,
                      hintStyle: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 16,
                        vertical: isSmallScreen ? 10 : 12,
                      ),
                    ),
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                    onChanged: (value) {
                      booksProvider.setSearchQuery(value);
                    },
                  ),
                ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // Categories Grid Title
                Text(
                  'Browse Categories',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: isSmallScreen ? 18 : 22,
                      ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Categories Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 1 ? 3.0 : 1.5,
                    crossAxisSpacing: isSmallScreen ? 12 : 16,
                    mainAxisSpacing: isSmallScreen ? 12 : 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final categoryBooks = booksProvider.books
                        .where((book) => book.category == category)
                        .toList();

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BooksListScreen(
                              title: category,
                              books: categoryBooks,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getCategoryColors(category),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: crossAxisCount == 1
                              ? Row(
                                  children: [
                                    Icon(
                                      _getCategoryIcon(category),
                                      color: Colors.white,
                                      size: isSmallScreen ? 24 : 32,
                                    ),
                                    SizedBox(width: isSmallScreen ? 12 : 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              category,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    isSmallScreen ? 16 : 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${categoryBooks.length} books',
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: isSmallScreen ? 12 : 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      _getCategoryIcon(category),
                                      color: Colors.white,
                                      size: isSmallScreen ? 24 : 32,
                                    ),
                                    const Spacer(),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 14 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${categoryBooks.length} books',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: isSmallScreen ? 10 : 12,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: isSmallScreen ? 20 : 24),

                // All Books Section
                Text(
                  'All Books',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        fontSize: isSmallScreen ? 18 : 22,
                      ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // Books Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 1 ? 1.2 : 0.7,
                    crossAxisSpacing: isSmallScreen ? 12 : 16,
                    mainAxisSpacing: isSmallScreen ? 12 : 16,
                  ),
                  itemCount: booksProvider.filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = booksProvider.filteredBooks[index];
                    return BookCard(book: book);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Color> _getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return [Colors.purple.shade400, Colors.purple.shade600];
      case 'non-fiction':
        return [Colors.blue.shade400, Colors.blue.shade600];
      case 'romance':
        return [Colors.pink.shade400, Colors.pink.shade600];
      case 'mystery':
        return [Colors.indigo.shade400, Colors.indigo.shade600];
      case 'science fiction':
        return [Colors.cyan.shade400, Colors.cyan.shade600];
      case 'biography':
        return [Colors.orange.shade400, Colors.orange.shade600];
      case 'history':
        return [Colors.brown.shade400, Colors.brown.shade600];
      case 'self help':
        return [Colors.green.shade400, Colors.green.shade600];
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return Icons.auto_stories;
      case 'non-fiction':
        return Icons.fact_check;
      case 'romance':
        return Icons.favorite;
      case 'mystery':
        return Icons.help_outline;
      case 'science fiction':
        return Icons.rocket_launch;
      case 'biography':
        return Icons.person;
      case 'history':
        return Icons.history_edu;
      case 'self help':
        return Icons.psychology;
      default:
        return Icons.book;
    }
  }
}
