//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   10 Dec 2024  Andy Frank  Creation
//

using concurrent
using dx

*************************************************************************
** RxModel
*************************************************************************

** RxModel manages views on a backing 'DxStore' instance.
@Js class RxModel
{

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  ** Internal ctor.
  internal new make()
  {
    this.store = DxStore(0, [:])
  }

//////////////////////////////////////////////////////////////////////////
// Store
//////////////////////////////////////////////////////////////////////////

  ** Current store instance.
  DxStore store { private set }

  ** Has this model been loaded with data yet?
  Bool loaded := false { private set }

  ** Reload this instance with a new store.
  This reload(DxStore store)
  {
    this.store = store
    this.loaded = true
    vmap.each |v| { v.refresh }
    fireModifyAll
    return this
  }

  ** Bucket keys for backing store of this Rx instance.
  Str[] buckets() { store.buckets }

  ** Get the current view for given bucket name.  If bucket not
  ** found and 'checked' is true, then throws 'ArgErr', or if
  ** checked is false return an empty RxView instance.
  RxView view(Str bucket, Bool checked := true)
  {
    view := vmap[bucket]
    if (view == null)
    {
      if (!buckets.contains(bucket))
      {
        // NOTE: we do not cache the empty rx instance
        if (checked) throw ArgErr("Bucket not found '${bucket}'")
        return EmptyRxView.defVal
      }
      vmap[bucket] = view = DefRxView(this, bucket)
    }
    return view
  }

//////////////////////////////////////////////////////////////////////////
// Events
//////////////////////////////////////////////////////////////////////////

  ** Register a callback when the given bucket selection is
  ** modified. Use '"*"' to register callback when _any_
  ** bucket selection changes.
  Void onSelect(Str bucket, |RxEvent| f)
  {
    acc := cbSelect[bucket] ?: Func[,]
    acc.add(f)
    cbSelect[bucket] = acc
  }

  ** Register a callback when the given bucket is modified.
  ** Use '"*"' to register callback when _any_ bucket is
  ** modified.
  Void onModify(Str bucket, |RxEvent| f)
  {
    acc := cbModify[bucket] ?: Func[,]
    acc.add(f)
    cbModify[bucket] = acc
  }

  ** Fire 'onSelect' event on the given buckets.
  internal Void fireSelect(Str[] buckets)
  {
    event := RxEvent("select")
    fireEvent(buckets, event, cbSelect)
  }

  ** Fire 'onModify' event on the given buckets.
  internal Void fireModify(Str[] buckets)
  {
    event := RxEvent("modify")
    fireEvent(buckets, event, cbModify)
  }

  ** Fire 'onModify' on all buckets.
  internal Void fireModifyAll()
  {
    fireModify(store.buckets)
  }

  ** Fire event on given buckets and event handlers.
  private Void fireEvent(Str[] buckets, RxEvent event, Str:Func[] cb)
  {
    // fire explicit buckets first
    buckets.unique.each |b|
    {
      if (b == "*") return
      funcs := cb[b] ?: Func#.emptyList
      funcs.each |Func f| { f.call(event) }
    }

    // then check for * handlers
    funcs := cb["*"] ?: Func#.emptyList
    funcs.each |Func f| { f.call(event) }
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  private Str:RxView vmap := [:]      // map of bucket:RxView
  private Str:Func[] cbSelect := [:]  // map of bucket : event callbacks
  private Str:Func[] cbModify := [:]  // map of bucket : event callbacks
}