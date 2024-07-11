//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

@Js class RxRecTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Impl
//////////////////////////////////////////////////////////////////////////

  Void testImpl()
  {
    // empty rec
    r := RxRecImpl()
    verifyEq(keys(r).size, 0)
    r = RxRecImpl([:])
    verifyEq(keys(r).size, 0)

    // simple
    r = RxRecImpl(["a":12, "b":"foo", "c":false])
    verifyEq(keys(r).size, 3)
    verifyEq(keys(r), ["a","b","c"])
    verifyEq(r.get("a"), 12)
    verifyEq(r.get("b"), "foo")
    verifyEq(r.get("c"), false)
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Str[] keys(RxRec rec)
  {
    acc := Str[,]
    rec.each |v,k| { acc.add(k) }
    return acc
  }
}