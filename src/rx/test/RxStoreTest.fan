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
// Basics
//////////////////////////////////////////////////////////////////////////

  Void testBasics()
  {
    // empty
    store := RxStore()
    verifyEq(store.bucketNames.size, 0)
    verifyEq(store.bucket("foo"), null)

    // bucket 'foo'
    foo := store.createBucket("foo")
    verifyEq(store.bucketNames.size, 1)
    verifyEq(store.bucketNames, ["foo"])
    verifyEq(foo.isEmpty, true)
    verifyEq(foo.size, 0)

    // verify err
    verifyErr(ArgErr#) { store.createBucket("foo") }

    // add recs
    store.makeWriter
      .addRec("foo", ["id":1, "a":12, "b":"foo", "c":false])
      .addRec("foo", ["id":2, "a":24, "b":"bar", "c":true])
      .addRec("foo", ["id":3, "a":18, "b":"zar", "c":false])
      .commit

    // verify
    verifyBucket(foo, [
      ["id":1, "a":12, "b":"foo", "c":false],
      ["id":2, "a":24, "b":"bar", "c":true],
      ["id":3, "a":18, "b":"zar", "c":false],
    ])

    /*
    //
    // Grid A
    //
    u := RxBucket([:], [
      RxRec(["id":1, "a":12, "b":"foo", "c":false]),
      RxRec(["id":2, "a":24, "b":"bar", "c":true]),
      RxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ])

    verifyEq(u.key, null)
    verifyEq(u[0].guid, 0)
    verifyEq(u[1].guid, 0)
    verifyEq(u[2].guid, 0)

    store.register("a", u)

    a := store.bucket("a")
    verifyEq(a.key, "a")
    verifyBucket(a, [
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
    store.register("b", RxBucket([:], [
      RxRec(["id":1, "a":912, "b":"b_foo", "c":false]),
      RxRec(["id":2, "a":924, "b":"b_bar", "c":true]),
      RxRec(["id":3, "a":918, "b":"b_zar", "c":false]),
    ]))

    b := store.bucket("b")
    verifyEq(b.key, "b")
    verifyBucket(b, [
      ["id":1, "a":912, "b":"b_foo", "c":false],
      ["id":2, "a":924, "b":"b_bar", "c":true],
      ["id":3, "a":918, "b":"b_zar", "c":false],
    ])
    verifyEq(b[0].guid, 0x2_00000001)
    verifyEq(b[1].guid, 0x2_00000002)
    verifyEq(b[2].guid, 0x2_00000003)
    */
  }
}