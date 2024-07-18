//
// This code was originally written as part of the Bruno project
// and is used with minor modifications for this project:
//
// https://github.com/afrankvt/bruno
//
// Copyright (c) 2017, Andy Frank
// Licensed under the MIT License
//
// History:
//   9 Jul 2017  Andy Frank  Creation
//  18 Jul 2024  Andy Frank  Minor changes for Rx
//

**
** RxRxRecMapTest
**
class RxRxRecMapTest : Test
{

  private RxRec makeRxRec(Int id)
  {
    return RxRec(["id":id])
  }

//////////////////////////////////////////////////////////////////////////
// testEmpty
//////////////////////////////////////////////////////////////////////////

  Void testEmpty()
  {
    a := RxRecMap()
    b := RxRecMap()
    verifyEq(a.size, 0)
    verifyEq(b.size, 0)
    verifyEq(RxRecMap.empty.size, 0)
    verify(a === b)
    verify(a === RxRecMap.empty)
  }

//////////////////////////////////////////////////////////////////////////
// testSet
//////////////////////////////////////////////////////////////////////////

  Void testSetBasics()
  {
    r5 := makeRxRec(5)
    r8 := makeRxRec(8)

    a := RxRecMap()
    b := a.set(r5)
    verify(a !== b)
    verifyEq(a.size, 0)
    verifyEq(b.size, 1)
    verifyEq(a.get(5), null)
    verifyEq(b.get(5), r5)

    c := b.set(r8)
    verify(a !== b)
    verify(b !== c)
    verifyEq(a.size, 0)
    verifyEq(b.size, 1)
    verifyEq(c.size, 2)
    verifyEq(a.get(5), null)
    verifyEq(b.get(5), r5)
    verifyEq(c.get(5), r5)
    verifyEq(a.get(8), null)
    verifyEq(b.get(8), null)
    verifyEq(c.get(8), r8)
  }

  Void testSetKeys()
  {
    recs := Int:RxRec[:]
    while (recs.size < 10_000)
    {
      id := Int.random(0..4_294_967_296)
      recs[id] = makeRxRec(id)
    }

    m := RxRecMap()
    recs.vals.each |r| { m = m.set(r) }
    verifyEq(m.size, recs.size)
  }

  Void testSetBig()
  {
    count := 100_000

    m := RxRecMap()
    count.times |x| { m = m.set(makeRxRec(x+1)) }
    verifyEq(m.size, count)

    sum := 0
    m.each |r| { sum += r.id }
    verifyEq(sum, 5_000_050_000)
  }

//////////////////////////////////////////////////////////////////////////
// testAdd
//////////////////////////////////////////////////////////////////////////

  Void testAddBasics()
  {
    r2 := makeRxRec(2)
    r4 := makeRxRec(4)
    r6 := makeRxRec(6)

    m := RxRecMap()
    m = m.add(r2)
    m = m.add(r4)
    m = m.add(r6)

    verifyErr(Err#) { m = m.add(r2) }
    verifyErr(Err#) { m = m.add(r4) }
    verifyErr(Err#) { m = m.add(r6) }
  }

//////////////////////////////////////////////////////////////////////////
// testGet
//////////////////////////////////////////////////////////////////////////

  Void testGet()
  {
    count := 10_000

    m := RxRecMap()
    count.times |x| { m = m.set(makeRxRec(x+1)) }
    verifyEq(m.size, count)

    count.times |c|
    {
      r := m.get(c+1)
      verifyEq(r.id, c+1)
    }
  }

//////////////////////////////////////////////////////////////////////////
// testRemove
//////////////////////////////////////////////////////////////////////////

  Void testRemoveBasics()
  {
    r1 := makeRxRec(1)
    r2 := makeRxRec(2)
    r3 := makeRxRec(3)
    r4 := makeRxRec(4)
    r5 := makeRxRec(5)

    m := RxRecMap()
    m = m.set(r5)
    m = m.set(r4)
    m = m.set(r3)
    m = m.set(r2)
    m = m.set(r1)
    verifyEq(m.size, 5)

    a := m.remove(3)
    verify(a !== m)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(m.get(3), r3)
    verifyEq(a.get(3), null)

    b := a.remove(1)
    verify(a !== m)
    verify(b !== a)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    // 3
    verifyEq(m.get(3), r3)
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    // 1
    verifyEq(m.get(1), r1)
    verifyEq(a.get(1), r1)
    verifyEq(b.get(1), null)

    c := b.remove(2)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    // 3
    verifyEq(m.get(3), r3)
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    verifyEq(c.get(3), null)
    // 1
    verifyEq(m.get(1), r1)
    verifyEq(a.get(1), r1)
    verifyEq(b.get(1), null)
    verifyEq(c.get(1), null)
    // 2
    verifyEq(m.get(2), r2)
    verifyEq(a.get(2), r2)
    verifyEq(b.get(2), r2)
    verifyEq(c.get(2), null)

    d := c.remove(5)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verify(d !== c)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    verifyEq(d.size, 1)
    // 3
    verifyEq(m.get(3), r3)
    verifyEq(a.get(3), null)
    verifyEq(b.get(3), null)
    verifyEq(c.get(3), null)
    verifyEq(d.get(3), null)
    // 1
    verifyEq(m.get(1), r1)
    verifyEq(a.get(1), r1)
    verifyEq(b.get(1), null)
    verifyEq(c.get(1), null)
    verifyEq(d.get(1), null)
    // 2
    verifyEq(m.get(2), r2)
    verifyEq(a.get(2), r2)
    verifyEq(b.get(2), r2)
    verifyEq(c.get(2), null)
    verifyEq(d.get(2), null)
    // 5
    verifyEq(m.get(5), r5)
    verifyEq(a.get(5), r5)
    verifyEq(b.get(5), r5)
    verifyEq(c.get(5), r5)
    verifyEq(d.get(5), null)

    e := d.remove(4)
    verify(a !== m)
    verify(b !== a)
    verify(c !== b)
    verify(d !== c)
    verify(e !== d)
    verifyEq(m.size, 5)
    verifyEq(a.size, 4)
    verifyEq(b.size, 3)
    verifyEq(c.size, 2)
    verifyEq(d.size, 1)
    verifyEq(e.size, 0)

    x := a.remove(10)
    verify(x === a)
  }

  Void testRemoveBig()
  {
    count := 10_000

    m := RxRecMap()
    count.times |x| { m = m.set(makeRxRec(x+1)) }
    verifyEq(m.size, count)

    cur := m.size
    count.times |c|
    {
      m = m.remove(c+1)
      verifyEq(m.size, --cur)
    }

    verifyEq(m.size, 0)
  }

//////////////////////////////////////////////////////////////////////////
// testEach
//////////////////////////////////////////////////////////////////////////

  Void testEach()
  {
    m := RxRecMap()
    128.times |x| { m = m.set(makeRxRec(x+1)) }
    verifyEq(m.size, 128)

    y := 0
    z := 0
    m.each |r| { y++; z+=r.id }
    verifyEq(y, 128)
    verifyEq(z, 8256)
  }
}
