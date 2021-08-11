class UserData {
  UserData({required this.email, required this.pic, required this.name, required this.language});
  String email, pic, name;
  bool language;

  String passemail() {
    return email;
  }

  String passpic() {
    return pic;
  }

  String passname() {
    return name;
  }

  bool passlan() {
    return language;
  }
}
