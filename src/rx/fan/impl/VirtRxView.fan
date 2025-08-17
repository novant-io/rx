//
// Copyright (c) 2025, Novant LLC
// Licensed under the MIT License
//
// History:
//   16 Aug 2025  Andy Frank  Creation
//

using dx

*************************************************************************
** BaseRxView
*************************************************************************

@Js internal class VirtRxView : BaseRxView
{
  ** Constructor.
  new make(RxModel model, Str bucket, DxRec[] recs) : super(model)
  {
    this.bucket = bucket
    this.recs   = recs
    this.doSize = recs.size
    this.updateIndex
  }

  override const Str bucket

  override Str[] doKeys()
  {
    // TODO FIXIT
    recs.first._keys
  }

  override DxRec? doGet(Int id)
  {
    // TODO FIXIT
    recs.find |r| { r.id == id }
  }

  override Void doEach(|DxRec| f) { recs.each(f) }

  override const Int doSize

  private DxRec[] recs
}