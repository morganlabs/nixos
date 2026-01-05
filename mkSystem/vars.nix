{
  user =
    let
      username = "morgan";
    in
    {
      inherit username;
      fullName = "Morgan Jones";
      home = "/home/${username}";
      email.work = "me@morganlabs.dev";
      face = ./face.jpg;
    };
}
