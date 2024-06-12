class User{
  String userid;
  String username;
  String gender;
  String role;
  int mobileNo;
  String password;

  User(
      this.userid,
      this.username,
      this.gender,
      this.mobileNo,
      this.password,
      this.role
      );


  toJson()
  {
    return {
      'username' : username,
      'userid' : userid,
      'gender' : gender,
      'role' : role,
      'mobileNo' : mobileNo,
      'password' : password
    };
  }
}