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

  ** Select or deselect the given record.
  override Void select(DxRec rec, Bool select := true)
  {
    if (select) smap[rec.id] = rec
    else smap.remove(rec.id)
    fireSelect
  }

  ** Select or deselect all records in view.
  override Void selectAll(Bool select := true)
  {
    if (select) each |r| { smap[r.id] = r }
    else smap.clear
    fireSelect
  }

  ** Return 'true' if given record is selected.
  override Bool selected(DxRec rec)
  {
    smap.containsKey(rec.id)
  }

  ** Currently selected recs in this view.
  override DxRec[] selection() { smap.vals }

  ** Get number of selected records.
  override Int selectionSize() { smap.size }

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
      pr := RxUtil.sort(pa, pb)

      // if pa == pb then secondary sort
      if (pr == 0 && scol != null)
      {
        sa := ra.get(scol)
        sb := rb.get(scol)
        return RxUtil.sort(sa, sb)
      }

      return pr
    }

    // // reverse sort if needed
    // if (dir == "down") index = index.reverse

    // notify
// TODO FIXIT
    // model.fireModify([bucket])
    model.fireModify(["*"])
  }

  ** Group given view by column.
  override Void group(Str gcol, Str? scol := null)
  {
    // TODO FIXIT: this is just sort(gcol, scol); how to make DRY

    gmap := [:]
    rindex.sort |ida, idb|
    {
      // get recs
      ra := this.get(ida)
      rb := this.get(idb)

      // sort group col
      ga := ra.get(gcol)
      gb := rb.get(gcol)
      gr := RxUtil.sort(ga, gb)

      // if pa == pb then secondary sort
      if (gr == 0 && scol != null)
      {
        sa := ra.get(scol)
        sb := rb.get(scol)
        return RxUtil.sort(sa, sb)
      }

      gmap[ga] = ga
      gmap[gb] = gb

      return gr
    }

    // set grroup names
    gkeys.clear
    gkeys.addAll(gmap.keys).sort

    // // reverse sort if needed
    // if (dir == "down") index = index.reverse

    // notify
// TODO FIXIT
    // model.fireModify([bucket])
    model.fireModify(["*"])
  }

  ** Return group values from the last `group` call.
  override Obj?[] groups() { gkeys }

  // Invoke model.fireSelect event
  private Void fireSelect() { model.fireSelect([bucket]) }

  private RxModel model
  private const Str bucket

  // row_index where array position is view row index
  // and cell value is the correspoding rec_id
  private Int[] rindex := [,]

  // group keys
  private Obj?[] gkeys := [,]

  // selection map
  private Int:DxRec smap := [:]
}