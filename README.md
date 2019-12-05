# PhoenixCMS
Contents Management System made by elixir + phoenix

# Usage


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

- HOME_PAGE_GUARDIAN_KEY=<guardian_secret_key>

- SECRET_KEY_BASE=<secret_key_base>

- DATABASE_PASS=<your database password>

- DATABASE_HOSTNAME=<your database hostname>

- DATABASE_NAME=<your database name>
  
- HOME_PAGE_CONTENTS=<absolute path to home_page_local/priv/static/contents/>

- HOME_PAGE_STATIC=<absolute path to home_page_local/priv/static/>

- HOME_PAGE_UPLOADED=<absolute path to homepage_local/priv/static/images/uploaded/>

- HOME_PAGE_DIR=<absolute path to home_page_local/>

- HOME_PAGE_URL=http<or https>://www.<your domain name>

you make gmail account, and

- HOME_PAGE_MAIL_PASS=<your gmail account's password>

- HOME_PAGE_MAIL_USER_NAME=<your gmail address>
  
After this, write <your DB user name> directly in dev.exs or prod.exs,please.
  
Finally,execute following codes to run the application.
```bash
export PORT=4000
MIX_ENV=prod<or dev> mix ecto.create
MIX_ENV=prod<or dev> mix ecto.migrate
MIX_ENV=prod<or dev> mix run priv/repo/seeds.exs
MIX_ENV=prod<or dev> mix phx.server
```
If you are running on the local environment, go http://http://localhost:4000 and can see.
