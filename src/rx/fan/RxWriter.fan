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
    this.nextVer = store.version + 1
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

  ** Update an existing record for given bucket and record id.
  ** If record not found, this method throws 'ArgErr'.
  This update(Str bucket, Int id, Str:Obj? changes)
  {
    rec  := wmap[bucket].get(id) ?: throw ArgErr("Record not found '${id}'")
    diff := RxDiff.makeUpdate(bucket, id, changes)
    clog.add(diff)
    apply(diff)
    return this
  }

  ** Delete the a record from given bucket by record id.  If
  ** record was not found, this method does nothing.
  This delete(Str bucket, Int id)
  {
    // short-circuit if id not found
    rec := wmap[bucket].get(id)
    if (rec == null) return this

    // delete
    diff := RxDiff.makeDelete(bucket, id)
    clog.add(diff)
    apply(diff)
    return this
  }

  ** Commit the current changes and return a new RxStore.
  RxStore commit()
  {
    // TODO: we mark this writer as commited an no longer usable?
    return RxStore.makeWriter(nextVer, wmap)
  }

  ** Apply a list of diffs and update current store instance state.
  private Void apply(RxDiff diff)
  {
    switch (diff.op)
    {
      // add
      case 0:
        b := diff.bucket
        r := RxRec(diff.changes)
        wmap[b] = wmap[b].add(r.id, r)

      // update
      case 1:
        b := diff.bucket
        c := (RxRec)wmap[b].get(diff.id)
        u := c.merge(diff.changes)
        wmap[b] = wmap[b].set(diff.id, u)

      // delete
      case 2:
        b := diff.bucket
        wmap[b] = wmap[b].remove(diff.id)
    }
  }

  private Int nextVer               // version to apply on commit
  private RxDiff[] clog := [,]      // commit log
  private Str:ConstMap wmap := [:]  // map of bucket_name : working rec_map
}
