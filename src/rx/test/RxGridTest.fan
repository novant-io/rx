//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

@Js class RxGridTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Impl
//////////////////////////////////////////////////////////////////////////

  Void testImpl()
  {
    // empty rec
    g := RxGridImpl()
    verifyEq(g.isEmpty, true)
    verifyEq(g.size, 0)

    // simple
    g = RxGridImpl([
      RxRecImpl(["id":1, "a":12, "b":"foo", "c":false]),
      RxRecImpl(["id":2, "a":24, "b":"bar", "c":true]),
      RxRecImpl(["id":3, "a":18, "b":"zar", "c":false]),
    ])
    verifyEq(g.isEmpty, false)
    verifyEq(g.size, 3)
    verifyRec(g[0], ["id":1, "a":12, "b":"foo", "c":false])
    verifyRec(g[1], ["id":2, "a":24, "b":"bar", "c":true])
    verifyRec(g[2], ["id":3, "a":18, "b":"zar", "c":false])

    // out of bounds
    verifyErr(IndexErr#) { x := g[4] }
    verifyErr(IndexErr#) { x := g[-5] }
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Void verifyRec(RxRec rec, Str:Obj? expect)
  {
    dumb := Str:Obj?[:].setAll(expect)
    test := Str:Obj?[:]
    rec.each |v,k| { test[k] = v }
    verifyEq(test, dumb)
  }
}