class ModelKeranjang
{
  //Database Tabel Keranjang
  int? keranjang_id;
  int? user_id;
  int? item_id;
  int? kuantitas;
  String? warna_item;
  String? ukuran_item;

  //Database Tabel Item
  String? nama;
  double? rating;
  List<String>? tags;
  double? harga;
  List<String>? ukuran;
  List<String>? warna;
  String? deskripsi;
  String? gambar;

  ModelKeranjang({
    //Database Tabel Keranjang
    this.keranjang_id,
    this.user_id,
    this.item_id,
    this.kuantitas,
    this.warna_item,
    this.ukuran_item,

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

  factory ModelKeranjang.fromJson(Map<String, dynamic> json) => ModelKeranjang(
      //Database Tabel Keranjang
      keranjang_id: int.parse(json['keranjang_id']),
      user_id: int.parse(json['user_id']),
      item_id: int.parse(json['item_id']),
      kuantitas: int.parse(json['kuantitas']),
      warna_item: json['warna_item'],
      ukuran_item: json['ukuran_item'],

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

  //tabel item - sizes, colors   tabel cart size, color (Tutorials)
  //tabel item - ukuran, warna   tabel keranjang ukuran_item, warna_item

}