//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxGrid
*************************************************************************

** RxGrid models a grid of RxRec records.
@Js const mixin RxGrid
{
  ** Convenience for `size == 0`
  abstract Bool isEmpty()

  ** Return number of records in this grid.
  abstract Int size()

  // TODO
  // ** Metadata for this grid.
  // abstract Str:Obj? meta()

  ** Iterate each record in this grid.
  abstract Void eachRec(|RxRec rec, Int index| f)

  ** Get the record at the given index or throws 'IndexErr'
  ** if given index is out of bounds.
  @Operator
  abstract Obj? get(Int index)
}