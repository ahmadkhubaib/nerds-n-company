%Nerds.Users.User{}
|> Nerds.Users.User.changeset(%{
  email: "testuser@example.com",
  password: "secret1234",
  confirm_password: "secret1234"})
|> Nerds.Repo.insert!()
