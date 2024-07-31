//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   23 Jul 2024  Andy Frank  Creation
//

using concurrent
using dx

*************************************************************************
** Rx
*************************************************************************

** Rx manages a 'Rx' runtime within a client instance.
@Js class Rx
{
  ** Init a new Rx runtime.
  new make(DxStore store)
  {
    this.store = store
  }

  ** Bucket keys for backing store of this Rx instance.
  Str[] buckets() { store.buckets }

  ** Get the current view for given bucket name.
  RxView view(Str bucket)
  {
    throw Err("Not yet implemented")
  }

  private DxStore store   // backing store instance
}