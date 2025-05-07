

class LoginReq{
  String username;
  String password;
  String firebaseKey;

  LoginReq(this.username, this.password, this.firebaseKey);

  Map<String, dynamic> toMap() => {
    "username": username,
    "password": password,
    "firebaseKey": firebaseKey
  };
}