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

    // verify no selection
    verifyEq(v.size, 100)
    verifyEq(v.selected.size, 0)

    // select a record
    r1 := v.get(5)
    v.select(r1)
    verifyEq(v.selected.size, 1)
    verifyEq(v.selected[0], r1)

    // verify re-select no-op
    v.select(r1)
    verifyEq(v.selected.size, 1)
    verifyEq(v.selected[0], r1)

    // select a few more
    r2 := v.get(9)
    r3 := v.get(62)
    r4 := v.get(99)
    v.select(r2)
    v.select(r3)
    v.select(r4)
    verifyEq(v.selected.size, 4)
    s := v.selected.sort |a,b| { a.id <=> b.id }
    verifyEq(s[0], r1)
    verifyEq(s[1], r2)
    verifyEq(s[2], r3)
    verifyEq(s[3], r4)

    // clear selection
    v.clearSelected
    verifyEq(v.selected.size, 0)
  }
}