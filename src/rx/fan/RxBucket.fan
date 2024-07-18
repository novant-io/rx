//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxBucket
*************************************************************************

** RxBucket contains a list of RxRec records where ids
** are unique within the bucket.
@Js const class RxBucket
{
  ** Constructor.
  internal new make(Str name)
  {
    this.name = name
  }

  ** Name of this bucket.
  const Str name

  ** Convenience for `size == 0`
  Bool isEmpty() { recs.isEmpty }

  ** Return number of records in this bucket.
  Int size() { recs.size }

  // ** Metadata for this grid.
  // const Str:Obj? meta

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  RxRec? get(Int index)
  {
    recs[index]
  }

  ** Iterate each record in this bucket.
  Void each(|RxRec rec, Int index| f)
  {
    recs.each |r,i| { f(r,i) }
  }

  ** Update the given record id with a new version.
  internal Void update(Int id, RxRec rec)
  {
    ix := recs.findIndex |r| { r.id == id }
    recs[ix] = rec
  }

// TODO
  private const RxRec[] recs := [,]
}