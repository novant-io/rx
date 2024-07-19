//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxDiff
*************************************************************************

** RxDiff models a modification to a 'RxRec'.
@Js internal const class RxDiff
{
  ** Return diff to add a rec to bucket.
  new makeAdd(Str bucket, Str:Obj? map)
  {
    this.bucket = bucket
    this.op  = 0
    this.changes = map
  }

  ** Return diff to udpate existing rec.
  new makeUpdate(Str bucket, Int id, Str:Obj? changes)
  {
    this.bucket = bucket
    this.op  = 1
    this.id  = id
    this.changes = changes
  }

  ** TODO: use Int ref instead of Str [pointer]?
  const Str bucket

  ** Diff op: 0=create, 1=update, 2=delete
  const Int op

  ** The corresponding record id for this diff or 'null' for create.
  const Int? id

  ** Modifications to apply to record.
  const Str:Obj? changes
}
