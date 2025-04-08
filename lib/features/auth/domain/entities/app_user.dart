class AppUser {
  final String uid;
  final String email;
  final String name;

  // AppUser sınıfının kurucu metodu.
  // Bu metot, bir AppUser nesnesi oluşturmak için kullanılır ve
  // uid, email ve name parametrelerini zorunlu olarak alır.
  AppUser({required this.uid, required this.email, required this.name});

  // Bu metot, AppUser nesnesini bir JSON (Map<String, dynamic>) nesnesine dönüştürür.
  // Bu genellikle veritabanına kaydetmek veya ağ üzerinden veri göndermek için kullanılır.
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name};
  }

  // Bu factory metodu, bir JSON (Map<String, dynamic>) nesnesinden bir AppUser nesnesi oluşturur.
  // Bu genellikle veritabanından okunan veya ağ üzerinden alınan JSON verisini
  // bir AppUser nesnesine dönüştürmek için kullanılır.
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
    );
  }
}
