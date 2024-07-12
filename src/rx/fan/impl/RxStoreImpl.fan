//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxStoreImpl
*************************************************************************

** Default RxStore implmentation.
@Js internal const class RxStoreImpl : RxStore
{
  ** Get the grid for given 'key' or null if not found.
  override RxGrid? grid(Str key)
  {
    map[key]
  }

  // TODO
  private const Str:RxGrid map := [:]
}
