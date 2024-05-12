class UserResponseModel {
    final String name;
    final String avatar;
    final String email;
    final String id;

    UserResponseModel({
        required this.name,
        required this.avatar,
        required this.email,
        required this.id,
    });


    factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        name: json["name"],
        avatar: json["avatar"],
        email: json["email"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "avatar": avatar,
        "email": email,
        "id": id,
    };
}
