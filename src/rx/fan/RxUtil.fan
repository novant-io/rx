//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxUtil
*************************************************************************

** RxUtil provides utility methods for Rx framework.
@Js const class RxUtil
{
  ** Return a new 'RxStore' instance.
  static RxStore makeStore()
  {
    DefRxStore()
  }

  ** Return a new 'RxGrid' instance for given meta and record list.
  static RxGrid grid(Str:Obj? meta, RxRec[] recs)
  {
    DefRxGrid(meta, recs)
  }

  ** Return a new RxRec instance for given map of values.
  static RxRec rec(Str:Obj? map)
  {
    DefRxRec(map)
  }
}
