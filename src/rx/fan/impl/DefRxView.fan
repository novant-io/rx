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

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  ** Create a new view.
  new make(RxModel model, Str bucket)
  {
    this.model  = model
    this.bucket = bucket
    this.updateIndex
  }

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  ** Bucket name for this view.
  override const Str bucket

  ** Convenience for `size == 0`
  override Bool isEmpty() { this.size == 0 }

  ** Return number of records in current view.
  override Int size() { rindex.size }

  ** Get union of all keys in this view.
  override Str[] keys() { model.store.keys(bucket) }

  ** Get record at the given index from current view.
  override DxRec getAt(Int index)
  {
    id := rindex[index]
    return this.getId(id)
  }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? getId(Int id)
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
    rindex.each |id| { f(this.getId(id)) }
  }

  ** Return a list of unique values for this view for given col.
  override Obj[] uniqueVals(Str col)
  {
    map := Obj:Bool[:]
    this.each |r|
    {
      v := r.get(col)
      if (v != null) map[v] = true
    }
    return map.keys
  }

//////////////////////////////////////////////////////////////////////////
// Selection
//////////////////////////////////////////////////////////////////////////

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
    if (select) each |r| {
      // TODO: how do make this DRY?
      // TODO: should 'each' [optionally?] exclude groups?
      // never select a group
      if (r.id != 0xffff_ffff) smap[r.id] = r
    }
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

//////////////////////////////////////////////////////////////////////////
// Transforms
//////////////////////////////////////////////////////////////////////////

  ** Callback to refresh view state.
  override Void refresh()
  {
    // update our view index
    this.updateIndex

    // our selection is cached with instances; so make
    // sure we update to the lastest copy
    smap.keys.each |id| { smap[id] = getId(id) }
  }

  ** Sort given view by column and optional secondary column,
  ** where 'order' indicates sort order (0=natural; 1=reverse).
  override Void sort(Str pcol, Str? scol := null, Int order := 0)
  {
    this.spcol  = pcol
    this.sscol  = scol
    this.sorder = order
    this.updateIndex
    this.fireNotify
  }

  ** Return group names from the last `group` call, or emtpy
  ** list of this view has not been grouped.
  override Str[] groups() { gnames }

  ** Group this view by given groups, where the function is
  ** used to map each record into a specific group.
  override Void group(Str[] groups, |DxRec->Str| f)
  {
    this.gnames = groups.dup.ro
    this.gfunc  = f
    this.updateIndex
    this.fireNotify
  }

  ** Filter this view using the given search query.
  override Void search(Str query)
  {
    q := query.trim
    this.qterms = q.isEmpty
      ? Regex#.emptyList
      : q.lower.split(' ').map |f| { Regex.glob("*${f}*") }
    this.updateIndex
    this.fireNotify
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  ** Update index.
  private Void updateIndex()
  {
    // init rindex based on natural bucket order
    this.rindex.clear
    this.model.store.each(bucket) |r| { rindex.add(r.id) }

    // short-circuit if no tranforms
    if (!hasTransform) return

    // apply search
    if (qterms.size > 0)
    {
      this.rindex = this.dosearch(rindex)
      return
    }

    // if no groups; do simple sort
    if (gnames.isEmpty)
    {
      this.dosort(rindex)
      return
    }

    // map rec indexes to groups
    gmap := Str:Int[][:] { it.ordered=true }
    model.store.each(bucket) |r|
    {
      g := gfunc(r)
      a := gmap[g] ?: Int[,]
      a.add(r.id)
      gmap[g] = a
    }

    // rebuild index and inline groups; where groups
    // are represented with negative indexes into the
    // gnames list
    rsize := model.store.size(bucket) + gnames.size
    rindex = List.make(Int#, rsize)
    gnames.each |g,gi|
    {
      // add group index
      rindex.add(gi.negate-1)

      // sort and add group recs
      recs := gmap[g]
      if (recs != null)
      rindex.addAll(dosort(recs))
    }
  }

  ** Filter given index by query terms.
  private Int[] dosearch(Int[] orig)
  {
    // short-circuit if no sort configurered
    if (qterms.isEmpty) return orig

    // search
    return orig.findAll |id|
    {
      // get rec and reset selection state
      rec := this.getId(id)
      // r.sel = false
      // TODO: support boolean ops?
      return qterms.all |t| {
        rec._keys.any |k| { t.matches(rec.get(k).toStr.lower) }
      }
    }
  }

  ** Sort given index of rec ids
  private Int[] dosort(Int[] orig)
  {
    // short-circuit if no sort configurered
    if (spcol == null) return orig

    // sort func
    f := |ida, idb->Int|
    {
      // get recs
      ra := this.getId(ida)
      rb := this.getId(idb)

      // sort primary col
      pa := ra.get(spcol)
      pb := rb.get(spcol)
      pr := RxUtil.sort(pa, pb)

      // if pa == pb then secondary sort
      if (pr == 0 && sscol != null)
      {
        sa := ra.get(sscol)
        sb := rb.get(sscol)
        return RxUtil.sort(sa, sb)
      }

      return pr
    }

    return sorder == 0 ? orig.sort(f) : orig.sortr(f)
  }

  ** Return 'true' if any transforms are in effect.
  private Bool hasTransform()
  {
    if (gnames.size > 0) return true
    if (qterms.size > 0) return true
    if (spcol != null)   return true
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Void fireSelect() { model.fireSelect([bucket]) }

  private Void fireNotify()
  {
    model.fireModify([bucket])
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  // model
  private RxModel model

  // row_index where array position is view row index
  // and cell value is the correspoding rec_id
  private Int[] rindex := [,]

  private Int:DxRec smap := [:]               // selection map
  private Str[] gnames   := Str#.emptyList    // group: names
  private Func? gfunc    := null              // group: func
  private Str? spcol     := null              // sort: primary col
  private Str? sscol     := null              // sort: secondary col
  private Int? sorder    := null              // sort: order
  private Regex[] qterms := Regex#.emptyList  // search: query terms
}