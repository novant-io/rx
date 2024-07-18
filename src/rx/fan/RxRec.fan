//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxRec
*************************************************************************

** RxRec models a record.
@Js abstract const class RxRec
{
  ** The unique record id within the parent namespace, or
  ** if this record exists outside of a grid or an 'RxStore'
  ** namespace, then this value will be '0'.
  Int guid() { guidRef.val }
  internal const AtomicInt guidRef := AtomicInt()

  ** Convenience for 'rec->id' to get the unique ID
  ** for this record within the dataset.
  abstract Int id()

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  abstract Obj? get(Str key)

  ** Iterate the values and keys in this record.
  abstract Void each(|Obj? val, Str key| f)

  **
  ** Convenience for `get`:
  **
  **   foo := rec.get("foo")
  **   foo := rec->foo
  **
  override Obj? trap(Str name, Obj?[]? val := null)
  {
    if (val == null || val.size == 0) return get(name)
    return null
  }
}
