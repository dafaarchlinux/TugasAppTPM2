class User {
  final String username;
  final String password;
  final String name;

  User({
    required this.username,
    required this.password,
    required this.name,
  });
}

// Dummy users for demonstration
final List<User> dummyUsers = [
  User(username: 'admin', password: 'admin123', name: 'Administrator'),
  User(username: 'user', password: 'user123', name: 'Regular User'),
  User(username: 'ahmad', password: 'ahmad123', name: 'Ahmad'),
];