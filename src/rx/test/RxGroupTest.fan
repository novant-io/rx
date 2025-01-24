//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   23 Jan 2025  Andy Frank  Creation
//


using dx

*************************************************************************
** RxGroupTest
*************************************************************************

@Js class RxGroupTest : AbstractRxTest
{
  Void testBasics()
  {
    // gen data
    dx := DxStore(1, ["b1":[
      DxRec(["id":1, "name":"Jay Gatsby",     "state":"NY"]),
      DxRec(["id":2, "name":"Ron Burgundy",   "state":"CA"]),
      DxRec(["id":3, "name":"Mark Scout",     "state":"NJ"]),
      DxRec(["id":4, "name":"Barney Stinson", "state":"NY"]),
    ]])

    // init rx
    m := Rx.cur.init("mg").reload(dx)
    v := m.view("b1")

    // default order
    verifyEq(v.groups, [,])
    verifyViewCols(v, ["id","name","state"], [
      ["id":1, "name":"Jay Gatsby",     "state":"NY"],
      ["id":2, "name":"Ron Burgundy",   "state":"CA"],
      ["id":3, "name":"Mark Scout",     "state":"NJ"],
      ["id":4, "name":"Barney Stinson", "state":"NY"],
    ])

    // group and verify
    v.group("state")
    verifyEq(v.groups, Obj?["CA", "NJ", "NY"])
    verifyViewCols(v, ["id","name","state"], [
      ["id":2, "name":"Ron Burgundy",   "state":"CA"],
      ["id":3, "name":"Mark Scout",     "state":"NJ"],
      ["id":1, "name":"Jay Gatsby",     "state":"NY"],
      ["id":4, "name":"Barney Stinson", "state":"NY"],
    ])

    // group + sort and verify
    v.group("state", "name")
    verifyEq(v.groups, Obj?["CA", "NJ", "NY"])
    verifyViewCols(v, ["id","name","state"], [
      ["id":2, "name":"Ron Burgundy",   "state":"CA"],
      ["id":3, "name":"Mark Scout",     "state":"NJ"],
      ["id":4, "name":"Barney Stinson", "state":"NY"],
      ["id":1, "name":"Jay Gatsby",     "state":"NY"],
    ])
  }
}