{-# LANGUAGE DataKinds, FlexibleInstances, MultiParamTypeClasses,
  UndecidableInstances, KindSignatures, TypeFamilies #-}
#if !MIN_VERSION_base(4,8,0)
{-# LANGUAGE OverlappingInstances #-}
#endif

-- | `Constructible` types are those for which `new` is
-- defined. Often these are `GObject`s, but it is possible to
-- construct new (zero-initialized) structures and unions too.

module Data.GI.Base.Constructible
    ( Constructible(..)
    ) where

import Foreign (ForeignPtr)
import Control.Monad.IO.Class (MonadIO)

import Data.GI.Base.Attributes (AttrOp, AttrOpTag(..))
import Data.GI.Base.BasicTypes (GObject)
import Data.GI.Base.GObject (constructGObject)

-- | Constructible types, i.e. those which can be allocated by `new`.
class Constructible a (tag :: AttrOpTag) where
    new :: MonadIO m => (ForeignPtr a -> a) -> [AttrOp a tag] -> m a

-- | Default instance, assuming we have a `GObject`.
instance
#if MIN_VERSION_base(4,8,0)
    {-# OVERLAPPABLE #-}
#endif
    (GObject a, tag ~ 'AttrConstruct) => Constructible a tag where
        new = constructGObject
