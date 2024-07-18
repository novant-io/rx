//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

using concurrent

*************************************************************************
** RxStoreImpl
*************************************************************************

** Default RxStore implmentation.
@Js internal const class DefRxStore : RxStore
{
  ** Get the grid for given 'key' or null if not found.
  override RxGrid? grid(Str key)
  {
    map[key]
  }

  ** Store this grid for given key.
  protected override Void store(Str key, RxGrid grid)
  {
    map[key] = grid
  }

  private const ConcurrentMap map := ConcurrentMap()
}