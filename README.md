# MarvelClient

**TODO: Add description**

## Installation

Steps:
Create a new elixir project using 
mix new marvel_client
Implementing Elixir executables  application
  - Create a module and implement the main/1
  - Update the mix.exs files with key as escript and value as [mainmodule: <<modulename>>]
  - After configuring our application and to use escript, execute below mix command:
    mix escript.build
  - Executable file is generated and invoked by calling:
    ./marvel_client 
Invoking a external API
  Preparation
    - create a account in https://developer.marvel.com
    - Get the API key to invoke the services
    - Launch the Interactive Documentation page and start fetching lists of characters using
      /v1/public/characters
    
    https://gateway.marvel.com:443/v1/public/characters?apikey=1a2p3i

    Authentication for Server-Side Applications:
    Server-side applications must pass two parameters in addition to the apikey parameter:
ts - a timestamp (or other long string which can change on a request-by-request basis)
hash - a md5 digest of the ts parameter, your private key and your public key (e.g. md5(ts+privateKey+publicKey)
For example, a user with a public key of "1234" and a private key of "abcd" could construct a valid call as follows: http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150 (the hash value is the md5 digest of 1abcd1234)

How to create hash key in Elixir
  Things to pay attention
    - hash algorithm md5
    - hash keys in lower case
    - values contains hexadecimal values
    - hash data creation order defined (ts+privateKey+publicKey)
        ts - timestamp 
API used to generate hash keys:
    :crypto.hash
    :crypto.hash(:md5,"ts+privatekey+publickey") |> Base.encode16([case: :lower]) 
https://gateway.marvel.com:443/v1/public/characters?name=Captain%20America&apikey=e6c4804cd5bbedf4da66024c84e72725

http://gateway.marvel.com/v1/public/comics?ts=1234&apikey=e6c4804cd5bbedf4da66024c84e72725&hash=6311aed3710a534a6b1d356ff9e1186b