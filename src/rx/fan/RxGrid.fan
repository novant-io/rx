//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxGrid
*************************************************************************

** RxGrid models a grid of RxRec records.
@Js abstract const class RxGrid
{
  // ** The key name for this grid in the parent 'RxStore' namespace,
  // ** or 'null' if this grid does not exist in a namespace.
  Str? key() { keyRef.val }
  internal const AtomicRef keyRef := AtomicRef()

  ** Convenience for `size == 0`
  abstract Bool isEmpty()

  ** Return number of records in this grid.
  abstract Int size()

  ** Metadata for this grid.
  abstract Str:Obj? meta()

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  abstract Obj? get(Int index)

  ** Iterate each record in this grid.
  abstract Void each(|RxRec rec, Int index| f)
}