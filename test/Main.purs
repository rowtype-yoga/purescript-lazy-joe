module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)

import Effect.Class (liftEffect)
import Lazy.Joe (effectful, fromDefault, scoped, variadic)

main :: Effect Unit
main = launchAff_ do
  m@{ blue, underline, rgb, green } <- fromDefault "chalk"

  log $ variadic green "hello"
  log $ variadic green "hello" "world"
  log $ variadic green ["hello","world", "hallo", "welt", "hola", "mundo"]

  let
    --x :: Effect String
    x = effectful (variadic blue) "hello" "wurst"

    --    y :: Effect String
    y = effectful (variadic blue) "hello"

  liftEffect $ x >>= log
  liftEffect $ y >>= log
  -- log $ blue "blau"
  let
    x :: Effect String
    x = underline # \{ bold } -> bold # \{ green } -> effectful green "grün"
  str <- liftEffect x
  log str
  -- let
  --   c :: Effect String
  --   c = effectfulScoped3 m rgb 123 45 67 <#> \{ underline } -> underline "Underlined reddish color"
  log $ scoped m rgb 123 45 67 # \{ underline } -> underline "Underlined reddish color"

  let 
    c :: Effect String
    c = effectful (scoped m rgb) 123 45 67 <#> \{ underline } -> underline "Underlined reddish color"
  
  log "Effect not run"
  liftEffect c >>= log
  pure unit
