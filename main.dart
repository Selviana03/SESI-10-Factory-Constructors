// 1. ConnectionFactory dengan pooling koneksi database
class DatabaseConnection {
  final String id;
  DatabaseConnection(this.id);
}

class ConnectionFactory {
  // Sederhana: list sebagai pool
  static final List<DatabaseConnection> _pool = [
    DatabaseConnection('Connection-A'),
    DatabaseConnection('Connection-B'),
  ];

  static DatabaseConnection getConnection() {
    if (_pool.isEmpty) throw Exception("Tidak ada koneksi tersedia!");
    return _pool.removeAt(0);
  }

  static void releaseConnection(DatabaseConnection conn) {
    _pool.add(conn);
    print("Koneksi ${conn.id} dikembalikan ke pool.");
  }
}

// 2. NotificationFactory yang memilih subclass berdasarkan platform
abstract class Notification {
  void send(String message);
}

class EmailNotification implements Notification {
  @override
  void send(String message) => print("Mengirim Email: $message");
}

class PushNotification implements Notification {
  @override
  void send(String message) => print("Mengirim Push Notification: $message");
}

class NotificationFactory {
  static Notification createNotification(String platform) {
    switch (platform.toLowerCase()) {
      case 'email': return EmailNotification();
      case 'push': return PushNotification();
      default: throw Exception('Platform tidak dikenal');
    }
  }
}

// 3. ShapeFactory dengan cache untuk shapes yang sama
abstract class Shape {
  void draw();
}

class Circle implements Shape {
  @override
  void draw() => print("Menggambar Lingkaran");
}

class ShapeFactory {
  static final Map<String, Shape> _cache = {};

  static Shape getShape(String type) {
    if (!_cache.containsKey(type)) {
      print("Membuat objek baru: $type");
      _cache[type] = Circle(); // Contoh untuk circle
    } else {
      print("Mengambil dari cache: $type");
    }
    return _cache[type]!;
  }
}

void main() {
  print("--- DEMO FACTORY PATTERN ---");

  // Demo 1: Pooling
  var conn = ConnectionFactory.getConnection();
  print("Menggunakan: ${conn.id}");
  ConnectionFactory.releaseConnection(conn);

  // Demo 2: Platform Factory
  var note = NotificationFactory.createNotification('email');
  note.send('Halo Serlin!');

  // Demo 3: Caching
  var s1 = ShapeFactory.getShape('circle');
  var s2 = ShapeFactory.getShape('circle'); // Mengambil dari cache
}
