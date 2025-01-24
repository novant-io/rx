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
    verifyRec(v.getAt(0), ["id":0xffff_ffff, "name":"east_coast"])
    verifyRec(v.getAt(1), ["id":1,  "name":"Jay Gatsby",     "state":"NY"])
    verifyRec(v.getAt(2), ["id":3,  "name":"Mark Scout",     "state":"NJ"])
    verifyRec(v.getAt(3), ["id":4,  "name":"Barney Stinson", "state":"NY"])
    verifyRec(v.getAt(4), ["id":0xffff_ffff, "name":"west_coast"])
    verifyRec(v.getAt(5), ["id":2,  "name":"Ron Burgundy",   "state":"CA"])

    // add sort
    v.sort("name")
    verifyViewCols(v, ["id","name","state"], [
      ["id":0xffff_ffff, "name":"east_coast"],
      ["id":4,  "name":"Barney Stinson", "state":"NY"],
      ["id":1,  "name":"Jay Gatsby",     "state":"NY"],
      ["id":3,  "name":"Mark Scout",     "state":"NJ"],
      ["id":0xffff_ffff, "name":"west_coast"],
      ["id":2,  "name":"Ron Burgundy",   "state":"CA"],
    ])
  }

  Void testGroupSort()
  {
    // gen data
    dx := DxStore(1, ["b1":[
      DxRec(["id":1, "name":"Seth Milchick",  "state":"CA"]),
      DxRec(["id":2, "name":"Jay Gatsby",     "state":"NY"]),
      DxRec(["id":3, "name":"Ron Burgundy",   "state":"CA"]),
      DxRec(["id":4, "name":"Mark Scout",     "state":"NJ"]),
      DxRec(["id":5, "name":"Barney Stinson", "state":"NY"]),
    ]])

    // init rx
    m := Rx.cur.init("mg2").reload(dx)
    v := m.view("b1")

    // group
    v.sort("name")
    v.group(["east_coast", "midwest", "west_coast"]) |r|
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
    verifyEq(v.groups, ["east_coast", "midwest", "west_coast"])
    verifyEq(v.size, 8)
    verifyViewCols(v, ["id","name","state"], [
      ["id":0xffff_ffff, "name":"east_coast"],
      ["id":5,  "name":"Barney Stinson", "state":"NY"],
      ["id":2,  "name":"Jay Gatsby",     "state":"NY"],
      ["id":4,  "name":"Mark Scout",     "state":"NJ"],
      ["id":0xffff_ffff, "name":"midwest"],
      ["id":0xffff_ffff, "name":"west_coast"],
      ["id":3,  "name":"Ron Burgundy",   "state":"CA"],
      ["id":1,  "name":"Seth Milchick",  "state":"CA"],
    ])
  }
}