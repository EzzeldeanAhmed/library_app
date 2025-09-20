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
            'A classic American novel set in the Jazz Age, exploring themes of wealth, love, and the American Dream. Follow Nick Carraway as he tells the story of his mysterious neighbor Jay Gatsby and his obsession with Daisy Buchanan.',
        price: 12.99,
        imageUrl:
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop',
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
            'A gripping tale of racial injustice and childhood innocence in the American South. Through the eyes of Scout Finch, experience a powerful story about moral courage and human dignity.',
        price: 14.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=400&fit=crop',
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
            'A brief history of humankind, exploring how humans conquered the world. From the Stone Age to the Silicon Age, discover the forces that shaped our species and our world.',
        price: 16.99,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop',
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
            'A philosophical novel about following your dreams and finding your personal legend. Join Santiago on his journey from Spain to Egypt in search of treasure and wisdom.',
        price: 13.99,
        imageUrl:
            'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=300&h=400&fit=crop',
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
            'A memoir about education, family, and the struggle for self-invention. A powerful story of transformation through learning and the price of knowledge.',
        price: 15.99,
        imageUrl:
            'https://images.unsplash.com/photo-1519791883288-dc8bd696e667?w=300&h=400&fit=crop',
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
            'A science fiction masterpiece set on the desert planet Arrakis. Follow Paul Atreides in an epic tale of politics, religion, and ecology in the far future.',
        price: 18.99,
        imageUrl:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300&h=400&fit=crop',
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
            'An easy and proven way to build good habits and break bad ones. Learn how tiny changes can lead to remarkable results in this practical guide to behavior change.',
        price: 14.99,
        imageUrl:
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=300&h=400&fit=crop',
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
            'A psychological thriller about a marriage gone terribly wrong. When Amy Dunne disappears, all eyes turn to her husband Nick in this twisty tale of deception.',
        price: 13.99,
        imageUrl:
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300&h=400&fit=crop',
        category: 'Mystery',
        rating: 4.0,
        reviewCount: 1789,
        isFeatured: true,
      ),
      Book(
        id: '9',
        title: '1984',
        author: 'George Orwell',
        description:
            'A dystopian novel about totalitarianism and surveillance. In a world where Big Brother watches everything, Winston Smith struggles to maintain his humanity.',
        price: 11.99,
        imageUrl:
            'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300&h=400&fit=crop',
        category: 'Fiction',
        rating: 4.4,
        reviewCount: 5623,
        isFeatured: true,
        isBestSeller: true,
      ),
      Book(
        id: '10',
        title: 'The 7 Habits of Highly Effective People',
        author: 'Stephen R. Covey',
        description:
            'A powerful approach to personal and professional effectiveness. Learn the habits that can transform your life and help you achieve your goals.',
        price: 17.99,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=400&fit=crop',
        category: 'Self Help',
        rating: 4.3,
        reviewCount: 2890,
        isNewArrival: true,
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
