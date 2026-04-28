class LoginResponedModel {
  LoginResponedModel({required this.token, required this.refreshToken});

  final String? token;
  final String? refreshToken;

  LoginResponedModel copyWith({String? token, String? refreshToken}) {
    return LoginResponedModel(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory LoginResponedModel.fromJson(Map<String, dynamic> json) {
    return LoginResponedModel(
      token: json["token"],
      refreshToken: json["refreshToken"],
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "refreshToken": refreshToken,
  };

  @override
  String toString() {
    return "$token, $refreshToken, ";
  }
}
