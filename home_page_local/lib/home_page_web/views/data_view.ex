defmodule HomePageWeb.DataView do
  use HomePageWeb, :view
  use Timex

  def date_to_string(date) do
    timezone = Timezone.get("Asia/Tokyo", Timex.now)
    date
    |> Timezone.convert(timezone)
    |> DateTime.to_string
    |> String.split("+")
    |> hd
  end

  def data_format(data) do
    format =
      data.name
      |> String.split(".")
      |> List.last
    case format do
      "png" -> "image"
      "jpg" -> "image"
      "jpeg" -> "image"
      "pdf" -> "pdf"
      "zip" -> "archive"
      "tar" -> "archive"
      _ -> "unknown"
    end
  end
end
