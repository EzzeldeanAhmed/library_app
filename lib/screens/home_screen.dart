import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/books_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/book_list_horizontal.dart';
import 'book_details_screen.dart';
import 'books_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Search
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Text
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

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
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: l10n.search,
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              Provider.of<BooksProvider>(context, listen: false)
                                  .setSearchQuery('');
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          Provider.of<BooksProvider>(context, listen: false)
                              .setSearchQuery(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Featured Books Section
              Consumer<BooksProvider>(
                builder: (context, booksProvider, child) {
                  final featuredBooks = booksProvider.featuredBooks;

                  if (featuredBooks.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return BookListHorizontal(
                    title: l10n.featuredBooks,
                    books: featuredBooks,
                    onSeeAll: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BooksListScreen(
                          title: l10n.featuredBooks,
                          books: featuredBooks,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // New Arrivals Section
              Consumer<BooksProvider>(
                builder: (context, booksProvider, child) {
                  final newArrivals = booksProvider.newArrivals;

                  if (newArrivals.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return BookListHorizontal(
                    title: l10n.newArrivals,
                    books: newArrivals,
                    onSeeAll: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BooksListScreen(
                          title: l10n.newArrivals,
                          books: newArrivals,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Best Sellers Section
              Consumer<BooksProvider>(
                builder: (context, booksProvider, child) {
                  final bestSellers = booksProvider.bestSellers;

                  if (bestSellers.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return BookListHorizontal(
                    title: l10n.bestSellers,
                    books: bestSellers,
                    onSeeAll: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BooksListScreen(
                          title: l10n.bestSellers,
                          books: bestSellers,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}
