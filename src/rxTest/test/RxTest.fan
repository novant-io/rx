//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using dx
using rx

*************************************************************************
** RxTest
*************************************************************************

@Js class RxTest : Test
{
  Void testBasics()
  {
    // empty rx
    rx := Rx(DxStore(1, [:]))
    verifyEq(rx.buckets.size, 0)

    // simple rx
    rx = Rx(DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]]))

    // foo view
    view := rx.view("foo")
    verifyEq(view.isEmpty, false)
    verifyEq(view.size, 3)
  }
}