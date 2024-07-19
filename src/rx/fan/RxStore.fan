//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxStore
*************************************************************************

**
** RxStore manages an immutable set of buckets that each contain
** a list of records.  To modify the contents of Store, create
** a RxWriter to apply a set of changes which produces a new
** Store instance.  No data from previous instances is modified
** so each Store can be used safely between threads.
**
@Js const class RxStore
{
  ** Create a new store and register given buckets.
  new make(Str:RxRec[] buckets := [:])
  {
    map := Str:ConstMap[:]
    buckets.each |recs, name|
    {
      // TODO: efficient way to pre-seed map?
      c := ConstMap()
      recs.each |r| { c = c.add(r.id, r) }
      map[name] = c
    }
    this.bmap = map.toImmutable
  }

  ** Internal ctor to create store from a writer commit log.
  internal new makeWriter(Str:ConstMap wmap)
  {
    this.bmap = wmap.toImmutable
  }

  ** Return registered buckets for this store.
  Str[] buckets() { bmap.keys }

  ** Get the number of records in given bucket.
  ** Throws 'ArgErr' if bucket not found.
  Int size(Str bucket)
  {
    b(bucket).size
  }

  ** Get record for given bucket and record id or 'null' if not found.
  RxRec? get(Str bucket, Int id)
  {
    b(bucket).get(id)
  }

  ** Get bucket or throw 'ArgErr' if not found.
  private ConstMap b(Str name)
  {
    bmap[name] ?: throw ArgErr("Bucket not found '${name}'")
  }

  internal const Str:ConstMap bmap   // map of bucket_name : rec_map
}



// TODO
/*
** RxStore manages a list of RxBuckets.
@Js const class RxStore
{
  // ** Regster a new bucket for this store.
  Void register(Str bucket)
  {
    // verify name
    if (bmap[bucket] != null)
      throw ArgErr("Bucket already exists '${bucket}'")

    bmap[bucket] = RxBucket(bucket)
  }

  ** Return registered buckets for this store.
  Str[] buckets() { bmap.keys(Str#) }

  ** Get record for given bucket and record id or 'null' if not found.
  RxRec? get(Str bucket, Int id)
  {
    RxBucket? b := bmap[bucket]
    if (b == null) return null
    return b.get(id)
  }

  ** Iterate the recs in given bucket and invoke callback
  ** for each record, or do nothing if bucket not found.
  Void each(Str bucket, |RxRec rec| f)
  {
    RxBucket? b := bmap[bucket]
    if (b == null) return
    b.each(f)
  }

  Void add(Str bucket, Str:Obj? fields)
  {
    // RxBucket? b := bmap[bucket]
    // if (b == null) throw ArgErr("Bucket not found '${bucket}")

    // // TODO: verify id != id
    // rec := RxRec(fields)
    // b.recs.add(rec)
  }

//////////////////////////////////////////////////////////////////////////
// Buckets
//////////////////////////////////////////////////////////////////////////

  // ** Get list of registered buckets for this store.
  // Str[] bucketNames() { bmap.keys(Str#) }

  // ** Get the bucket for 'name' or return 'null' if name not found.
  // RxBucket? bucket(Str name)
  // {
  //   bmap[name]
  // }

  // ** Create a new bucket for given name for this store.
  // RxBucket createBucket(Str name)
  // {
  //   // verify name not already used
  //   if (bmap[name] != null) throw ArgErr("Bucket alreadys for '${name}'")

  //   // create and register new bucket
  //   b := RxBucket(name)
  //   bmap[name] = b
  //   return b
  // }

  // ** Get a new writer instance to modify this store.
  // RxWriter makeWriter()
  // {
  //   RxWriter(this)
  // }

  // ** Regster a new grid for this store.
  // Void register(Str key, RxBucket bucket)
  // {
  //   // verify does not exists
  //   if (this.bucket(key) != null)
  //     throw ArgErr("Key already registered '${key}'")

  //   // store bucket and config key
  //   bmap[key] = bucket
  //   bucket.keyRef.val = key

  //   // store key hash
  //   keyHash := kmap.size + 1
  //   kmap[key] = keyHash

  //   // iterate and set guid for each key; note that in JS
  //   // sys::Int.shiftl only operates on the lower 32 bits;
  //   // so we need to mult and add operators to achive the
  //   // same result
  //   //
  //   //   high := keyHash.shiftl(32)
  //   //   guid := high.or(low)
  //   //
  //   high := keyHash * 2.pow(32)
  //   bucket.each |r|
  //   {
  //     low := r.id.and(0xffff_ffff)
  //     r.guidRef.val = high + low
  //   }
  // }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  // ** Get the bucket for given 'key' or null if not found.
  // RxBucket? bucket(Str key)
  // {
  //   bmap[key]
  // }

//////////////////////////////////////////////////////////////////////////
// Modify
//////////////////////////////////////////////////////////////////////////

  // ** Modify the given record.
  // Void modify(RxRec rec, Str:Obj? changes)
  // {
  //   verifyRecNs(rec)

  // }

  // ** Verify rec is within this bucket store namespace
  // private Void verifyRecNs(RxRec rec)
  // {
  //   // must have guid
  //   if (rec.guid == 0) throw ArgErr("Record not part of namespace")

  //   // verify bucket key hash
  //   keyHash := rec.guid / 2.pow(32)
  //   if (kmap[keyHash] == null) throw ArgErr("Record not part of namespace")

  //   // should be good
  // }

//////////////////////////////////////////////////////////////////////////
// Storage
//////////////////////////////////////////////////////////////////////////


// TODO -> go away???
  // private const ConcurrentMap kmap := ConcurrentMap()
  private const ConcurrentMap bmap := ConcurrentMap()
}
*/