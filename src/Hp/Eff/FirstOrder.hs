{-# LANGUAGE UndecidableInstances #-}

-- | A newtype wrapper used to derive 'Effect' and 'HFunctor' for first-order
-- effects.
--
-- Used like so:
--
-- @
-- data MyEffect (m :: Type -> Type) (k :: Type) where ...
--   deriving (Effect, HFunctor) via (FirstOrderEffect MyEffect)
-- @

module Hp.Eff.FirstOrder
  ( FirstOrderEffect(..)
  ) where

import Control.Effect
import Control.Effect.Carrier


newtype FirstOrderEffect
          (sig :: (Type -> Type) -> Type -> Type)
          (m :: Type -> Type)
          (k :: Type)
  = FirstOrderEffect (sig m k)
  deriving stock Functor

instance
     ( forall m n a. (Coercible (sig m a) (sig n a))
     , forall m. Functor (sig m)
     )
  => HFunctor (FirstOrderEffect sig) where

  hmap _ =
    coerce

instance
     ( forall m n a. Coercible (sig m a) (sig n a)
     , forall m. Functor (sig m)
     )
  => Effect (FirstOrderEffect sig) where

  handle state handler =
    coerce . fmap (handler . (<$ state))
