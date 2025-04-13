class LoginModel {
  String? email;
  String? password;
  String? token; 

  LoginModel({
    required this.email,
    required this.password,
    this.token,
  });

  
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'],
      password: json['password'],
      token: json['token'], 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

}