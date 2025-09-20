import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BooksProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _favoriteBooks = [];
  String _searchQuery = '';
  String _selectedCategory = '';

  List<Book> get books => _books;
  List<Book> get favoriteBooks => _favoriteBooks;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Filter books based on search query and category
  List<Book> get filteredBooks {
    var filtered = _books;

    if (_selectedCategory.isNotEmpty) {
      filtered =
          filtered.where((book) => book.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((book) =>
              book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              book.author.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  List<Book> get featuredBooks =>
      _books.where((book) => book.isFeatured).toList();
  List<Book> get newArrivals =>
      _books.where((book) => book.isNewArrival).toList();
  List<Book> get bestSellers =>
      _books.where((book) => book.isBestSeller).toList();

  List<String> get categories =>
      _books.map((book) => book.category).toSet().toList();

  void initializeBooks() {
    _books = [
      Book(
        id: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        description:
            'A classic American novel set in the Jazz Age, exploring themes of wealth, love, and the American Dream.',
        price: 12.99,
        imageUrl:
            'https://via.placeholder.com/300x400/FF6B6B/FFFFFF?text=The+Great+Gatsby',
        category: 'Fiction',
        rating: 4.2,
        reviewCount: 1205,
        isFeatured: true,
        isBestSeller: true,
      ),
      Book(
        id: '2',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        description:
            'A gripping tale of racial injustice and childhood innocence in the American South.',
        price: 14.99,
        imageUrl:
            'https://via.placeholder.com/300x400/4ECDC4/FFFFFF?text=To+Kill+a+Mockingbird',
        category: 'Fiction',
        rating: 4.5,
        reviewCount: 2341,
        isFeatured: true,
      ),
      Book(
        id: '3',
        title: 'Sapiens',
        author: 'Yuval Noah Harari',
        description:
            'A brief history of humankind, exploring how humans conquered the world.',
        price: 16.99,
        imageUrl:
            'https://via.placeholder.com/300x400/45B7D1/FFFFFF?text=Sapiens',
        category: 'History',
        rating: 4.4,
        reviewCount: 1876,
        isNewArrival: true,
        isBestSeller: true,
      ),
      Book(
        id: '4',
        title: 'The Alchemist',
        author: 'Paulo Coelho',
        description:
            'A philosophical novel about following your dreams and finding your personal legend.',
        price: 13.99,
        imageUrl:
            'https://via.placeholder.com/300x400/96CEB4/FFFFFF?text=The+Alchemist',
        category: 'Fiction',
        rating: 4.1,
        reviewCount: 3421,
        isFeatured: true,
      ),
      Book(
        id: '5',
        title: 'Educated',
        author: 'Tara Westover',
        description:
            'A memoir about education, family, and the struggle for self-invention.',
        price: 15.99,
        imageUrl:
            'https://via.placeholder.com/300x400/FFEAA7/000000?text=Educated',
        category: 'Biography',
        rating: 4.6,
        reviewCount: 987,
        isNewArrival: true,
      ),
      Book(
        id: '6',
        title: 'Dune',
        author: 'Frank Herbert',
        description:
            'A science fiction masterpiece set on the desert planet Arrakis.',
        price: 18.99,
        imageUrl: 'https://via.placeholder.com/300x400/DDA0DD/000000?text=Dune',
        category: 'Science Fiction',
        rating: 4.3,
        reviewCount: 2156,
        isBestSeller: true,
      ),
      Book(
        id: '7',
        title: 'Atomic Habits',
        author: 'James Clear',
        description:
            'An easy and proven way to build good habits and break bad ones.',
        price: 14.99,
        imageUrl:
            'https://via.placeholder.com/300x400/FF7675/FFFFFF?text=Atomic+Habits',
        category: 'Self Help',
        rating: 4.7,
        reviewCount: 4532,
        isNewArrival: true,
        isBestSeller: true,
      ),
      Book(
        id: '8',
        title: 'Gone Girl',
        author: 'Gillian Flynn',
        description:
            'A psychological thriller about a marriage gone terribly wrong.',
        price: 13.99,
        imageUrl:
            'https://via.placeholder.com/300x400/A29BFE/FFFFFF?text=Gone+Girl',
        category: 'Mystery',
        rating: 4.0,
        reviewCount: 1789,
        isFeatured: true,
      ),
    ];
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    notifyListeners();
  }

  bool isFavorite(String bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }

  void toggleFavorite(Book book) {
    if (isFavorite(book.id)) {
      _favoriteBooks.removeWhere((b) => b.id == book.id);
    } else {
      _favoriteBooks.add(book);
    }
    notifyListeners();
  }

  Book? getBookById(String id) {
    try {
      return _books.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}
