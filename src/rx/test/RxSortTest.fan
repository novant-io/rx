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

//////////////////////////////////////////////////////////////////////////
// Basics
//////////////////////////////////////////////////////////////////////////

  Void testBasics()
  {
    // force clear
    Rx.cur.clear

    // gen data
    dx := DxStore(1, ["b1":[
      DxRec(["id":1, "name":"Ron Burgundy",   "addr":"1432 Maple Ave",     "city":"San Diego",     "state":"CA"]),
      DxRec(["id":2, "name":"Barney Stinson", "addr":"2500 Fifth Ave",     "city":"New York",      "state":"NY"]),
      DxRec(["id":3, "name":"Jay Gatsby",     "addr":"235 Middle Neck Rd", "city":", Sands Point", "state":"NY"]),
    ]])

    // init rx
    m := Rx.cur.init("sort").reload(dx)
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

//////////////////////////////////////////////////////////////////////////
// Modify
//////////////////////////////////////////////////////////////////////////

  Void testModify()
  {
    // force clear
    Rx.cur.clear

    x := 0
    a := 0
    b := 0
    c := 0

    // create dx
    dx := DxStore(1, [
      "a":[
        DxRec(["id":1, "name":"Gamma"]),
        DxRec(["id":2, "name":"Alpha"]),
        DxRec(["id":3, "name":"Beta"]),
      ],
      "b":[
        DxRec(["id":1, "name":"Epsilon"]),
        DxRec(["id":2, "name":"Zeta"]),
        DxRec(["id":3, "name":"Delta"]),
      ],
      "c":[
        DxRec(["id":1, "name":"Theta"]),
        DxRec(["id":2, "name":"Eta"]),
        DxRec(["id":3, "name":"Iota"]),
      ],
    ])

    // init rx
    m := Rx.cur.init("sort").reload(dx)

    // register event handlers
    m.onModify("*") { x++ }
    m.onModify("a") { a++ }
    m.onModify("b") { b++ }
    m.onModify("c") { c++ }
    verifyEq(x, 0)
    verifyEq(a, 0)
    verifyEq(b, 0)
    verifyEq(c, 0)

    // sort 'a'
    m.view("a").sort("name")
    verifyEq(x, 1)
    verifyEq(a, 1)
    verifyEq(b, 0)
    verifyEq(c, 0)

    // sort 'b'
    m.view("b").sort("name")
    verifyEq(x, 2)
    verifyEq(a, 1)
    verifyEq(b, 1)
    verifyEq(c, 0)

    // sort 'c'
    m.view("c").sort("name")
    verifyEq(x, 3)
    verifyEq(a, 1)
    verifyEq(b, 1)
    verifyEq(c, 1)

    // sort 'b' 3 times
    3.times { m.view("b").sort("name") }
    verifyEq(x, 6)
    verifyEq(a, 1)
    verifyEq(b, 4)
    verifyEq(c, 1)

    // reload should fire inc 4 counters
    m.reload(dx)
    verifyEq(x, 7)
    verifyEq(a, 2)
    verifyEq(b, 5)
    verifyEq(c, 2)
  }
}