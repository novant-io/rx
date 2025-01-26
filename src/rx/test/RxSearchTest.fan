//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   25 Jan 2025  Andy Frank  Creation
//

using dx

*************************************************************************
** RxSearchTest
*************************************************************************

@Js class RxSearchTest : AbstractRxTest
{
  Void testBasics()
  {
    // gen data
    dx := DxStore(1, ["b1":[
      DxRec(["id":1, "name":"Jay Gatsby",     "address":"235 Middle Neck Rd",       "city":"Sands Point", "state":"NY"]),
      DxRec(["id":2, "name":"Ron Burgundy",   "address":"1432 Maple Ave",           "city":"San Diego",   "state":"CA"]),
      DxRec(["id":3, "name":"Mark Scout",     "address":"101 Crawfords Corner Rd",  "city":"Holmdel",     "state":"NJ"]),
      DxRec(["id":4, "name":"Barney Stinson", "address":"2500 Fifth Ave",           "city":"New York",    "state":"NY"]),
    ]])

    // init rx
    m := Rx.cur.init("search").reload(dx)
    v := m.view("b1")

    // search by state
    // v.search("NY")
    // verifyViewCols(v, ["id","name"], [
    //   ["id":1, "name":"Jay Gatsby",   ],
    //   ["id":4, "name":"Barney Stinson"],
    // ])
  }
}