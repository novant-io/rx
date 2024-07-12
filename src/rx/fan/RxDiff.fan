//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxDiff
*************************************************************************

** RxDiff models a modification to a 'RxRec'.
@Js const mixin RxDiff
{
  ** The corresponding record id for this diff.
  abstract Int id()
}
