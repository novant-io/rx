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
  new make(Str:DxRec[] buckets := [:])
  {
    this.store = DxStore(buckets)
  }

  ** Bucket keys for this Rx instance.
  Str[] buckets() { store.buckets }

  private DxStore store   // backing store instance
}