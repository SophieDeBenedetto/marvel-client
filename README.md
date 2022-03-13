Let's start with building Elixir Executable(CLI) and invoke Marvel Superhero APIs.The CLI will process the data, generate the results, and then stops.By the end of this iteration, you'll know how to do the following:

* Create a basic Elixir execuable using escript
* Calling the Marvel API from Elixir


## Create a Basic Elixir Executable

Simple elixir project creation

```elixir
mix new marvel_client
```

## Create a Cli module with main function

New file called cli.ex created inside the lib folder.The MarvelClient.Cli module must contain a main/1 function. Sample code below:

```elixir
defmodule MarvelClient.Cli do
  
  def main(args \\ []) do
    IO.puts("Hello World")
  end
  
end
```

## Updating mix.exs to support escript

Head over to mix.exs, and modify project/0.
Add an entry called escript and which should return a keyword list of configuration settings.The main_module must be set to the name of a module containing a main function.In this case, it is MarvelClient.Cli.

```elixir
defmodule MarvelClient.MixProject do
  use Mix.Project

  def project do
    [
      .............
      deps: deps(),
      escript: escript()
    ]
  end

  defp escript() do
    [
      main_module: MarvelClient.Cli
    ]
  end
```

## Packaging executable

The mix escript.build will generate the app which can run locally that has Erlang installed.

```elixir
mix escript.build
```

## Executing marvel_client executable

Execute the marvel_client executable as below

```elixir
marvel_client % ./marvel_client 
Hello World
```

We have completed a simple Elixir executable app.

## Invoking APIs in Marvel site 

### Getting access to Marvel Superhero site

Join [Marvel site](https://www.marvel.com/) to create a new account or use the existing account.This will provide access to your own public and private keys to work with APIs.

* [My Developer Account](https://developer.marvel.com/account) fetch your public key and private key.
* [Interactive Documentation](https://developer.marvel.com/docs) provides the details about the exposed APIs
* [Authorizing and Signing requests](https://developer.marvel.com/documentation/authorization) details about accessing the APIs

### Server-side authentication

Our plan is to call the API from iex and fetch the character details. Since the call is triggered from iex, we are exploring the [Authentication for Server-Side Applications](https://developer.marvel.com/documentation/authorization)

```
GET /v1/public/characters Fetches lists of characters.
```
Sample Request URL

```
https://gateway.marvel.com:443/v1/public/characters?name=Captain%20America&apikey=1234asfaaasdf254234edf4da66
```

Server-side applications must pass two parameters in addition to the apikey parameter:
* ts - a timestamp (or other long string which can change on a request-by-request basis)
* hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)


For example, 
  * a user with a **public key of <span style="color:red">"1234"</span>** 
  * a **private key of <span style="color:yellow">"abcd"</span>**
  * ts - a timestamp <span style="color:green">1</span>
could construct a valid call as follows
http://gateway.marvel.com/v1/public/comics?ts=<span style="color:green">1</span>&apikey=<span style="color:red">1234</span>&hash=ffd275c5130566a2916217b101f26150 
*(the hash value is the md5 digest of <span style="color:green">1</span><span style="color:yellow">abcd</span><span style="color:red">1234</span>)*

#### Creating hash keys using Elixir
* Hash algorithm to be used "md5"
* Sample hash key values and interpretation
* Template recommended:  md5(ts+privateKey+publicKey)

```elixir
iex(1)> :crypto.hash(:md5, "1abcd1234") |> Base.encode16([case: :lower])
"ffd275c5130566a2916217b101f26150"
```

For invoking the api, create using your public and private keys.Generate hashkey using that.

### Make a HTTP request to Marvel API from iex

Installing the dependencies

Update mix.exs with httpoision dependency to support Http.

```elixir
defp deps do
    [ {:httpoison, "~> 1.8"} ]
end
```

Install the dependencies

```elixir
mix deps.get
```

Next Step is forming the url and invoking from iex:

```
HTTPoison.get! "https://gateway.marvel.com:443/v1/public/characters?name=Captain%20America&apikey=1234&ts=1&hash=ffd275c5130566a2916217b101f26150"
```
This is sample url. Create the url using your own public, private and hash key.

### Setting API keys are environment variables

### URL encoding

