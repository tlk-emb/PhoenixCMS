# PhoenixCMS
Contents Management System made by elixir + phoenix

# Usage
After starting phoenix server according to "How To Deploy",

access http://www.localhost:4000 if running on the local server.

Then the initial state is displayed as below.
![](https://user-images.githubusercontent.com/50648545/70306040-29221480-1849-11ea-968d-56daea5e78db.png)

## Login
In order to login to PhoenixCMS, enter http://www.localhost:4000/login.

Login page will be shown.
![](https://user-images.githubusercontent.com/50648545/70306043-2b846e80-1849-11ea-8007-6d8531a68e62.png)

Enter your e-mail address and password, and push "Submit",then you can login.

Annotation: the initial account is registered to DB by seed data when ``` mix run priv/repo/seeds.exs ```.

Its e-mail is "test@test.test"and password is "test". For the first time you must login by this account, after that you should change e-mail and password to yours(the method is described below.). 

## Managing Contents
You can manage the DB tables "user", "category", "images", "temporary files" and "items"(main contents).

When you succeeded to login, the screen will be displayed as below.
![](https://user-images.githubusercontent.com/50648545/70307208-fd545e00-184b-11ea-8bfe-23bd27bc6638.png)

1. "ログアウト"

  - This button make you logout.

2. "ユーザーページ"

  - By pushing this button, you can enter the user page.

  - In it, you can change your username, e-mail and password.
  
  - (When you login or the first time, what you do first is this.)
  
3. "カテゴリ"

  - This button leads you to the category page. you can edit category table in it.

  - Category table has fields as "title", "url", "positon" and "color". 

  - "title" is the string shown on the green tool-bar in the header.

  - "url" is the string used in URL.
  
  - In the tool-bar, the order of categories is determined by "position"(ascending).

  - If you do not want some categories to be shown in the tool-bar, you can set "position" 0.

  - "color" determines the title color of the items of that category.

4. 

# Requirement
Erlang/OTP v22

Elixir v1.9.1

Phoenix v1.3.4

MySQL v5.7.24

# How To Deploy
At first,

```bash
git clone https://github.com/tlk-emb/PhoenixCMS
cd PhoenixCMS/home_page_local
mix deps.get
mix compile
```
Then,
```bash
mix guardian.gen.secret
```
The output is <guardian_secret_key>,used for password authentication.

and

```bash
mix phx.gen.secret
```
The output is <secret_key_base>.

Set following environment variables.(This project uses MySQL for DB!)

- `HOME_PAGE_GUARDIAN_KEY=<guardian_secret_key>`

- `SECRET_KEY_BASE=<secret_key_base>`

- `DATABASE_PASS=<your database password>`

- `DATABASE_HOSTNAME=<your database hostname>`

- `DATABASE_NAME=<your database name>`
  
- `HOME_PAGE_CONTENTS=<absolute path to home_page_local/priv/static/contents/>`

- `HOME_PAGE_STATIC=<absolute path to home_page_local/priv/static/>`

- `HOME_PAGE_UPLOADED=<absolute path to homepage_local/priv/static/images/uploaded/>`

- `HOME_PAGE_DIR=<absolute path to home_page_local/>`

- `HOME_PAGE_URL=http<or https>://www.<your domain name(if running on the local server, "localhost:4000")>`

you make gmail account, and

- `HOME_PAGE_MAIL_PASS=<your gmail account's password>`

- `HOME_PAGE_MAIL_USER_NAME=<your gmail address>`
  
After this, write <your DB user name> directly in dev.exs or prod.exs,please.
  
Finally,execute following codes to run the application.
```bash
export PORT=4000
MIX_ENV=prod<or dev> mix ecto.create
MIX_ENV=prod<or dev> mix ecto.migrate
MIX_ENV=prod<or dev> mix run priv/repo/seeds.exs
MIX_ENV=prod<or dev> mix phx.server
```
If you are running on the local server, go http://localhost:4000 and can see.
