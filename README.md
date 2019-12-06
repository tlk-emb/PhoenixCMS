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
You can manage the DB tables "user", "category", "images", "temporary files" and "component_items"(main contents).

When you succeeded to login, the screen will be displayed as below.

![](https://user-images.githubusercontent.com/50648545/70307208-fd545e00-184b-11ea-8bfe-23bd27bc6638.png)

1. "ログアウト" ("Logout")

    - This button make you logout.

2. "ユーザーページ" ("User Page")

    - By pushing this button, you can enter the user page.

    - In it, you can change your username, e-mail and password.
  
    - (When you login or the first time, what you do first is this.)
  
3. "カテゴリ" ("Category")

    - This button leads you to the category page. you can edit category table in it.

4. "画像" ("Images")

    - From this button, you can upload image files(png, jpg).
  
5. "tmpファイル" ("Temporary Files")

    - You can upload your local files and download files from server.
  
    - The setting of uploading file is described in ```home_page_local/lib/endpoint.ex``` and can be modified.
  
    - When you deploy this project on the remote server, the Web server might limit the size of file you try to upload.
  
    - In this case, edit its setting.
  
6. This is the basic format of items.

    - You can edit from "Edit" button and delete from "Delete" button.

7. This is "blank item".

    - If you set the title of the item, it will be shown as this.
  
    - Title and discriptions are not shown. Background color is transparent.
  
    - Only show its thumbnail image if it is set.
  
    - Basic usage is gap adjustment of items.
  
    - If your window is smaller than a certain ammount, "blank item" is not shown.
  
8. "Add New Item"

    - When you add a item, push this button.
 
9. "Preview"

    - If you want to see how the display is shown for users who is not logged in, push this button.
  
## Category

Category table has editable fields "title", "url", "positon" and "color". 

- "title" is the string shown on the green tool-bar in the header.

- "url" is the string used in URL.
  
- In the tool-bar, the order of categories is determined by "position"(ascending).

- If you do not want some categories to be shown in the tool-bar, you can set "position" 0.

- "color" determines the title color of the items of that category.

## Items
Component_items table has editable fields "title", "category", "position", "tab", "description", "size", "lock", "thumbnail"

- "category" determines the URL where the item is shown.

- Items are shown in ascending order of "position" from top left to right.

- If "tab" value is 2 or more(up to 10), the item has tab. You can edit title and text of each tab.

- Items show the text which you set in "description".

- "size" specifies the size of items. The max value is 11 and if the sum of size values of items on a same line exceeds 11, item is displayed on on the next line.

- If you afraid of removing items in mistake, by setting "lock" true, you can make the delete button hidden.

- By entering the image file's name in image table into "thumbnail", you can show the image at the beggining of the description easily.

The unit of the size of item is a size obtained by dividing your window size horizontally into 12 parts, 

and displayed size of items change dynamically when you change the size of the window.

1/12 is used for the margin between items, thus the upper limit of size is 11.

## Customizing design
If you want to custom the design of PhoenixCMS in more detail,

you can edit css files in ```home_page_local/assets/css```.

Note: the changes of css file are not reflected while running in prod mode. So, after change them, run the phoenix server in dev mode once.

### In more detail
Please rewrite html.eex files in ```home_page_dev/lib/home_page_web/templates```.

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
  
After this, write your DB user name directly in dev.exs or prod.exs,please.
  
Finally,execute following codes to run the application.
```bash
export PORT=4000
MIX_ENV=prod<or dev> mix ecto.create
MIX_ENV=prod<or dev> mix ecto.migrate
MIX_ENV=prod<or dev> mix run priv/repo/seeds.exs
MIX_ENV=prod<or dev> mix phx.server
```
If you are running on the local server, go http://localhost:4000 and can see.
