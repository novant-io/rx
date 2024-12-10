//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
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
    verifyTrue(m is RxModel)

    // load some data
    m.reload(DxStore(1, ["foo":[
      DxRec(["id":1, "a":12, "b":"foo", "c":false]),
      DxRec(["id":2, "a":24, "b":"bar", "c":true]),
      DxRec(["id":3, "a":18, "b":"zar", "c":false]),
    ]]))

    // // register events
    // counter := 0
    // rx.onModify("*") { counter++ }

    // // verify callback
    // verifyEq(counter, 1)

    // foo view
    view := m.view("foo")
    verifyEq(view.isEmpty, false)
    verifyEq(view.size, 3)
    verifyEq(view.get(1)->a, 12)
    verifyEq(view.at(0)->a,  12)
  }
}