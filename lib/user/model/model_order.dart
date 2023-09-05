class ModelOrder
{
  int? order_id;
  int? user_id;
  String? seleksiItem;
  String? systemDelivery;
  String? systemPembayaran;
  String? nota;
  double? total;
  String? gambar;
  String? status;
  DateTime? tanggalOrder;
  String? alamatUser;
  String? nomorKontak;

  ModelOrder({
    this.order_id,
    this.user_id,
    this.seleksiItem,
    this.systemDelivery,
    this.systemPembayaran,
    this.nota,
    this.total,
    this.gambar,
    this.status,
    this.tanggalOrder,
    this.alamatUser,
    this.nomorKontak,
});


  //Tampilkan Order List
  factory ModelOrder.fromJson(Map<String, dynamic> json)=> ModelOrder(
    order_id:int.parse(json["order_id"]),
    user_id:int.parse(json["user_id"]),
    seleksiItem : json["seleksiItem"],
    systemDelivery : json["systemDelivery"],
    systemPembayaran : json["systemPembayaran"],
    nota : json["nota"],
    total : double.parse(json["total"]),
    gambar : json["gambar"],
    status : json["status"],
    tanggalOrder : DateTime.parse(json["tanggalOrder"]),
    alamatUser : json["alamatUser"],
    nomorKontak : json["nomorKontak"],

  );

  Map<String, dynamic> toJson(String seleksiImageBase64)=>
      {
        "order_id": order_id.toString(),
        "user_id" : user_id.toString(),
        "seleksiItem" : seleksiItem,
        "systemDelivery" : systemDelivery,
        "systemPembayaran" : systemPembayaran,
        "nota" : nota,
        "total" : total!.toStringAsFixed(2),
        "gambar" : gambar,
        "status" : status,
        // "tanggalOrder" : tanggalOrder,
        "alamatUser" : alamatUser,
        "nomorKontak" : nomorKontak,
        "imageFile" : seleksiImageBase64,
      };

}
//Variabel seleksiImageBase64