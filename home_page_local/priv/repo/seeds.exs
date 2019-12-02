
#user_id=1はblank
#HomePage.Repo.insert! %HomePage.Accounts.User{
#  name: "blank_user",
#  email: "blank",
#  password: Bcrypt.hash_pwd_salt("blank")
#}


HomePage.Repo.insert! %HomePage.Accounts.User{
  name: "test",
  email: "kawakami.koji.88v@st.kyoto-u.ac.jp",
  password: Bcrypt.hash_pwd_salt("testtest")
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
  title: "プロフィール",
  url: "profile",
  position: 1,
  bcolor: "f3df88",
  ccolor: "335544"
}
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "活動",
  url: "activity",
  position: 2,
  bcolor: "ef8888",
  ccolor: "ffffcc"
}
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "リンク",
  url: "link",
  position: 3,
  bcolor: "33ac99",
  ccolor: "dffeff"
}

HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "所属",
  position: 1,
  description: "1.txt",
  size: 4,
  lock: true,
  line: -1,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "連絡先",
  position: 2,
  description: "2.txt",
  size: 7,
  lock: true,
  line: 1,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "研究分野",
  position: 3,
  description: "3.txt",
  size: 10,
  lock: true,
  line: -2,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "担当講義",
  position: 4,
  description: "4.txt",
  size: 11,
  lock: true,
  line: -3,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "略歴",
  position: 5,
  description: "5.txt",
  size: 7,
  lock: true,
  line: -4,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "趣味",
  position: 6,
  description: "6.txt",
  size: 4,
  lock: true,
  line: 4,
  category: "プロフィール",
  tab: 1
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "活動",
  position: 1,
  description: "7.txt",
  size: 11,
  lock: true,
  line: -1,
  category: "活動",
  tab: 2
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "論文・発表",
  position: 2,
  description: "8.txt",
  size: 11,
  lock: true,
  line: -2,
  category: "活動",
  tab: 5
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "受賞",
  position: 3,
  description: "9.txt",
  size: 7,
  lock: true,
  line: -3,
  category: "活動",
  tab: 2
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "リンク",
  position: 1,
  description: "10.txt",
  size: 4,
  lock: true,
  line: -1,
  category: "リンク",
  tab: 1
}


#HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
#  title: "original item",
#  description: 1,
#  position: 0,
#  size: 6
#}
