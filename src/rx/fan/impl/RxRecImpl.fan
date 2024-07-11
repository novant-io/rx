//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   11 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** RxRecImpl
*************************************************************************

** Default RxRec implmentation.
@Js internal const class RxRecImpl : RxRec
{
  ** Constructor.
  new make(Str:Obj? map := [:]) { this.map = map }

  ** Iterate the keys in this record.
  override Void eachKey(|Str key, Int index| f)
  {
    map.keys.each |k,i| { f(k,i) }
  }

  ** Get the value for the given `key` or 'null' if not found.
  @Operator
  override Obj? get(Str key)
  {
    map[key]
  }

  private const Str:Obj? map
}