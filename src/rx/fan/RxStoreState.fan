//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   18 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxStoreState
*************************************************************************

** RxStoreState models the current state of an RxStore.
@Js internal const class RxStoreState
{
  ** Create a new store state for given buckets.
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
    this.bmap = map
  }

  internal const Str:ConstMap bmap   // map of bucket_name : rec_map
}