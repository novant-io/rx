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
@Js const class RxRec
{
  ** Construct a new RxRec instance.
  new make(Str:Obj? map := [:])
  {
    this.map = map
    this.id  = map["id"] ?: throw ArgErr("Missing 'id' key")
  }

  **
  ** The unique record id within the parent namespace, or
  ** if this record exists outside of a grid or an 'RxStore'
  ** namespace, then this value will be '0'.
  **
  ** Note this ID is not durable between store and grid
  ** instantiations and should not be used for long term
  ** references.
  **
  Int guid() { guidRef.val }
  internal const AtomicInt guidRef := AtomicInt()

  ** Convenience for 'rec->id' to get the unique ID
  ** for this record within the dataset.
  const Int id

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  Obj? get(Str key)
  {
    map[key]
  }

  ** Iterate the values and keys in this record.
  Void each(|Obj? val, Str key| f)
  {
    map.each |v,k| { f(v,k) }
  }

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

  private const Str:Obj? map
}
