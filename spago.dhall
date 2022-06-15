{ name = "lazy-joe"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "console"
  , "effect"
  , "functions"
  , "prelude"
  , "unsafe-coerce"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
