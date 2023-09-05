class API
{
  //IP Local 192.168.169.250
  // https://wedel.dminc.id
  static const hostConnect = "https://wedel.dminc.id";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";
  static const hostItems = "$hostConnect/items";
  static const hostClothes = "$hostConnect/clothes";
  static const hostCart = "$hostConnect/keranjang";
  static const hostFavorite = "$hostConnect/favorite";
  static const hostOrder = "$hostConnect/order";
  //tampil gambar untuk user
  static const hostImage = "$hostConnect/transaksi/";



  //Validasi
  static const validasiUsername  = "$hostConnectUser/validasi_username.php";

  //Daftar User
  static const daftarUser = "$hostConnectUser/daftar.php";

  //Akses Login User
  static const loginAkses = "$hostConnectUser/login.php";

  //Akses Login Admin
  static const loginAdmin = "$hostConnectAdmin/login.php";
  //read order to admin
  static const adminGetSemuaOrder = "$hostConnectAdmin/read_order.php";


  //Upload Item
  static const uploadItems = "$hostItems/upload.php";

  //Tampil Item Baju
  static const getTrendingPopulerItem = "$hostClothes/trending.php";

  //Tampil Semua Item Baju
  static const getSemuaItem= "$hostClothes/semua_item.php";

  //Keranjang
  static const addSemuaBaju = "$hostCart/add.php";

  //Membaca List Keranjang
  static const getKeranjangList = "$hostCart/read.php";

  //Hapus Item Keranjang oleh user
  static const hapusSeleksiItemDariKeranjang ="$hostCart/hapus.php";

  //Update Item Keranjang oleh user
  static const updateItemdiKeranjang ="$hostCart/update.php";

  //Tambah Favorite
  static const tambahFavorite = "$hostFavorite/favorite.php";

  //Hapus Favorite
  static const hapusFavorite = "$hostFavorite/hapus.php";

  //Validasi Favorite
  static const validasiFavorite = "$hostFavorite/validasi_favorite.php";

  //Read Favorite
  static const readFavorite = "$hostFavorite/read.php";

  //Mesin Pencarian
  static const cariItem = "$hostItems/cari.php";

  //Order User
  static const orderItem = "$hostOrder/add.php";

  //Data Order Item User
  static const readOrderItemUser = "$hostOrder/read.php";

  //Update status
  static const updateStatusPaket = "$hostOrder/update_status.php";

  //History
  static const readHistoryOrder = "$hostOrder/history.php";



}
