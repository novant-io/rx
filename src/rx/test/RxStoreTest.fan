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
    store := RxStoreImpl()
    verifyEq(store.grid("a"), null)

    store.register("a", RxGridImpl([
      RxRecImpl(["id":1, "a":12, "b":"foo", "c":false]),
      RxRecImpl(["id":2, "a":24, "b":"bar", "c":true]),
      RxRecImpl(["id":3, "a":18, "b":"zar", "c":false]),
    ]))

    a := store.grid("a")
    verifyGrid(a, [
      ["id":1, "a":12, "b":"foo", "c":false],
      ["id":2, "a":24, "b":"bar", "c":true],
      ["id":3, "a":18, "b":"zar", "c":false],
    ])
  }
}