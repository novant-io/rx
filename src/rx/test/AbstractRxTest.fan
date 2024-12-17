//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   16 Dec 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** AbstractRxTest
*************************************************************************

@Js abstract class AbstractRxTest : Test
{
  protected Void verifyRec(DxRec rec, Str:Obj? expect)
  {
    dumb := Str:Obj?[:].setAll(expect)
    test := Str:Obj?[:]
    rec.each |v,k| { test[k] = v }
    verifyEq(test, dumb)
  }

  protected Void verifyView(RxModel model, Str bucket, [Str:Obj?][] expect)
  {
    index := 0
    view  := model.view(bucket)
    verifyEq(view.size, expect.size)
    view.each |test| { verifyRec(test, expect[index++]) }
  }
}