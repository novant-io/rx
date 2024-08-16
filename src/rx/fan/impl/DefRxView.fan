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
  new make(Rx rx, Str bucket)
  {
    this.rx = rx
    this.bucket = bucket
  }

  ** Convenience for `size == 0`
  override Bool isEmpty() { this.size == 0 }

  ** Return number of records in current view.
  override Int size()
  {
    // TODO
    rx.store.size(bucket)
  }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? get(Int id)
  {
    // TODO
    rx.store.get(bucket, id)
  }

  ** Iterate the recs in this view.
  override Void each(|DxRec| f)
  {
    // TODO
    rx.store.each(bucket, f)
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

  private Rx rx
  private const Str bucket
}