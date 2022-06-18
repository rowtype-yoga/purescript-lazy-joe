module Lazy.Joe
  ( Varargs
  , class Effectful
  , effectful
  , class New
  , new
  , class Scoped
  , scoped
  , class Curried
  , curried
  , class Variadic
  , variadic
  , from
  , fromDefault
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried (Fn0, Fn1, Fn2, Fn3, Fn4, Fn5, mkFn1, mkFn2, mkFn3, mkFn4, mkFn5, runFn1, runFn2, runFn3, runFn4, runFn5)
import Effect (Effect)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Unsafe.Coerce (unsafeCoerce)

foreign import fromImpl :: forall mod. String -> Effect (Promise mod)

-- | Import a module
from :: forall mod m. MonadAff m => String -> m { | mod }
from = fromImpl >>> Promise.toAffE >>> liftAff

foreign import fromDefaultImpl :: forall mod. String -> Effect (Promise mod)

-- | Import a module with a `default` export
fromDefault :: forall mod m. MonadAff m => String -> m mod
fromDefault = fromDefaultImpl >>> Promise.toAffE >>> liftAff

class Curried f output | output -> f where
  curried :: f -> output

instance Curried (Fn5 a b c d e f) (a -> b -> c -> d -> e -> f) where
  curried = runFn5

else instance Curried (Fn5 a b c d e f) (Fn5 a b c d e f) where
  curried = identity

else instance Curried (Fn4 a b c d e) (a -> b -> c -> d -> e) where
  curried = runFn4

else instance Curried (Fn4 a b c d e) (Fn4 a b c d e) where
  curried = identity

else instance Curried (Fn3 a b c d) (a -> b -> c -> d) where
  curried = runFn3

else instance Curried (Fn3 a b c d) (Fn3 a b c d) where
  curried = identity

else instance Curried (Fn2 a b c) (a -> b -> c) where
  curried = runFn2

else instance Curried (Fn2 a b c) (Fn2 a b c) where
  curried = identity

else instance Curried (Fn1 a b) (Fn1 a b) where
  curried = identity

else instance Curried (Fn1 a b) (a -> b) where
  curried = runFn1


foreign import new0 :: forall a. Fn0 a -> a

foreign import new1 :: forall a b. Fn1 a b -> a -> b

foreign import new2 :: forall a b c. Fn2 a b c -> a -> b -> c

foreign import new3 :: forall a b c d. Fn3 a b c d -> a -> b -> c -> d

foreign import new4 :: forall a b c d e. Fn4 a b c d e -> a -> b -> c -> d -> e

foreign import new5 :: forall a b c d e f. Fn5 a b c d e f -> a -> b -> c -> d -> e -> f

class New f output | output -> f where
  new :: f -> output

instance New (Fn5 a b c d e f) (a -> b -> c -> d -> e -> f) where
  new f = \a -> \b -> \c -> \d -> \e -> new5 f a b c d e

else instance New (Fn4 a b c d e) (a -> b -> c -> d -> e) where
  new f = \a -> \b -> \c -> \d -> new4 f a b c d

else instance New (Fn3 a b c d) (a -> b -> c -> d) where
  new f = \a -> \b -> \c -> new3 f a b c

else instance New (Fn2 a b c) (a -> b -> c) where
  new f = \a -> \b -> new2 f a b

else instance New (Fn1 a b) (a -> b) where
  new f = \a -> new1 f a
  
else instance New (Fn0 a) (a) where
  new f = new0 f

class Effectful f output | output -> f where
  effectful :: f -> output

foreign import effectful5 :: forall a b c d e f. Fn5 a b c d e f -> a -> b -> c -> d -> e -> Effect f

foreign import effectful4 :: forall a b c d e. Fn4 a b c d e -> a -> b -> c -> d -> Effect e

foreign import effectful3 :: forall a b c d. Fn3 a b c d -> a -> b -> c -> Effect d

foreign import effectful2 :: forall a b c. Fn2 a b c -> a -> b -> Effect c

foreign import effectful1 :: forall a b. Fn1 a b -> a -> Effect b

instance MonadEffect eff => Effectful (Fn5 a b c d e f) (Fn5 a b c d e (eff f)) where
  effectful f = mkFn5 (\a -> \b -> \c -> \d -> \e -> effectful5 f a b c d e # liftEffect)

else instance MonadEffect eff => Effectful (Fn5 a b c d e f) (a -> b -> c -> d -> e -> eff f) where
  effectful f = \a -> \b -> \c -> \d -> \e -> effectful5 f a b c d e # liftEffect

else instance MonadEffect eff => Effectful (Fn4 a b c d e) (Fn4 a b c d (eff e)) where
  effectful f = mkFn4 (\a -> \b -> \c -> \d -> effectful4 f a b c d # liftEffect)

else instance MonadEffect eff => Effectful (Fn4 a b c d e) (a -> b -> c -> d -> eff e) where
  effectful f = \a -> \b -> \c -> \d -> effectful4 f a b c d # liftEffect

else instance MonadEffect eff => Effectful (Fn3 a b c d) (Fn3 a b c (eff d)) where
  effectful f = mkFn3 (\a -> \b -> \c -> effectful3 f a b c # liftEffect)

else instance MonadEffect eff => Effectful (Fn3 a b c d) (a -> b -> c -> eff d) where
  effectful f = \a -> \b -> \c -> effectful3 f a b c # liftEffect

else instance MonadEffect eff => Effectful (Fn2 a b c) (Fn2 a b (eff c)) where
  effectful f = mkFn2 (\a -> \b -> effectful2 f a b # liftEffect)

else instance MonadEffect eff => Effectful (Fn2 a b c) (a -> b -> eff c) where
  effectful f = \a -> \b -> effectful2 f a b # liftEffect

else instance MonadEffect eff => Effectful (Fn1 a b) (Fn1 a (eff b)) where
  effectful f = mkFn1 (\a -> effectful1 f a # liftEffect)

else instance MonadEffect eff => Effectful (Fn1 a b) (a -> eff b) where
  effectful f = \a -> effectful1 f a # liftEffect

foreign import scoped1 :: forall mod a b. mod -> Fn1 a b -> a -> b

foreign import scoped2 :: forall mod a b c. mod -> Fn2 a b c -> a -> b -> c

foreign import scoped3 :: forall mod a b c d. mod -> Fn3 a b c d -> a -> b -> c -> d

foreign import scoped4 :: forall mod a b c d e. mod -> Fn4 a b c d e -> a -> b -> c -> d -> e

foreign import scoped5 :: forall mod a b c d e f. mod -> Fn5 a b c d e f -> a -> b -> c -> d -> e -> f

class Scoped f output | output -> f where
  scoped :: forall mod. mod -> f -> output

instance Scoped (Fn5 a b c d e f) (Fn5 a b c d e f) where
  scoped m f = mkFn5 \a -> \b -> \c -> \d -> \e -> scoped5 m f a b c d e

else instance Scoped (Fn5 a b c d e f) (a -> b -> c -> d -> e -> f) where
  scoped m f = \a -> \b -> \c -> \d -> \e -> scoped5 m f a b c d e

else instance Scoped (Fn4 a b c d e) (Fn4 a b c d e) where
  scoped m f = mkFn4 \a -> \b -> \c -> \d -> scoped4 m f a b c d

else instance Scoped (Fn4 a b c d e) (a -> b -> c -> d -> e) where
  scoped m f = \a -> \b -> \c -> \d -> scoped4 m f a b c d

else instance Scoped (Fn3 a b c d) (Fn3 a b c d) where
  scoped m f = mkFn3 \a -> \b -> \c -> scoped3 m f a b c

else instance Scoped (Fn3 a b c d) (a -> b -> c -> d) where
  scoped m f = \a -> \b -> \c -> scoped3 m f a b c

else instance Scoped (Fn2 a b c) (Fn2 a b c) where
  scoped m f = mkFn2 (\a -> \b -> scoped2 m f a b)

else instance Scoped (Fn2 a b c) (a -> b -> c) where
  scoped m f = \a -> \b -> scoped2 m f a b

else instance Scoped (Fn1 a b) (Fn1 a b) where
  scoped m f = \a -> scoped1 m f a
  
else instance Scoped (Fn1 a b) (a -> b) where
  scoped m f = mkFn1 (\a -> scoped1 m f a)


foreign import variadicImpl :: forall output. (Varargs -> output) -> Varargs -> output

class Variadic f output | output -> f where
  variadic :: f -> output

foreign import data Varargs :: Type

foreign import varargs1 :: forall a. a -> Varargs

foreign import varargs2 :: forall a b. a -> b -> Varargs

foreign import varargs3 :: forall a b c. a -> b -> c -> Varargs

foreign import varargs4 :: forall a b c d. a -> b -> c -> d -> Varargs

foreign import varargs5 :: forall a b c d e. a -> b -> c -> d -> e -> Varargs

instance Variadic (Varargs -> f) (Fn5 a b c d e f) where
  variadic f = mkFn5 (\a -> \b -> \c -> \d -> \e -> variadicImpl f $ varargs5 a b c d e)

else instance Variadic (Varargs -> f) (a -> b -> c -> d -> e -> f) where
  variadic f = \a -> \b -> \c -> \d -> \e -> variadicImpl f $ varargs5 a b c d e

else instance Variadic (Varargs -> e) (Fn4 a b c d e) where
  variadic f = mkFn4 (\a -> \b -> \c -> \d -> variadicImpl f $ varargs4 a b c d)

else instance Variadic (Varargs -> e) (a -> b -> c -> d -> e) where
  variadic f = \a -> \b -> \c -> \d -> variadicImpl f $ varargs4 a b c d

else instance Variadic (Varargs -> d) (Fn3 a b c d) where
  variadic f = mkFn3 (\a -> \b -> \c -> variadicImpl f $ varargs3 a b c)

else instance Variadic (Varargs -> d) (a -> b -> c -> d) where
  variadic f = \a -> \b -> \c -> variadicImpl f $ varargs3 a b c

else instance Variadic (Varargs -> c) (Fn2 a b c) where
  variadic f = mkFn2 (\a -> \b -> variadicImpl f $ varargs2 a b)

else instance Variadic (Varargs -> c) (a -> b -> c) where
  variadic f = \a -> \b -> variadicImpl f $ varargs2 a b

else instance Variadic (Varargs -> b) (Array a -> b) where
  variadic f = \a -> variadicImpl f $ unsafeCoerce a

else instance Variadic (Varargs -> b) (Fn1 a b) where
  variadic f = mkFn1 (\a -> variadicImpl f $ varargs1 a)

else instance Variadic (Varargs -> b) (a -> b) where
  variadic f = \a -> variadicImpl f $ varargs1 a

