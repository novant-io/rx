//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxGridImpl
*************************************************************************

** Default RxGrid implmentation.
@Js internal const class RxGridImpl : RxGrid
{
  ** Constructor.
  new make(RxRec[] recs := RxRec#.emptyList)
  {
    this.recs = recs
  }

  ** Convenience for `size == 0`
  override Bool isEmpty() { recs.isEmpty }

  ** Return number of records in this grid.
  override Int size() { recs.size }

  // TODO
  // ** Metadata for this grid.
  // abstract Str:Obj? meta()

  ** Iterate each record in this grid.
  override Void eachRec(|RxRec rec, Int index| f)
  {
    recs.each |r,i| { f(r,i) }
  }

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  override Obj? get(Int index)
  {
    recs[index]
  }

  private const RxRec[] recs
}
