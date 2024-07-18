//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

@Js class RxRecTest : AbstractRxTest
{

//////////////////////////////////////////////////////////////////////////
// Impl
//////////////////////////////////////////////////////////////////////////

  Void testImpl()
  {
    r := RxRec(["id":1, "a":12, "b":"foo", "c":false])
    verifyEq(keys(r).size, 4)
    verifyEq(keys(r), ["id", "a","b","c"])
    // get
    verifyEq(r.guid, 0)
    verifyEq(r.id, 1)
    verifyEq(r.get("id"), 1)
    verifyEq(r.get("a"),  12)
    verifyEq(r.get("b"),  "foo")
    verifyEq(r.get("c"),  false)
    // trap
    verifyEq(r->guid, null)
    verifyEq(r->id, 1)
    verifyEq(r->a,  12)
    verifyEq(r->b,  "foo")
    verifyEq(r->c,  false)
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Str[] keys(RxRec rec)
  {
    acc := Str[,]
    rec.each |v,k| { acc.add(k) }
    acc.moveTo("id", 0)
    return acc
  }
}