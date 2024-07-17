//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** DefRxRec
*************************************************************************

** Default RxRec implmentation.
@Js internal const class DefRxRec : RxRec
{
  ** Constructor.
  new make(Str:Obj? map := [:])
  {
    this.map = map
    this.id  = map["id"] ?: throw ArgErr("Missing 'id' key")

    // // TODO FIXIT
    // this.guid = 0
  }

  // ** Unique ID for this record within the grid namespace.
  // override const Int guid

  ** Unique ID for this record within the dataset.
  override const Int id

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  override Obj? get(Str key)
  {
    map[key]
  }

  ** Iterate the keys in this record.
  override Void each(|Obj? val, Str key| f)
  {
    map.each |v,k| { f(v,k) }
  }

  private const Str:Obj? map
}
