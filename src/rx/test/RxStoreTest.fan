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
    store := RxStore()
    verifyEq(store.grid("a"), null)

    //
    // Grid A
    //
    u := RxGrid([:], [
      RxRec(["id":1, "a":12, "b":"foo", "c":false]),
      RxRec(["id":2, "a":24, "b":"bar", "c":true]),
      RxRec(["id":3, "a":18, "b":"zar", "c":false]),
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
    verifyEq(a[0].guid, 0x1_00000001)
    verifyEq(a[1].guid, 0x1_00000002)
    verifyEq(a[2].guid, 0x1_00000003)

    //
    // Grid B
    //
    store.register("b", RxGrid([:], [
      RxRec(["id":1, "a":912, "b":"b_foo", "c":false]),
      RxRec(["id":2, "a":924, "b":"b_bar", "c":true]),
      RxRec(["id":3, "a":918, "b":"b_zar", "c":false]),
    ]))

    b := store.grid("b")
    verifyEq(b.key, "b")
    verifyGrid(b, [
      ["id":1, "a":912, "b":"b_foo", "c":false],
      ["id":2, "a":924, "b":"b_bar", "c":true],
      ["id":3, "a":918, "b":"b_zar", "c":false],
    ])
    verifyEq(b[0].guid, 0x2_00000001)
    verifyEq(b[1].guid, 0x2_00000002)
    verifyEq(b[2].guid, 0x2_00000003)
  }
}