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
  ** Create a new diff for given record.
  new make(RxRec rec, Str:Obj? changes)
  {
    // walk changes and remove any unmodified fields
    mod := Str:Obj?[:]
    changes.each |v,k| {
      if (rec[k] != v) mod[k] = v
    }

    this.id  = rec.id
    this.mod = mod
  }

  ** The corresponding record id for this diff.
  const Int id

  ** Modifications to apply to record.
  const Str:Obj? mod
}
