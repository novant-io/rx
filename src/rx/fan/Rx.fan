//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
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

//////////////////////////////////////////////////////////////////////////
// Construction
//////////////////////////////////////////////////////////////////////////

  ** Get the Rx instance for this browser session.
  static Rx cur()
  {
    if (curRef.val == null) curRef.val = Unsafe(Rx.make)
    return curRef.val->val
  }

  ** Private ctor.
  private new make() {}

//////////////////////////////////////////////////////////////////////////
// Model
//////////////////////////////////////////////////////////////////////////

  ** Initialize a new 'RxModel' with given name.
  RxModel init(Str name)
  {
    model := RxModel()
    this.mmap.add(name, model)
    return model
  }

  ** Get number of models in this instance.
  Int size() { mmap.size }

  ** Get namespace keys for installed models.
  Str[] keys() { mmap.keys }

  ** Get model for given namespace key. If model does not
  ** exist throws 'ArgErr' or returns 'null' if checked
  ** is false.
  RxModel? model(Str key, Bool checked := true)
  {
    model := mmap[key]
    if (model == null && checked)
      throw ArgErr("Model not found '${key}'")
    return model
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  // session instance
  private static const AtomicRef curRef := AtomicRef()

  private Str:RxModel mmap := [:]  // map of name:RxModel
}