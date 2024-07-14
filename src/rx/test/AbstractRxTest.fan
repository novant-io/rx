//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   12 Jul 2024  Andy Frank  Creation
//

@Js abstract class AbstractRxTest : Test
{

//////////////////////////////////////////////////////////////////////////
// Verify Helpers
//////////////////////////////////////////////////////////////////////////

  protected Void verifyRec(RxRec rec, Str:Obj? expect)
  {
    dumb := Str:Obj?[:].setAll(expect)
    test := Str:Obj?[:]
    rec.each |v,k| { test[k] = v }
    verifyEq(test, dumb)
  }

  protected Void verifyGrid(RxGrid g, [Str:Obj?][] expect)
  {
    verifyEq(g.isEmpty, expect.size == 0)
    verifyEq(g.size, expect.size)
    expect.each |er,i| { verifyRec(g[i], er) }
  }
}