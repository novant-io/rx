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
      RxRecImpl(["a":12, "b":"foo", "c":false]),
      RxRecImpl(["a":24, "b":"bar", "c":true]),
      RxRecImpl(["a":18, "b":"zar", "c":false]),
    ])
    verifyEq(g.isEmpty, false)
    verifyEq(g.size, 3)
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  // private Void verifyRec(RxRec rec, Str:Obj? expect)
  // {
  //   test := Str?:Obj[:}
  //   rec.each
  // }
}