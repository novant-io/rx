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
    verifyEq(v.groups, Str[,])
    verifyEq(v.size, 4)
    verifyViewCols(v, ["id","name","state"], [
      ["id":1, "name":"Jay Gatsby",     "state":"NY"],
      ["id":2, "name":"Ron Burgundy",   "state":"CA"],
      ["id":3, "name":"Mark Scout",     "state":"NJ"],
      ["id":4, "name":"Barney Stinson", "state":"NY"],
    ])

    // group
    v.group(["east_coast", "west_coast"]) |r|
    {
      switch (r->state)
      {
        case "CA": return "west_coast"
        case "NJ": return "east_coast"
        case "NY": return "east_coast"
        default:   throw ArgErr()
      }
    }

    // verify each
    verifyEq(v.groups, ["east_coast", "west_coast"])
    verifyEq(v.size, 6)
    verifyViewCols(v, ["id","name","state"], [
      ["id":0xffff_ffff, "name":"east_coast"],
      ["id":1,  "name":"Jay Gatsby",     "state":"NY"],
      ["id":3,  "name":"Mark Scout",     "state":"NJ"],
      ["id":4,  "name":"Barney Stinson", "state":"NY"],
      ["id":0xffff_ffff, "name":"west_coast"],
      ["id":2,  "name":"Ron Burgundy",   "state":"CA"],
    ])

    // verify getAt
    verifyRec(v.at(0), ["id":0xffff_ffff, "name":"east_coast"])
    verifyRec(v.at(1), ["id":1,  "name":"Jay Gatsby",     "state":"NY"])
    verifyRec(v.at(2), ["id":3,  "name":"Mark Scout",     "state":"NJ"])
    verifyRec(v.at(3), ["id":4,  "name":"Barney Stinson", "state":"NY"])
    verifyRec(v.at(4), ["id":0xffff_ffff, "name":"west_coast"])
    verifyRec(v.at(5), ["id":2,  "name":"Ron Burgundy",   "state":"CA"])
  }
}