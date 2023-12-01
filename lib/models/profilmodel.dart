class Profile {
  final String? username;
  final String? name;
  final String? alamat;
  final String? jenisKelamin;
  final String? profilePicture;
  final String? tanggalLahir;
  final String? email;

  Profile({
    this.username,
    this.name,
    this.alamat,
    this.jenisKelamin,
    this.profilePicture,
    this.tanggalLahir,
    this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'],
      name: json['name'],
      alamat: json['alamat'],
      jenisKelamin: json['jenisKelamin'],
      profilePicture: json['profilePicture'],
      tanggalLahir: json['tanggalLahir'],
      email: json['email'],
    );
  }
}
