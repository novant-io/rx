//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxGrid
*************************************************************************

** RxGrid models a grid of RxRec records.
@Js const class RxGrid
{
  ** Constructor.
  new make(Str:Obj? meta := [:], RxRec[] recs := RxRec#.emptyList)
  {
    this.meta = meta
    this.recs = recs
  }

  ** The key name for this grid in the parent 'RxStore' namespace,
  ** or 'null' if this grid does not exist in a namespace.
  Str? key() { keyRef.val }
  internal const AtomicRef keyRef := AtomicRef()

  ** Convenience for `size == 0`
  Bool isEmpty() { recs.isEmpty }

  ** Return number of records in this grid.
  Int size() { recs.size }

  ** Metadata for this grid.
  const Str:Obj? meta

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  RxRec? get(Int index)
  {
    recs[index]
  }

  ** Iterate each record in this grid.
  Void each(|RxRec rec, Int index| f)
  {
    recs.each |r,i| { f(r,i) }
  }

  private const RxRec[] recs
}