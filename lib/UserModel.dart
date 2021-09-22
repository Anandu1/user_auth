class UserModel{
  String? Name;

  UserModel(
      this.Name,

      );
  UserModel.fromJson(var json){
    Name=json()['name'];

  }
}