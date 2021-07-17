defmodule Backend.ViaCEP do
  use Tesla, only: [:get]

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws/"
  plug Tesla.Middleware.JSON, engine_opts: [keys: :atoms]
  plug Tesla.Middleware.PathParams

  def address(postal_code) do
    params = [postal_code: postal_code]
    get("/:postal_code/json", opts: [path_params: params])
  end

  def postal_code(state, city, street) do
    params = [state: state, city: URI.encode(city), street: URI.encode(street)]

    get(":state/:city/:street/json/", opts: [path_params: params])
  end
end
