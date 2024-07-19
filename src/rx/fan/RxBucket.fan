// //
// // Copyright (c) 2024, Novant LLC
// // Licensed under the MIT License
// //
// // History:
// //   11 Jul 2024  Andy Frank  Creation
// //

// using concurrent

// *************************************************************************
// ** RxBucket
// *************************************************************************

// ** RxBucket contains a list of RxRec records where ids
// ** are unique within the bucket.
// @Js internal const class RxBucket
// {
//   ** Constructor.
//   internal new make(Str name, RxRec[] recs := RxRec#.emptyList)
//   {
//     map := Int:RxRec[:]
//     recs.each |r| { map[r.id] = r }

//     this.name = name
//     this.rmap = map
//   }

//   ** Name of this bucket.
//   const Str name

//   ** Get record by id or 'null' if not found.
//   RxRec? get(Int id)
//   {
//     rmap[id]
//   }

//   ** Iterate each record in this bucket.
//   Void each(|RxRec rec| f)
//   {
//     rmap.each |v| { f(v) }
//   }

//   private const Int:RxRec rmap
// }