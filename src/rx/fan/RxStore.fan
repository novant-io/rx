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

** RxStore manages a list of RxBuckets.
@Js const class RxStore
{

//////////////////////////////////////////////////////////////////////////
// Buckets
//////////////////////////////////////////////////////////////////////////

  ** Get list of registered buckets for this store.
  Str[] bucketNames() { bmap.keys(Str#) }

  ** Get the bucket for 'name' or return 'null' if name not found.
  RxBucket? bucket(Str name)
  {
    bmap[name]
  }

  ** Create a new bucket for given name for this store.
  RxBucket createBucket(Str name)
  {
    // verify name not already used
    if (bmap[name] != null) throw ArgErr("Bucket alreadys for '${name}'")

    // create and register new bucket
    b := RxBucket(name)
    bmap[name] = b
    return b
  }

  ** Get a new writer instance to modify this store.
  RxWriter makeWriter()
  {
    RxWriter(this)
  }

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

  // private const ConcurrentMap kmap := ConcurrentMap()
  private const ConcurrentMap bmap := ConcurrentMap()
}
