//
// Copyright (c) 2025, Novant LLC
// All Rights Reserved
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

    // recs
    r1 := v.get(5)
    r2 := v.get(9)
    r3 := v.get(62)
    r4 := v.get(99)

    // verify no selection
    verifyEq(v.size, 100)
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // select a record
    v.select(r1)
    verifyEq(v.selectionSize,  1)
    verifyEq(v.selection.size, 1)
    verifyEq(v.selection[0], r1)
    verifyEq(v.selected(r1), true)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // verify re-select no-op
    v.select(r1)
    verifyEq(v.selectionSize,  1)
    verifyEq(v.selection.size, 1)
    verifyEq(v.selection[0], r1)
    verifyEq(v.selected(r1), true)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)

    // select a few more
    v.select(r2)
    v.select(r3)
    v.select(r4)
    verifyEq(v.selectionSize,  4)
    verifyEq(v.selection.size, 4)
    s := v.selection.sort |a,b| { a.id <=> b.id }
    verifyEq(s[0], r1)
    verifyEq(s[1], r2)
    verifyEq(s[2], r3)
    verifyEq(s[3], r4)
    verifyEq(v.selected(r1), true)
    verifyEq(v.selected(r2), true)
    verifyEq(v.selected(r3), true)
    verifyEq(v.selected(r4), true)

    // clear selection
    v.selectionClear
    verifyEq(v.selectionSize,  0)
    verifyEq(v.selection.size, 0)
    verifyEq(v.selected(r1), false)
    verifyEq(v.selected(r2), false)
    verifyEq(v.selected(r3), false)
    verifyEq(v.selected(r4), false)
  }
}