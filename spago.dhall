{ name = "lazy-joe"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "effect"
  , "functions"
  , "prelude"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT-0"
, repository = "https://github.com/sigma-andex/purescript-lazy-joe.git"
}
