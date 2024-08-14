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
  ** Get the Rx instance for this browser session.
  static Rx cur()
  {
    if (curRef.val == null) curRef.val = Unsafe(Rx.make)
    return curRef.val->val
  }

  ** Private ctor.
  private new make()
  {
    this.store = DxStore(0, [:])
  }

  ** Reload this instance with a new store.
  Void reload(DxStore store)
  {
    // TODO FIXIT: fire modify on old/new buckets
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

  // session instance
  private static const AtomicRef curRef := AtomicRef()

  internal DxStore store          // backing store instance
  private Str:RxView vmap := [:]  // map of bucket:RxView
}