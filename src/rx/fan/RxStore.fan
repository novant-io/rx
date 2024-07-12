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
@Js const mixin RxStore
{
  ** Get the grid for given 'key' or null if not found.
  abstract RxGrid? grid(Str key)
}
