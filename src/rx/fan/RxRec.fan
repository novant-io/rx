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
