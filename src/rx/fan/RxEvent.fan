//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   15 Aug 2024  Andy Frank  Creation
//

using dx

*************************************************************************
** RxEvent
*************************************************************************

** TODO: not sure how this works yet
@Js class RxEvent
{
  ** Constructor.
  new make(Str op, |This|? f := null)
  {
    this.op = op
    if (f != null) f(this)
  }

  ** Operation that fired this event.
  const Str op

  ** Bucket for this event.
  const Str? bucket
}