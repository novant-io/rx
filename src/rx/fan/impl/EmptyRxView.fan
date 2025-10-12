//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   3 Jan 2025  Andy Frank  Creation
//

using dx

*************************************************************************
** EmptyRxView
*************************************************************************

@Js internal const class EmptyRxView : RxView
{
  static const EmptyRxView defVal := EmptyRxView()

  ** Empty string for bucket name.
  override const Str bucket := ""

  ** Convenience for `size == 0`
  override const Bool isEmpty := true

  ** Return number of records in current view.
  override const Int size := 0

  ** Get union of all keys in this view.
  override const Str[] keys := Str#.emptyList

  ** Get record at the given index from current view.
  override DxRec getAt(Int index) { throw IndexErr("Index not found '${index}'") }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? getId(Int id) { null }

  ** Iterate the recs in this view.
  override Void each(|DxRec| f) {}

  ** Return a list of unique values for this view for given col.
  override Obj[] uniqueVals(Str col) { Obj#.emptyList }

  ** Select or deselect the given record.
  override Void select(DxRec rec, Bool select := true) {}

  ** Select or deselect all records in view.
  override Void selectAll(Bool select := true) {}

  ** Return 'true' if given record is selected.
  override Bool selected(DxRec rec) { false }

  ** Currently selected recs in this view.
  override DxRec[] selection() { DxRec#.emptyList }

  ** Get number of selected records.
  override const Int selectionSize := 0

  ** Callback to refresh view state.
  override Void refresh() {}

  ** Sort given view by column and optional secondary column,
  ** where 'order' indicates sort order (0=natural; 1=reverse).
  override Void sort(Str pcol, Str? scol := null, Int order := 0) {}

  ** Sort given view by given function.
  override Void sortFunc(|DxRec,DxRec->Int| func) {}

  ** Return group names from the last `group` call, or emtpy
  ** list of this view has not been grouped.
  override Str[] groups() { Str#.emptyList }

  ** Group this view by given groups, where the function is
  ** used to map each record into a specific group.
  override Void group(Str[] groups, |DxRec->Str| f) {}

  ** Filter this view using the given search query.
  override Void search(Str query) {}
}