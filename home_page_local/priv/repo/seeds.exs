
#user_id=1はblank
#HomePage.Repo.insert! %HomePage.Accounts.User{
#  name: "blank_user",
#  email: "blank",
#  password: Bcrypt.hash_pwd_salt("blank")
#}


HomePage.Repo.insert! %HomePage.Accounts.User{
  name: "test",
  email: "test@test.test",
  password: Bcrypt.hash_pwd_salt("test")
}
#カテゴリが削除されたアイテムはundifinedとなる
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "undifined",
  url: "undifined",
  position: -1,
  bcolor: "f3df88",
  ccolor: "335544"
}
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "origin",
  url: "origin",
  position: 1,
  bcolor: "f3df88",
  ccolor: "335544"
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "Hello",
  position: 1,
  description: "1.txt",
  size: 8,
  lock: true,
  line: -1,
  category: "origin",
  tab: 2
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "blank",
  position: 1,
  description: "2.txt",
  size: 3,
  lock: true,
  line: 1,
  category: "origin",
  tab: 1
}
