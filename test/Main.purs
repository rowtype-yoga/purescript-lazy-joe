module Test.Main where

import Prelude

import Control.Promise as Promise
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (log, logShow)
import Lazy.Joe (effectful, fromDefault, new, scoped, uncurried, variadic)

main :: Effect Unit
main = launchAff_ do
  m@{ blue, underline, rgb, green, red } <- fromDefault "chalk"

  log $ red "Red velvet 🎂"
  log $ variadic green "hello"
  log $ variadic green "hello" "world"
  log $ variadic green [ "hello", "world", "hallo", "welt", "hola", "mundo" ]

  let
    x = effectful (variadic blue) "hello" "wurst"
    y = effectful (variadic blue) "hello"
  log "Effects not run"
  x >>= log
  y >>= log
  
  let
    underlined :: Aff String
    underlined = underline # \{ bold } -> bold # \{ green: g } -> effectful g "grün"
  underlined >>= log
  
  log $ scoped m rgb 123 45 67 # \{ underline: u } -> u "Underlined reddish color"

  let
    c :: Aff String
    c = effectful (scoped m rgb) 123 45 67 <#> \{ underline: u } -> u "Underlined reddish color"

  log "Effect not run"
  c >>= log

  { post } <- fromDefault "got"
  resp <- Promise.toAffE $ effectful (uncurried post) "https://httpbin.org/anything" { json: { hello: "🌎" } } >>= \{ json } -> json
  log resp.json

  fuse <- fromDefault "fuse.js"
  let
    list =
      [ { "title": "Old Man's War", "author": { "firstName": "John", "lastName": "Scalzi" } }
      , { "title": "The Lock Artist", "author": { "firstName": "Steve", "lastName": "Hamilton" } }
      ]
    options =
      { keys: [ "title", "author.firstName" ]
      }
  result :: Array { item :: { title :: String, author :: { firstName :: String, lastName :: String } } } <-
    (new fuse list options) # \f@{ search } -> effectful (scoped f search) "eve"

  logShow result
  pure unit
