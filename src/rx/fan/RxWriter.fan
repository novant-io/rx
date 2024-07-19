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
  ** Constructor.
  new make(RxStore store)
  {
    // create working copy of buckets
    store.bmap.each |v,k| { wmap[k] = v }
  }

  ** Add a new record to given bucket, where the 'map' must
  ** contain an integer 'id' field that is unique within
  ** the given bucket.
  This add(Str bucket, Str:Obj? map)
  {
    diff := RxDiff.makeAdd(bucket, map)
    clog.add(diff)
    apply(diff)
    return this
  }

  ** Commit the current changes and return a new RxStore.
  RxStore commit()
  {
    // TODO: we mark this writer as commited an no longer usable?
    return RxStore.makeWriter(wmap)
  }

  ** Apply a list of diffs and update current store instance state.
  private Void apply(RxDiff diff)
  {
    switch (diff.op)
    {
      case 0:
       b := diff.bucket
       r := RxRec(diff.mod)
       wmap[b] = wmap[b].add(r.id, r)
    }
  }

  private RxDiff[] clog := [,]      // commit log
  private Str:ConstMap wmap := [:]  // map of bucket_name : working rec_map
}
