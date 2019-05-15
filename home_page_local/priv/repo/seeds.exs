
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

HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "プロフィール"
}
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "活動"
}
HomePage.Repo.insert! %HomePage.Pages.Category{
  title: "リンク"
}

HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "所属",
  position: 1,
  description: "1.txt",
  size: 4,
  lock: true,
  line: -1,
  category: "プロフィール"
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
  position: 7,
  description: "7.txt",
  size: 11,
  lock: true,
  line: -5,
  category: "活動",
  tab: 2
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "論文・発表",
  position: 8,
  description: "8.txt",
  size: 11,
  lock: true,
  line: -6,
  category: "活動",
  tab: 5
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "受賞",
  position: 9,
  description: "9.txt",
  size: 7,
  lock: true,
  line: -7,
  category: "活動",
  tab: 2
}
HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
  user_id: 1,
  title: "リンク",
  position: 10,
  description: "10.txt",
  size: 4,
  lock: true,
  line: 7,
  category: "リンク"
}


#HomePage.Repo.insert! %HomePage.Contents.ComponentItem{
#  title: "original item",
#  description: 1,
#  position: 0,
#  size: 6
#}
