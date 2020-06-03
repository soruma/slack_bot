defmodule OpenWeatherTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest OpenWeather

  setup_all do
    HTTPoison.start()
  end

  describe "weather/1" do
    test "Returns Osaka weather in json format" do
      use_cassette "openweather/osaka_weather" do
        {:ok, weather} = OpenWeather.weather("Osaka")

        target = %{
          "description" => "light rain",
          "icon" => "10n",
          "icon_url" => "http://openweathermap.org/img/wn/10n@2x.png",
          "id" => 500,
          "main" => "Rain"
        }

        assert weather == target
      end
    end

    test "Not found city" do
      use_cassette "openweather/not_found_city" do
        {:error, %{status_code: status_code, message: message}} =
          OpenWeather.weather("NotExistCity")

        assert status_code == 404
        assert message == "city not found"
      end
    end

    test "Invalid API key" do
      use_cassette "openweather/invalid_api_key" do
        Application.put_env(:open_weather, :api_key, "invalid_key")
        {:error, %{status_code: status_code, message: message}} = OpenWeather.weather("Osaka")
        assert status_code == 401
        assert message =~ ~r/Invalid API key/
      end
    end
  end

  describe "icon_url/1" do
    test "Return OpenWeather URL of icon" do
      assert OpenWeather.icon_url("cloud") == "http://openweathermap.org/img/wn/cloud@2x.png"
    end
  end
end
