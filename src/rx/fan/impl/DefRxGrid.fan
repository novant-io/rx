//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** DefRxGrid
*************************************************************************

** Default RxGrid implmentation.
@Js internal const class DefRxGrid : RxGrid
{
  ** Constructor.
  new make(Str:Obj? meta := [:], RxRec[] recs := RxRec#.emptyList)
  {
    this.meta = meta
    this.recs = recs
  }

  ** Convenience for `size == 0`
  override Bool isEmpty() { recs.isEmpty }

  ** Return number of records in this grid.
  override Int size() { recs.size }

  ** Metadata for this grid.
  override const Str:Obj? meta

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  override Obj? get(Int index)
  {
    recs[index]
  }

  ** Iterate each record in this grid.
  override Void each(|RxRec rec, Int index| f)
  {
    recs.each |r,i| { f(r,i) }
  }

  private const RxRec[] recs
}