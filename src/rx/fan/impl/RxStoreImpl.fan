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
@Js internal const class RxStoreImpl : RxStore
{
  ** Regster a new grid for this store.
  override Void register(Str key, RxGrid grid)
  {
    if (map.containsKey(key)) throw ArgErr("Key already registered '${key}'")
    map[key] = grid
  }

  ** Get the grid for given 'key' or null if not found.
  override RxGrid? grid(Str key)
  {
    map[key]
  }

  private const ConcurrentMap map := ConcurrentMap()
}