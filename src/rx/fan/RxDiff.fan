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
  new makeAdd(Str:Obj? map)
  {
    this.op  = 0
    this.mod = map
  }

  ** Return diff to udpate existing rec.
  new makeUpdate(RxRec rec, Str:Obj? changes)
  {
    // walk changes and remove any unmodified fields
    mod := Str:Obj?[:]
    changes.each |v,k| {
      if (rec[k] != v) mod[k] = v
    }

    this.op  = 1
    this.id  = rec.id
    this.mod = mod
  }

  ** Diff op: 0=create, 1=update, 2=delete
  const Int op

  ** The corresponding record id for this diff or 'null' for create.
  const Int? id

  ** Modifications to apply to record.
  const Str:Obj? mod
}
