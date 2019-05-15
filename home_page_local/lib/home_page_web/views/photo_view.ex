defmodule HomePageWeb.PhotoView do
  use HomePageWeb, :view
  alias HomePageWeb.PhotoView

  def render("index.json", %{photos: photos}) do
    %{data: render_many(photos, PhotoView, "photo.json")}
  end

  def render("show.json", %{photo: photo}) do
    %{data: render_one(photo, PhotoView, "photo.json")}
  end

  def render("photo.json", %{photo: photo}) do
    %{
      name: photo.name,
      image: photo.image
    }
  end
end
