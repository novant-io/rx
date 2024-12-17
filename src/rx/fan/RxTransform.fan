//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxTransform
*************************************************************************

** RxTransform mutates the view of a 'RxView'.
@Js abstract class RxTransform
{
  ** Fire event that this transform was modified and
  ** corresponding view needs to be updated.
  protected Void fireModify() { /*model?.recomputeView*/ }
  internal RxModel? model
}
