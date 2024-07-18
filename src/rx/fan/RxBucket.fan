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

** RxBucket contains a list of RxRec records.
@Js const class RxBucket
{
  ** Constructor.
  new make(Str:Obj? meta := [:], RxRec[] recs := RxRec#.emptyList)
  {
    this.meta = meta
    this.recs = recs
  }

  ** The key name for this bucket in the parent 'RxStore' namespace,
  ** or 'null' if this grid does not exist in a namespace.
  Str? key() { keyRef.val }
  internal const AtomicRef keyRef := AtomicRef()

  ** Convenience for `size == 0`
  Bool isEmpty() { recs.isEmpty }

  ** Return number of records in this bucket.
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

  private const RxRec[] recs
}