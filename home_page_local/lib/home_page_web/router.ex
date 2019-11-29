defmodule HomePageWeb.Router do
  use HomePageWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :auth do
    plug(HomePage.Accounts.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :ensure_not_auth do
    plug(Guardian.Plug.EnsureNotAuthenticated)
  end


  scope "/", HomePageWeb do
    # 全ページでユーザの判別
    pipe_through([:browser, :auth])
    get("/", TopController, :index)
    #get("/:category", TopController, :show)
    get("/index/:url", CategoryController, :show)
    get("/preview/:url", CategoryController, :preview)
    #get("/preview", TopController, :preview)
    #get("/delete_blank/:position", TopController, :delete_blank)
    #get("/signin", UserController, :new)
    post("/signin", UserController, :create)
    delete("/logout", SessionController, :delete)
    #get("/items/index", ComponentItemController, :index)
    #get("/items/:id", ComponentItemController, :show)
  end

  scope "/", HomePageWeb do
    # ログインしていない場合のみ閲覧可能
    pipe_through([:browser, :auth, :ensure_not_auth])
    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    get("/forget", SessionController, :forget)#パスワード再発行
    post("/send", SessionController, :send)#パスワード再発行
    get("/password_reset/:token", UserController, :reset_edit)#パスワード再発行
    put("/password_reset/:id", UserController, :reset_update)#パスワード再発行
    patch("/password_reset/:id", UserController, :reset_update)#パスワード再発行
  end

  scope "/", HomePageWeb do
    # ログイン済みの場合のみ閲覧可能
    pipe_through([:browser, :auth, :ensure_auth])
    get("/after_create", ComponentItemController, :after_create_update)
    patch("/after_create", ComponentItemController, :after_create_update)
    get("/after_delete", ComponentItemController, :after_delete_update)
    patch("/after_delete", ComponentItemController, :after_delete_update)
    resources("/users", UserController, except: [:new, :create, :delete])
    get("/users/:id/email_edit", UserController, :email_edit)
    get("/users/:id/pass_edit", UserController, :password_edit)
    put("/users/:id/email_edit", UserController, :email_update)
    put("/users/:id/pass_edit", UserController, :password_update)
    patch("/users/:id/email_edit", UserController, :email_update)
    patch("/users/:id/pass_edit", UserController, :password_update)
    resources("/items", ComponentItemController, except: [:index, :show])
    resources("/images", PhotoController, except: [ :edit, :update])
    resources("/category", CategoryController, except: [:show])
    get("/category/after_create", CategoryController, :solve_dupl_update)
    patch("/category/after_create", CategoryController, :solve_dupl_update)
    get("/category/after_delete_1", CategoryController, :solve_blank_update)
    patch("/category/after_delete_1", CategoryController, :solve_blank_update)
    get("/category/after_delete_2", ComponentItemController, :after_category_delete_update)
    patch("/category/after_delete_2", ComponentItemController, :after_category_delete_update)
    resources("/tmp", DataController, except: [:edit, :update])
    get("/tmp", DataController, :download)
  end
end
