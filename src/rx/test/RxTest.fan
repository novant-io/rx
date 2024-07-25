//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxTest
*************************************************************************

@Js class RxTest : Test
{
  Void testBasics()
  {
    // empty rx
    rx := Rx(DxStore())
    verifyEq(rx.buckets.size, 0)
  }
}