//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using concurrent
using dx

*************************************************************************
** Rx
*************************************************************************

** Rx manages a 'Rx' runtime within a client instance.
@Js class Rx
{
  ** Init a new Rx runtime.
  new make(DxStore store)
  {
    this.store = store
  }

  ** Bucket keys for backing store of this Rx instance.
  Str[] buckets() { store.buckets }

  ** Get the current view for given bucket name.
  RxView view(Str bucket)
  {
    view := vmap[bucket]
    if (view == null)
    {
      if (!buckets.contains(bucket))
        throw ArgErr("Bucket not found '${bucket}'")
      vmap[bucket] = view = DefRxView(this, bucket)
    }
    return view
  }

  internal DxStore store          // backing store instance
  private Str:RxView vmap := [:]  // map of bucket:RxView
}