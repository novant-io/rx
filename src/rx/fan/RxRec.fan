//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxRec
*************************************************************************

** RxRec models a record.
@Js const mixin RxRec
{
  ** Iterate the keys in this record.
  abstract Void eachKey(|Str key, Int index| f)

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  abstract Obj? get(Str key)

  // TODO
  // ** Set given `key` to `value`.
  // @Operator
  // abstract Void set(Str key, Obj? val)

  **
  ** Convenience for `get`:
  **
  **   foo := rec.get("foo")
  **   foo := rec->foo
  **
  override Obj? trap(Str name, Obj?[]? val := null)
  {
    if (val == null || val.size == 0) return get(name)
    // TODO
    // else { set(name, val.first); return null }
    return null
  }
}
