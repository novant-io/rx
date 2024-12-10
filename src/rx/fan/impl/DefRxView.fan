//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   30 Jul 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxView
*************************************************************************

// TODO: for now just pass bucket through

@Js internal class DefRxView : RxView
{
  ** Create a new view.
  new make(RxModel model, Str bucket)
  {
    this.model  = model
    this.bucket = bucket
    // TODO FIXIT
    this.model.store.each(bucket) |r| { rindex.add(r.id) }
    rindex.sort
  }

  ** Convenience for `size == 0`
  override Bool isEmpty() { this.size == 0 }

  ** Return number of records in current view.
  override Int size()
  {
    // TODO
    model.store.size(bucket)
  }

  ** Get record at the given index from current view.
  override DxRec at(Int index)
  {
    // TODO
    id := rindex[index]
    return model.store.get(bucket, id)
  }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? get(Int id)
  {
    // TODO
    model.store.get(bucket, id)
  }

  ** Iterate the recs in this view.
  override Void each(|DxRec| f)
  {
    // TODO
    model.store.each(bucket, f)
  }

  ** Currently selected recs in this view.
  override DxRec[] selected()
  {
    // TODO
    DxRec#.emptyList
  }

  ** Select the given record.
  override Void select(DxRec? rec)
  {
    // TODO
  }

  private RxModel model
  private const Str bucket
  private Int[] rindex := [,]  // row_index : rec_id index
}