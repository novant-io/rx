//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   12 Jul 2024  Andy Frank  Creation
//

@Js class RxStoreTest : AbstractRxTest
{

//////////////////////////////////////////////////////////////////////////
// Impl
//////////////////////////////////////////////////////////////////////////

  Void testImpl()
  {
    store := DefRxStore()
    verifyEq(store.grid("a"), null)

    u := DefRxGrid([:], [
      DefRxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DefRxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DefRxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ])

    verifyEq(u.key, null)
    verifyEq(u[0].guid, 0)
    verifyEq(u[1].guid, 0)
    verifyEq(u[2].guid, 0)

    store.register("a", u)

    a := store.grid("a")
    verifyEq(a.key, "a")
    verifyGrid(a, [
      ["id":1, "a":12, "b":"foo", "c":false],
      ["id":2, "a":24, "b":"bar", "c":true],
      ["id":3, "a":18, "b":"zar", "c":false],
    ])
    verifyEq(u[0].guid, 0x1_00000001)
    verifyEq(u[1].guid, 0x1_00000002)
    verifyEq(u[2].guid, 0x1_00000003)
  }
}