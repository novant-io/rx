//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxView
*************************************************************************

** RxView models the current view of a DxStore bucket, where
** zero or more 'RxTransform' instances may have been applied.
@Js mixin RxView
{

//////////////////////////////////////////////////////////////////////////
// Access
//////////////////////////////////////////////////////////////////////////

  ** Convenience for `size == 0`
  abstract Bool isEmpty()

  ** Return number of records in current view.
  abstract Int size()

// getAt?
  ** Get record at the given index from current view.
  abstract DxRec at(Int index)

// getId?
  ** Get record by id from current view or 'null' if not found.
  abstract DxRec? get(Int id)

  ** Iterate the recs in this view.
  abstract Void each(|DxRec| f)

//////////////////////////////////////////////////////////////////////////
// Selection
//////////////////////////////////////////////////////////////////////////

  ** Select or deselect the given record.
  abstract Void select(DxRec rec, Bool select := true)

  ** Select or deselect all records in view.
  abstract Void selectAll(Bool select := true)

  ** Return 'true' if given record is selected.
  abstract Bool selected(DxRec rec)

  ** Currently selected recs in this view.
  abstract DxRec[] selection()

  ** Get number of selected records.
  abstract Int selectionSize()

//////////////////////////////////////////////////////////////////////////
// Transforms
//////////////////////////////////////////////////////////////////////////

  ** Sort given view by column and optional secondary column.
  abstract Void sort(Str pcol, Str? scol := null)

  ** Return group names from the last `group` call, or emtpy
  ** list of this view has not been grouped.
  abstract Str[] groups()

  ** Group this view by given groups, where the function is
  ** used to map each record into a specific group.
  abstract Void group(Str[] groups, |DxRec->Str| f)
}