//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   16 Dec 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxTransformTest
*************************************************************************

@Js class RxTransformTest : Test
{
  Void testBasics()
  {
    // gen data
    recs := DxRec[,]
    10.times |i| {
      n := i + 1
      recs.add(DxRec([
        "id":    n,
        "alpha": "alpha-$n",
        "beta":  "beta-$n",
        "gamma": "gamma-$n",
      ]))
    }

    // init rx
    m := Rx.cur.init("m2").reload(DxStore(1, ["b1":recs]))

    // foo view
    view := m.view("b1")
    verifyEq(view.size, 10)
  }
}