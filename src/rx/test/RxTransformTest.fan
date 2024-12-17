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

@Js class RxTransformTest : AbstractRxTest
{
  Void testBasics()
  {
    // gen data
    recs := DxRec[,]
    6.times |i| {
      n := i + 1
      recs.add(DxRec([
        "id": n,
        "a":  "alpha-$n",
        "b":  "beta-$n",
        "c":  "gamma-$n",
      ]))
    }

    // init rx
    m := Rx.cur.init("m2").reload(DxStore(1, ["b1":recs]))

    // foo view
    verifyView(m, "b1", [
      ["id":1, "a":"alpha-1", "b":"beta-1", "c":"gamma-1"],
      ["id":2, "a":"alpha-2", "b":"beta-2", "c":"gamma-2"],
      ["id":3, "a":"alpha-3", "b":"beta-3", "c":"gamma-3"],
      ["id":4, "a":"alpha-4", "b":"beta-4", "c":"gamma-4"],
      ["id":5, "a":"alpha-5", "b":"beta-5", "c":"gamma-5"],
      ["id":6, "a":"alpha-6", "b":"beta-6", "c":"gamma-6"],
    ])
  }
}