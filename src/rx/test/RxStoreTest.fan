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

  Void testEmpty()
  {
    a := RxStore()
    verifyEq(a.buckets, Str[,])
    verifyErr(ArgErr#) { x := a.get("foo", 1) }

    b := RxStore(["foo":RxRec#.emptyList])
    verifyEq(b.buckets, ["foo"])
    verifyEq(b.size("foo"), 0)
    verifyEq(b.get("foo", 1), null)
    verifyErr(ArgErr#) { x := a.get("bar", 1) }

    c := RxStore(["foo":RxRec#.emptyList, "bar":RxRec#.emptyList])
    verifyEq(c.buckets.sort, ["bar", "foo"])
    verifyEq(c.size("foo"), 0)
    verifyEq(c.size("bar"), 0)
    verifyEq(c.get("foo", 1), null)
    verifyEq(c.get("bar", 1), null)
    verifyErr(ArgErr#) { x := a.get("zar", 1) }
  }

  Void testBasics()
  {
    a := RxStore(["foo":[
      RxRec(["id":1, "a":12, "b":"foo", "c":false]),
      RxRec(["id":2, "a":24, "b":"bar", "c":true]),
      RxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]])

    verifyEq(a.buckets, ["foo"])
    verifyEq(a.size("foo"), 3)
    verifyRec(a.get("foo", 1), ["id":1, "a":12, "b":"foo", "c":false])
    verifyRec(a.get("foo", 2), ["id":2, "a":24, "b":"bar", "c":true])
    verifyRec(a.get("foo", 3), ["id":3, "a":18, "b":"zar", "c":false])

    // add some recs
    w := RxWriter(a)
    w.add("foo", ["id":4, "a":33, "b":"car"])
    w.add("foo", ["id":5, "a":99, "b":"lar"])
    b := w.commit
    verify(a !== b)
    verifyEq(a.size("foo"), 3)
    verifyEq(b.size("foo"), 5)
    verifyRec(b.get("foo", 1), ["id":1, "a":12, "b":"foo", "c":false])
    verifyRec(b.get("foo", 2), ["id":2, "a":24, "b":"bar", "c":true])
    verifyRec(b.get("foo", 3), ["id":3, "a":18, "b":"zar", "c":false])
    verifyRec(b.get("foo", 4), ["id":4, "a":33, "b":"car"])
    verifyRec(b.get("foo", 5), ["id":5, "a":99, "b":"lar"])
  }
}