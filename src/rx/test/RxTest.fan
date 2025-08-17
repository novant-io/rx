//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxTest
*************************************************************************

@Js class RxTest : Test
{
  Void testBasics()
  {
    // force clear
    Rx.cur.clear

    // init empty rx
    rx := Rx.cur
    verifyEq(rx.size, 0)
    verifyEq(rx.keys, Str[,])
    verifyEq(rx.model("m1", false), null)
    verifyErr(ArgErr#) { x := rx.model("m1") }

    // init model
    rx.init("m1")
    verifyEq(rx.size, 1)
    verifyEq(rx.keys, ["m1"])
    m := rx.model("m1")
    verifyNotNull(m)
    verifyEq(m.loaded, false)

    // verify no bucket
    verifyErr(ArgErr#) { x := m.view("foo") }
    verifyEq(m.view("foo", false), EmptyRxView.defVal)
    verifyEq(m.view("foo", false).size, 0)
    verifyErr(ArgErr#) { x := m.view("foo") }  // verify not cached

    // register events
    counter := 0
    m.onModify("*") { counter++ }

    // load some data
    m.reload(DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]]))
    verifyEq(m.loaded, true)

    // verify callback
    verifyEq(counter, 1)

    // foo view
    view := m.view("foo")
    verifyEq(view.isEmpty, false)
    verifyEq(view.size, 3)
    verifyEq(view.keys.rw.sort, ["a", "b", "c", "id"])
    verifyEq(view.getId(1)->a, 12)
    verifyEq(view.getAt(0)->a,  12)

    // uniqueVals
    verifyEq(view.uniqueVals("a").sort, Obj[12, 18, 24])
    verifyEq(view.uniqueVals("b").sort, Obj["bar", "foo","zar"])
    verifyEq(view.uniqueVals("c").sort, Obj[false, true])
    verifyEq(view.uniqueVals("xxx"), Obj[,])

    // remove model
    rx.remove("m1")
    verifyEq(rx.size, 0)
    verifyEq(rx.keys, Str[,])
    verifyEq(rx.model("m1", false), null)
    verifyErr(ArgErr#) { x := rx.model("m1") }
  }

  Void testVirtView()
  {
    // force clear
    Rx.cur.clear

    // init model
    rx := Rx.cur
    m := rx.init("m1").reload(DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]]))

    // add empty
    verifyTrue(m.view("va", false) is EmptyRxView)
    m.addVirtualView("va", [,])
    verifyTrue(m.view("va") is VirtRxView)
    verifyEq(m.view("va").size, 0)

    // add records
    m.addVirtualView("vb", [
      DxRec(["id":1, "v":2]),
      DxRec(["id":2, "v":4]),
      DxRec(["id":3, "v":6]),
    ])
    verifyEq(m.view("vb").size, 3)
  }
}