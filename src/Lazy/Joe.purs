module Lazy.Joe where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried (Fn1, Fn2, Fn3, mkFn2, mkFn3, runFn1, runFn2, runFn3)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Unsafe.Coerce (unsafeCoerce)

foreign import fromImpl :: forall mod. String -> Effect (Promise mod)

from :: forall mod m. MonadAff m => String -> m { | mod }
from = fromImpl >>> Promise.toAffE >>> liftAff

foreign import fromDefaultImpl :: forall mod. String -> Effect (Promise mod)

fromDefault :: forall mod m. MonadAff m => String -> m { | mod }
fromDefault = fromDefaultImpl >>> Promise.toAffE >>> liftAff

class Curried f output | output -> f where
  curried :: f -> output

instance Curried (Fn3 a b c d) (a -> b -> c -> d) where
  curried = runFn3
else instance Curried (Fn2 a b c) (a -> b -> c) where
  curried f = \a -> \b -> runFn2 f a b
else instance Curried (a -> b) (a -> b) where
  curried f = \a -> runFn1 f a

class Effectful f output | output -> f where
  effectful :: f -> output

foreign import effectful3 :: forall a b c d. Fn3 a b c d -> a -> b -> c -> Effect d

foreign import effectful2 :: forall a b c. Fn2 a b c -> a -> b -> Effect c

foreign import effectful1 :: forall a b. Fn1 a b -> a -> Effect b

instance Effectful (Fn3 a b c d) (a -> b -> c -> Effect d) where
  effectful f = \a -> \b -> \c -> effectful3 f a b c
else instance Effectful (Fn2 a b c) (a -> b -> Effect c) where
  effectful f = \a -> \b -> effectful2 f a b
else instance Effectful (Fn1 a b) (a -> Effect b) where
  effectful f = \a -> effectful1 f a

foreign import scoped3 :: forall mod a b c d. mod -> Fn3 a b c d -> a -> b -> c -> d

class Scoped f output | output -> f where
  scoped :: forall mod. mod -> f -> output

instance Scoped (Fn3 a b c d) (a -> b -> c -> d) where
  scoped m f = \a -> \b -> \c -> scoped3 m f a b c

instance Scoped (Fn3 a b c d) (Fn3 a b c d) where
  scoped m f = mkFn3 \a -> \b -> \c -> scoped3 m f a b c

foreign import variadicImpl :: forall output. (Varargs -> output) -> Varargs -> output

class Variadic f output | output -> f where
  variadic :: f -> output

foreign import data Varargs :: Type

foreign import varargs1 :: forall a. a -> Varargs
foreign import varargs2 :: forall a b. a -> b -> Varargs

instance Variadic (Varargs -> c) (a -> b -> c) where
  variadic f = \a -> \b -> variadicImpl f $ varargs2 a b
else instance Variadic (Varargs -> c) (Fn2 a b c) where
  variadic f = mkFn2 (\a -> \b -> variadicImpl f $ varargs2 a b)
else instance Variadic (Varargs -> b) (Array a -> b) where
  variadic f = \a -> variadicImpl f $ unsafeCoerce a
else instance Variadic (Varargs -> b) (a -> b) where
  variadic f = \a -> variadicImpl f $ varargs1 a



