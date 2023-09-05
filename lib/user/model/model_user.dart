class ModelUser
{
  int user_id;
  String nama;
  String email;
  String password;
  String alamat;
  String nowa;

  ModelUser(
      this.user_id,
      this.nama,
      this.email,
      this.password,
      this.alamat,
      this.nowa,
      );

  //Menampilan data setelah login
  factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
    int.parse(json["user_id"]),
    json["nama"],
    json["email"],
    json["password"],
    json["alamat"],
    json["nowa"],

  );

  Map<String, dynamic> toJson() =>
      {
        'user_id': user_id.toString(),
        'nama' : nama,
        'email' : email,
        'password' : password,
        'alamat' : alamat,
        'nowa' : nowa,
      };
}