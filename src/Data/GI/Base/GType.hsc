-- | Basic `GType`s.
module Data.GI.Base.GType
    ( GType(..)
    , CGType

    , gtypeName

    , gtypeString
    , gtypePointer
    , gtypeInt
    , gtypeUInt
    , gtypeLong
    , gtypeULong
    , gtypeInt64
    , gtypeUInt64
    , gtypeFloat
    , gtypeDouble
    , gtypeBoolean
    , gtypeGType
    , gtypeStrv
    , gtypeBoxed
    , gtypeObject
    , gtypeVariant
    , gtypeByteArray
    , gtypeInvalid
    ) where

import Data.Word (Word64)
import Foreign.C.String (CString, peekCString)

#include <glib-object.h>

-- | A type identifier in the GLib type system. This is the low-level
-- type associated with the representation in memory, when using this
-- on the Haskell side use `GType` below.
type CGType = #type GType

-- | A newtype for use on the haskell side.
newtype GType = GType {gtypeToCGType :: CGType}

foreign import ccall "g_type_name" g_type_name :: GType -> IO CString

-- | Get the name assigned to the given `GType`.
gtypeName :: GType -> IO String
gtypeName gtype = g_type_name gtype >>= peekCString

{-| [Note: compile-time vs run-time GTypes]

Notice that there are two types of GType's: the fundamental ones,
which are created with G_TYPE_MAKE_FUNDAMENTAL(n) and always have the
same runtime representation, and the ones that are registered in the
GObject type system at runtime, and whose `CGType` may change for each
program run (and generally does).

For the first type it is safe to use hsc to read the numerical values
of the CGType at compile type, but for the second type it is essential
to call the corresponding _get_type() function at runtime, and not use
the value of the corresponding "constant" at compile time via hsc.
-}

{- Fundamental types -}

-- | `GType` of strings.
gtypeString :: GType
gtypeString = GType #const G_TYPE_STRING

-- | `GType` of pointers.
gtypePointer :: GType
gtypePointer = GType #const G_TYPE_POINTER

-- | `GType` for signed integers (`gint` or `gint32`).
gtypeInt :: GType
gtypeInt = GType #const G_TYPE_INT

-- | `GType` for unsigned integers (`guint` or `guint32`).
gtypeUInt :: GType
gtypeUInt = GType #const G_TYPE_UINT

-- | `GType` for `glong`.
gtypeLong :: GType
gtypeLong = GType #const G_TYPE_LONG

-- | `GType` for `gulong`.
gtypeULong :: GType
gtypeULong = GType #const G_TYPE_ULONG

-- | `GType` for signed 64 bit integers.
gtypeInt64 :: GType
gtypeInt64 = GType #const G_TYPE_INT64

-- | `GType` for unsigned 64 bit integers.
gtypeUInt64 :: GType
gtypeUInt64 = GType #const G_TYPE_UINT64

-- | `GType` for floating point values.
gtypeFloat :: GType
gtypeFloat = GType #const G_TYPE_FLOAT

-- | `GType` for gdouble.
gtypeDouble :: GType
gtypeDouble = GType #const G_TYPE_DOUBLE

-- | `GType` corresponding to gboolean.
gtypeBoolean :: GType
gtypeBoolean = GType #const G_TYPE_BOOLEAN

-- | `GType` corresponding to a `BoxedObject`.
gtypeBoxed :: GType
gtypeBoxed = GType #const G_TYPE_BOXED

-- | `GType` corresponding to a `GObject`.
gtypeObject :: GType
gtypeObject = GType #const G_TYPE_OBJECT

-- | An invalid `GType` used as error return value in some functions
-- which return a `GType`.
gtypeInvalid :: GType
gtypeInvalid = GType #const G_TYPE_INVALID

-- | The `GType` corresponding to a `GVariant`.
gtypeVariant :: GType
gtypeVariant = GType #const G_TYPE_VARIANT

{- Run-time types -}

foreign import ccall "g_gtype_get_type" g_gtype_get_type :: CGType

-- | `GType` corresponding to a `GType` itself.
gtypeGType :: GType
gtypeGType = GType g_gtype_get_type

foreign import ccall "g_strv_get_type" g_strv_get_type :: CGType

-- | `GType` for a NULL terminated array of strings.
gtypeStrv :: GType
gtypeStrv = GType g_strv_get_type

foreign import ccall "g_byte_array_get_type" g_byte_array_get_type :: CGType

-- | `GType` for a boxed type holding a `GByteArray`.
gtypeByteArray :: GType
gtypeByteArray = GType g_byte_array_get_type
