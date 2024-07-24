//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxGrid
*************************************************************************

** RxGrid models the current view of a data grid where zero
** or more 'RxTransform' instances may have been applied.
@Js mixin RxGrid
{
  ** Convenience for `size == 0`
  abstract Bool isEmpty()

  ** Return number of records in current grid.
  abstract Int size()

  ** Iterate the recs in this grid.
  abstract Void each(|DxRec| f)

  ** Currently selected recs in this grid.
  abstract DxRec[] selected()

  ** Select the given record.
  abstract Void select(DxRec? rec)
}