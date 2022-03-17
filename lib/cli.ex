defmodule MarvelClient.Cli do

  def main(args \\ []) do
    IO.puts("Hello World")
  end

  def marvelapi_url(character_name) do
    public_key = System.get_env("MARVEL_API_PUBLIC_KEY")
    timestamp  = :os.system_time(:millisecond)
    private_key = System.get_env("MARVEL_API_PRIVATE_KEY")
    hashkey = :crypto.hash(:md5,"#{timestamp}#{private_key}#{public_key}") |> Base.encode16([case: :lower])
    URI.encode("https://gateway.marvel.com:443/v1/public/characters?name=#{character_name}&apikey=#{public_key}&ts=#{timestamp}&hash=#{hashkey}")
  end

  def call_api(character_name) do
   character_name
   |> marvelapi_url()
   |> HTTPoison.get!()
   |> response_body_json()
   |> get_description()
  end

  def response_body_json(response) do
    response.body |> JSON.decode!
  end

  def get_description(body) do
    body |> Map.get("data") |> Map.get("results") |> List.first |> Map.get("description")
  end

end
