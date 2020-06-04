defmodule OpenWeather do
  @appid Application.get_env(:slack_bot, :open_weather_api_key)

  @moduledoc """
  Documentation for OpenWeather.
  """

  @doc """
  Return weather by city.

  ## Examples

      iex> OpenWeather.weather('Osaka')

      {:ok,
       [
         weather: %{
           "description" => "scattered clouds",
           "icon" => "03n",
           "icon_url" => "http://openweathermap.org/img/wn/03n@2x.png",
           "id" => 802,
           "main" => "Clouds"
         }
       ]}
  """
  @spec weather(String.t()) :: tuple
  def weather(city) do
    result =
      case _weather(city) do
        {:ok, %{response: response}} ->
          {:ok, hd(response["weather"])}

        {:error, %{status_code: status_code, message: message}} ->
          {:error, %{status_code: status_code, message: message}}
      end

    if elem(result, 0) == :ok do
      weather = elem(result, 1)
      {:ok, Map.merge(weather, %{"icon_url" => icon_url(weather["icon"])})}
    else
      result
    end
  end

  @doc """
  Return weather icon url.

  Reference of OpenWeather: https://openweathermap.org/weather-conditions#Icon-list

  ## Examples

      iex > OpenWeather.url("02d")

      "http://openweathermap.org/img/wn/02d@2x.png"
  """
  @spec icon_url(String.t()) :: String.t()
  def icon_url(id), do: "http://openweathermap.org/img/wn/#{id}@2x.png"

  defp _weather(city) do
    url = "http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{@appid}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{response: Jason.decode!(body)}}

      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        {:error, %{status_code: 401, message: Jason.decode!(body)["message"]}}

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        {:error, %{status_code: 404, message: Jason.decode!(body)["message"]}}

      {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
        {:error, %{status_code: nil, message: reason}}
    end
  end
end
