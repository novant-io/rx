//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxStore
*************************************************************************

** RxStore manages the state of namespace of RxGrids.
@Js abstract const class RxStore
{
  ** Regster a new grid for this store.
  Void register(Str key, RxGrid grid)
  {
    // verify does not exists
    if (this.grid(key) != null)
      throw ArgErr("Key already registered '${key}'")

    // store grid and config key
    store(key, grid)
    grid.keyRef.val = key

    // iterate and set guid for each key
    high := key.hash.shiftl(32)
    grid.each |r|
    {
      low := r.id.and(0xffff_ffff)
      r.guidRef.val = high.or(low)
    }
  }

  ** Get the grid for given 'key' or null if not found.
  abstract RxGrid? grid(Str key)

  ** Store this grid for given key.
  protected abstract Void store(Str key, RxGrid grid)
}
