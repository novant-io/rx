//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

@Js class RxGridTest : AbstractRxTest
{

//////////////////////////////////////////////////////////////////////////
// Impl
//////////////////////////////////////////////////////////////////////////

  Void testImpl()
  {
    // empty rec
    g := DefRxGrid()
    verifyEq(g.isEmpty, true)
    verifyEq(g.size, 0)

    // simple
    g = DefRxGrid([
      DefRxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DefRxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DefRxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ])
    verifyGrid(g, [
      ["id":1, "a":12, "b":"foo", "c":false],
      ["id":2, "a":24, "b":"bar", "c":true],
      ["id":3, "a":18, "b":"zar", "c":false],
    ])

    // out of bounds
    verifyErr(IndexErr#) { x := g[4] }
    verifyErr(IndexErr#) { x := g[-5] }
  }
}