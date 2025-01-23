//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   16 Dec 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxSortTest
*************************************************************************

@Js class RxSortTest : AbstractRxTest
{
  Void testBasics()
  {
    // gen data
    dx := DxStore(1, ["b1":[
      DxRec(["id":1, "name":"Ron Burgundy",   "addr":"1432 Maple Ave",     "city":"San Diego",     "state":"CA"]),
      DxRec(["id":2, "name":"Barney Stinson", "addr":"2500 Fifth Ave",     "city":"New York",      "state":"NY"]),
      DxRec(["id":3, "name":"Jay Gatsby",     "addr":"235 Middle Neck Rd", "city":", Sands Point", "state":"NY"]),
    ]])

    recs := DxRec[,]
    5.times |i| {
      n := i + 1
      recs.add(DxRec([
        "id": n,
        "a":  "alpha-$n",
        "b":  "beta-$n",
        "c":  "gamma-$n",
      ]))
    }

    // init rx
    m := Rx.cur.init("m2").reload(dx)
    v := m.view("b1")

    // default order
    verifyViewCols(v, ["id","name"], [
      ["id":1, "name":"Ron Burgundy"],
      ["id":2, "name":"Barney Stinson"],
      ["id":3, "name":"Jay Gatsby"],
    ])

    // sort and verify
    v.sort("name")
    verifyViewCols(v, ["id","name"], [
      ["id":2, "name":"Barney Stinson"],
      ["id":3, "name":"Jay Gatsby"],
      ["id":1, "name":"Ron Burgundy"],
    ])
  }
}