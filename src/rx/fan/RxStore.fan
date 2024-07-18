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

** RxStore manages the state of namespace of RxGrids.
@Js const class RxStore
{

//////////////////////////////////////////////////////////////////////////
// Registration
//////////////////////////////////////////////////////////////////////////

  ** Regster a new grid for this store.
  Void register(Str key, RxGrid grid)
  {
    // verify does not exists
    if (this.grid(key) != null)
      throw ArgErr("Key already registered '${key}'")

    // store grid and config key
    gmap[key] = grid
    grid.keyRef.val = key

    // store key hash
    keyHash := kmap.size + 1
    kmap[key] = keyHash

    // iterate and set guid for each key; note that in JS
    // sys::Int.shiftl only operates on the lower 32 bits;
    // so we need to mult and add operators to achive the
    // same result
    //
    //   high := keyHash.shiftl(32)
    //   guid := high.or(low)
    //
    high := keyHash * 2.pow(32)
    grid.each |r|
    {
      low := r.id.and(0xffff_ffff)
      r.guidRef.val = high + low
    }
  }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  ** Get the grid for given 'key' or null if not found.
  RxGrid? grid(Str key)
  {
    gmap[key]
  }

//////////////////////////////////////////////////////////////////////////
// Modify
//////////////////////////////////////////////////////////////////////////

  ** Modify the given record.
  Void modify(RxRec rec, Str:Obj? changes)
  {
    verifyRecNs(rec)

  }

  ** Verify rec is within this grid store namespace
  private Void verifyRecNs(RxRec rec)
  {
    // must have guid
    if (rec.guid == 0) throw ArgErr("Record not part of namespace")

    // verify grid key hash
    keyHash := rec.guid / 2.pow(32)
    if (kmap[keyHash] == null) throw ArgErr("Record not part of namespace")

    // should be good
  }

//////////////////////////////////////////////////////////////////////////
// Storage
//////////////////////////////////////////////////////////////////////////

  private const ConcurrentMap kmap := ConcurrentMap()
  private const ConcurrentMap gmap := ConcurrentMap()
}
