{
  user =
    let
      username = "morgan";
    in
    {
      inherit username;
      fullName = "Morgan Jones";
      home = "/home/${username}";
      email = {
        personal = "jmorgan@fastmail.uk";
        work = "me@morganjones.tech";
      };
      face = ./face.jpg;
    };
}
