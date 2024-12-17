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
    id := rindex[index]
    return this.get(id)
  }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? get(Int id)
  {
    model.store.get(bucket, id)
  }

  ** Iterate the recs in this view.
  override Void each(|DxRec| f)
  {
    rindex.each |id| { f(this.get(id)) }
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

  ** Sort given view by column and optional secondary column.
  override Void sort(Str pcol, Str? scol := null)
  {
    rindex.sort |ida, idb|
    {
      // get recs
      ra := this.get(ida)
      rb := this.get(idb)

      // sort primary col
      pa := ra.get(pcol)
      pb := rb.get(pcol)
      return pa <=> pb
    }

    // // reverse sort if needed
    // if (dir == "down") index = index.reverse
  }

  ** Clear selection state.
  private Void clearSel()
  {
    // TODO FIXIT
    // sel.clear
  }

  private RxModel model
  private const Str bucket

  // row_index where array position is view row index
  // and cell value is the correspoding rec_id
  private Int[] rindex := [,]
}