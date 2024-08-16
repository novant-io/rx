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

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////
// Store
//////////////////////////////////////////////////////////////////////////

  ** Current store instance.
  DxStore store { private set }

  ** Reload this instance with a new store.
  This reload(DxStore store)
  {
    // TODO FIXIT: fire modify on old/new buckets
    this.store = store
    // TODO FIXIT: yikes
    fireModify(["*"])
    return this
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

//////////////////////////////////////////////////////////////////////////
// Events
//////////////////////////////////////////////////////////////////////////

  ** Register a callback when the given bucket is modified.
  ** Use '"*"' to register callback when _any_ bucket is
  ** modified.
  Void onModify(Str bucket, |RxEvent| f)
  {
    acc := cbModify[bucket] ?: Func[,]
    acc.add(f)
    cbModify[bucket] = acc
  }

  ** Fire 'onModify' event on the given buckets.
  private Void fireModify(Str[] buckets)
  {
    buckets.each |b|
    {
      event := RxEvent()
      funcs := cbModify[b] ?: Func#.emptyList
      funcs.each |Func f| { f.call(event) }
    }
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  // session instance
  private static const AtomicRef curRef := AtomicRef()

  private Str:RxView vmap := [:]      // map of bucket:RxView
  private Str:Func[] cbModify := [:]  // map of bucket : event callbacks
}