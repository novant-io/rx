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

  ** Convenience for `size == 0`
  override const Bool isEmpty := true

  ** Return number of records in current view.
  override const Int size := 0

  ** Get record at the given index from current view.
  override DxRec at(Int index) { throw IndexErr("Index not found '${index}'") }

  ** Get record by id from current view or 'null' if not found.
  override DxRec? get(Int id) { null }

  ** Iterate the recs in this view.
  override Void each(|DxRec| f) {}

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

  ** Sort given view by column and optional secondary column.
  override Void sort(Str pcol, Str? scol := null) {}

  ** Group given view by column.
  override Void group(Str gcol, Str? scol := null) {}

  ** Return group values from the last `group` call.
  override Obj?[] groups() { Obj?#.emptyList }
}