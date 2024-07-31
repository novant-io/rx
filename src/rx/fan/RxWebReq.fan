//
// Copyright (c) 2024, Novant LLC
// All Rights Reserved
//
// History:
//   31 Jul 2024  Andy Frank  Creation
//

using dom
using util

*************************************************************************
** RxWebReq
*************************************************************************

** Web request handling utilites.
@Js const class RxWebReq
{
  ** Send a GET request with no content to given uri and return future.
  static RxWebReqFuture get(Uri uri)
  {
    fut := RxWebReqFuture()
    req := HttpReq { it.uri = uri }
    req.get |res| { fut.resolve(res) }
    return fut
  }

  ** Send a POST request with no content to given uri and return future.
  static RxWebReqFuture post(Uri uri)
  {
    fut := RxWebReqFuture()
    req := HttpReq { it.uri = uri }
    req.post("") |res| { fut.resolve(res) }
    return fut
  }

  ** Post a form to given uri and return future.
  static RxWebReqFuture postForm(Uri uri, Str:Obj form)
  {
    fut := RxWebReqFuture()
    req := HttpReq { it.uri = uri }
    if (form.vals.any |v| { v is DomFile })
      req.postFormMultipart(form) |res| { fut.resolve(res) }
    else
      req.postForm(form) |res| { fut.resolve(res) }
    return fut
  }

  ** Post object as JSON and return future.
  static RxWebReqFuture postJson(Uri uri, Obj obj)
  {
    json := JsonOutStream.writeJsonToStr(obj)
    fut  := RxWebReqFuture()
    req  := HttpReq { it.uri = uri }
    req.headers.add("Content-Type", "application/json; charset=UTF-8")
    req.post(json) |res| { fut.resolve(res) }
    return fut
  }
}

*************************************************************************
** RxWebReqFuture
*************************************************************************

@Js class RxWebReqFuture
{
  ** Callback when req completes successfully with raw text response.
  This onOk(|Str| f) { this.cbOk = f; return this }
  private Func? cbOk

  ** Callback when req completes successfully with Json response data if available.
  This onOkJson(|Str:Obj?| f) { this.cbOkJson = f; return this }
  private Func? cbOkJson

  ** Callback when req fails with response data if availabe.
  This onErr(|Str:Obj?| f) { this.cbErr = f; return this }
  private Func cbErr := |Str:Obj? err|
  {
    echo("ERR: ${err}")
    msg := err["msg"] ?: "Unknown error"
    Win.cur.alert(msg)
  }

  ** Resolve future.
  internal Void resolve(HttpRes res)
  {
    try
    {
      // short-circuit if we get back a non-200
      if (res.status != 200) throw IOErr("Error status code: ${res.status}")

      // short-circuit if JSON requested
      if (cbOkJson != null)
      {
        json := parseJson(res.content)
        return cbOkJson(json)
      }

      // else fallback to onOk raw text
      cbOk?.call(res.content)
    }
    catch (Err err)
    {
      // dump debug
      echo("WebReqFuture.err: $res.content")
      err.trace

      // try to parse response if available
      map := parseJson(res.content, false) ?: ["error":true, "msg":"Unknown error"]
      cbErr.call(map)
    }
  }

  ** Parse text into JSON or throw/return null.
  private [Str:Obj?]? parseJson(Str text, Bool checked := true)
  {
    try
    {
      obj := (Str:Obj?)JsonInStream(text.in).readJson
      return obj
    }
    catch (Err err)
    {
      if (!checked) return null
      throw err
    }
  }
}