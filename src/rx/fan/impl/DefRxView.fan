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

    // init rindex based on natural bucket order
    this.model.store.each(bucket) |r| { rindex.add(r.id) }
  }

  ** Convenience for `size == 0`
  override Bool isEmpty() { this.size == 0 }

  ** Return number of records in current view.
  override Int size() { rindex.size }

  ** Get record at the given index from current view.
  override DxRec at(Int index)
  {
    id := rindex[index]
    return this.get(id)
  }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? get(Int id)
  {
    if (id < 0)
    {
      // we use a place holder ID here which is the max
      // value supported by DxRec; it will not be unique
      g := gnames[id.negate - 1]
      return DxRec(["id":0xffff_ffff, "name":g])
    }
    else
    {
      return model.store.get(bucket, id)
    }
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

  ** Return group names from the last `group` call, or emtpy
  ** list of this view has not been grouped.
  override Str[] groups() { gnames }

  ** Group this view by given groups, where the function is
  ** used to map each record into a specific group.
  override Void group(Str[] groups, |DxRec->Str| f)
  {
    // set groups
    this.gnames = groups.dup.ro

    // map rec indexes to groups
    gmap := Str:Int[][:] { it.ordered=true }
    model.store.each(bucket) |r|
    {
      g := f(r)
      a := gmap[g] ?: Int[,]
      a.add(r.id)
      gmap[g] = a
    }

    // rebuild index and inline groups; where groups
    // are represented with negative indexes into the
    // gnames list
    rindex = List.make(Int#, model.store.size(bucket) + gnames.size)
    gmap.keys.each |g,gi|
    {
      // add group index
      rindex.add(gi.negate-1)

      // add group recs
      rindex.addAll(gmap[g])
    }

    // notify
// TODO FIXIT
    // model.fireModify([bucket])
    model.fireModify(["*"])
  }

  // Invoke model.fireSelect event
  private Void fireSelect() { model.fireSelect([bucket]) }

  private RxModel model
  private const Str bucket

  // row_index where array position is view row index
  // and cell value is the correspoding rec_id
  private Int[] rindex := [,]

  private Int:DxRec smap := [:]            // selection map
  private Str[] gnames := Str#.emptyList   // group names
}