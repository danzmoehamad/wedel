class ModelBaju
{
  //Database tabel_item =  Baju
  int? item_id;
  String? nama;
  double? rating;
  List<String>? tags;
  double? harga;
  List<String>? ukuran;
  List<String>? warna;
  String? deskripsi;
  String? gambar;

  ModelBaju({
    this.item_id,
    this.nama,
    this.rating,
    this.tags,
    this.harga,
    this.ukuran,
    this.warna,
    this.deskripsi,
    this.gambar,

});

  factory ModelBaju.fromJson(Map<String, dynamic> json) => ModelBaju(
    item_id: int.parse(json["item_id"]),
    nama: json["nama"],
    rating: double.parse(json["rating"]),
    tags: json["tags"].toString().split(", "),
    harga: double.parse(json["harga"]),
    ukuran: json["ukuran"].toString().split(", "),
    warna: json["warna"].toString().split(", "),
    deskripsi: json["deskripsi"],
    gambar: json["gambar"],
  );

}