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

  ** Force refresh all views.
  This refresh()
  {
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
        // first fire onView to see if bucket created
        fireView(bucket)

        // NOTE: we do not cache the empty rx instance
        if (checked) throw ArgErr("Bucket not found '${bucket}'")
        return EmptyRxView.defVal
      }
      vmap[bucket] = view = DefRxView(this, bucket)
    }
    return view
  }

  **
  ** Create a new virtual view that is not backed by the underlying
  ** `DxStore`. Virtual views can be used to expose computed or
  ** transient records alongside store-backed data. They behave like
  ** normal views for selection and modification events, but their
  ** content is managed entirely by the caller.
  **
  ** Throws 'Err' if view already exists for this name.
  **
  RxView addVirtualView(Str bucket, DxRec[] recs)
  {
    // sanity check
    if (vmap.containsKey(bucket)) throw ArgErr("View already exists: $bucket")

    // // create view
    view := VirtRxView(this, bucket, recs)
    vmap[bucket] = view
    view.refresh
    return view
  }

  ** Replace the contents of an existing virtual view with a new one.
  ** The previous view instance is discarded and the given `bucket`
  ** is reinitialized with the new data.  If no view already exists,
  ** a new view is added.
  RxView replaceVirtualView(Str bucket, DxRec[] recs)
  {
    // sanity check we can only remove virtual views
    view := vmap.remove(bucket)
    if (view != null)
    {
      if (view is VirtRxView) vmap.remove(bucket)
      else throw ArgErr("Cannot replace a non-virtual view: $bucket")
    }

    // add new view
    return addVirtualView(bucket, recs)
  }

//////////////////////////////////////////////////////////////////////////
// Events
//////////////////////////////////////////////////////////////////////////

  ** Register a callback when the given bucket is requested
  ** from `view` but does not yet exist, which can be used
  ** to create views on-demand.
  Void onView(|RxEvent| f) { cbView = f }

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

  ** Fire 'onView' event for given bucket.
  private Void fireView(Str bucket)
  {
    event := RxEvent("view") { it.bucket=bucket }
    cbView?.call(event)
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
  private Func? cbView                // on_view callback
  private Str:Func[] cbSelect := [:]  // map of bucket : event callbacks
  private Str:Func[] cbModify := [:]  // map of bucket : event callbacks
}