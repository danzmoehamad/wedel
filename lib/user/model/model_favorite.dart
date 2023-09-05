class ModelFavorite {
  //Database Tabel Favorite
  int? favorite_id;
  int? user_id;
  int? item_id;

  //Database Tabel Item
  String? nama;
  double? rating;
  List<String>? tags;
  double? harga;
  List<String>? ukuran;
  List<String>? warna;
  String? deskripsi;
  String? gambar;

  ModelFavorite({
    //Database Tabel Favorite
    this.favorite_id,
    this.user_id,
    this.item_id,

    //Database Tabel Item
    this.nama,
    this.rating,
    this.tags,
    this.harga,
    this.ukuran,
    this.warna,
    this.deskripsi,
    this.gambar,
  });

  factory ModelFavorite.fromJson(Map<String, dynamic> json) =>
      ModelFavorite(
        //Database Tabel Favorite
        favorite_id: int.parse(json['favorite_id']),
        user_id: int.parse(json['user_id']),
        item_id: int.parse(json['item_id']),

        //Database Tabel Item
        nama: json['nama'],
        rating: double.parse(json['rating']),
        tags: json['tags'].toString().split(', '),
        harga: double.parse(json['harga']),
        ukuran: json['ukuran'].toString().split(', '),
        warna: json['warna'].toString().split(', '),
        deskripsi: json['deskripsi'],
        gambar: json['gambar'],
      );
}