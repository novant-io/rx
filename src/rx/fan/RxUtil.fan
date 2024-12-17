//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   17 Dec 2024  Andy Frank  Creation
//

*************************************************************************
** RxUtil
*************************************************************************

@Js internal const class RxUtil
{
  ** Return sort order for given values.
  static Int sort(Obj? a, Obj? b)
  {
    // check equal
    if (a == b) return 0

    // sort null to bottom
    if (a == null && b != null) return +1
    if (a != null && b == null) return -1

    // fallback to default
    return a <=> b
  }
}
