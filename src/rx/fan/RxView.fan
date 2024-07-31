//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
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
  ** Convenience for `size == 0`
  abstract Bool isEmpty()

  ** Return number of records in current view.
  abstract Int size()

  ** Iterate the recs in this view.
  abstract Void each(|DxRec| f)

  ** Currently selected recs in this view.
  abstract DxRec[] selected()

  ** Select the given record.
  abstract Void select(DxRec? rec)
}