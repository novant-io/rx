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

** RxRec models a record of name-value fields.
@Js const class RxRec
{
  // ** Tag values for this rec.
  // const Str:Obj tags

  ** Construct a new RxRec instance.
  new make(Str:Obj? map := [:])
  {
    this.map = map
    this.id  = map["id"] ?: throw ArgErr("Missing 'id' key")
    this.ver = 0

// TODO
    // // sanity checks
    // if (id  < 1 || id  > 0xffff_ffff) throw ArgErr("Id out of bounds: $id")
    // if (ver < 0 || ver > 0xffff_ffff) throw ArgErr("Version out of bounds: $ver")
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

  ** Version of this rec. Each modification to this rec
  ** inside a 'Bucket' will increment this value.
  internal const Int ver

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

  ** Merge the given changes with the current record and
  ** return a new instance.
  RxRec merge(Str:Obj? changes)
  {
    temp := map.dup
    changes.each |v,k|
    {
      // can never modify id
      if (k == "id") return
      if (v == null) temp.remove(k)
      else temp[k] = v
    }
    return RxRec(temp)
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
