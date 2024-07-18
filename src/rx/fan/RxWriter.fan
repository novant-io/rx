//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxWriter
*************************************************************************

** RxWriter manages mutations to RxRecs.
@Js class RxWriter
{
  ** Internal ctor.
  internal new make(RxStore store)
  {
    this.store = store
  }

  ** Add a new record to this bucket, where the 'map' must
  ** contain an integer 'id' field.
  This addRec(Str bucket, Str:Obj? map)
  {
    diffs.add(RxDiff.makeAdd(map))
    return this
  }

  ** Commit all pending changes to store.
  Void commit()
  {
    // short-circuit if already committed
    if (committed) return

    // TODO
  }

  private RxStore store
  private Bool committed := false
  private RxDiff[] diffs := [,]
}
