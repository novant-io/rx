//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   3 Jan 2025  Andy Frank  Creation
//

using dx

*************************************************************************
** RxSelTest
*************************************************************************

@Js class RxSelTest : AbstractRxTest
{
  Void testBasics()
  {
    // gen data
    recs := DxRec[,]
    100.times |i| {
      recs.add(DxRec(["id":i+1, "name":"B1-${i+1}"]))
    }
    dx := DxStore(1, ["b1":recs])

    // init rx
    m := Rx.cur.init("m1").reload(dx)
    v := m.view("b1")
    c := 0
    m.onSelect("b1") { c++ }

    // recs
    r1 := v.getId(5)
    r2 := v.getId(9)
    r3 := v.getId(62)
    r4 := v.getId(99)

    // verify no selection
    verifyEq(c, 0)
    verifyEq(v.size, 100)
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // select a record
    v.select(r1)
    verifyEq(c, 1)
    verifyEq(v.selectionSize,  1)
    verifyEq(v.selection.size, 1)
    verifyEq(v.selection[0], r1)
    verifyEq(v.selected(r1), true)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // verify re-select no-op
    v.select(r1)
    verifyEq(c, 2)  // NOTE: still fires event
    verifyEq(v.selectionSize,  1)
    verifyEq(v.selection.size, 1)
    verifyEq(v.selection[0], r1)
    verifyEq(v.selected(r1), true)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // deselect
    v.select(r1, false)
    verifyEq(c, 3)
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // select a few more
    v.select(r2)
    v.select(r3)
    v.select(r4)
    verifyEq(c, 6)
    verifyEq(v.selectionSize,  3)
    verifyEq(v.selection.size, 3)
    s := v.selection.sort |a,b| { a.id <=> b.id }
    verifyEq(s[0], r2)
    verifyEq(s[1], r3)
    verifyEq(s[2], r4)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), true)
    verifyEq(v.selected(r3), true)
    verifyEq(v.selected(r4), true)

    // clear selection
    v.selectAll(false)
    verifyEq(c, 7)
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // select all
    v.selectAll
    verifyEq(c, 8)
    verifyEq(v.selectionSize,  100)
    verifyEq(v.selection.size, 100)
    v.selectAll(false)
    verifyEq(c, 9)
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
  }

  Void testUpdate()
  {
    // test that a modified record gets updated in the selection

    // init rx
    m := Rx.cur.init("m2").reload(DxStore(1, ["b1":[
      DxRec(["id":1, "a":"foo", "b":12]),
      DxRec(["id":2, "a":"bar", "b":33]),
      DxRec(["id":3, "a":"zar", "b":10]),
      DxRec(["id":4, "a":"car", "b":18]),
      DxRec(["id":5, "a":"lar", "b":28]),
    ]]))

    // select
    v := m.view("b1")
    v.select(v.getId(1))
    verifyRec(v.selection[0], ["id":1, "a":"foo", "b":12])

    // update record
    m.reload(DxWriter(m.store).update("b1", 1, ["a":"xxx"]).commit)
    verifyRec(m.store.get("b1", 1), ["id":1, "a":"xxx", "b":12])
    verifyRec(v.selection[0],       ["id":1, "a":"xxx", "b":12])
  }
}