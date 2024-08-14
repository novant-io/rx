//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   14 Aug 2024  Andy Frank  Creation
//

using dom
using util
using web
using wisp

*************************************************************************
** Main
*************************************************************************

class Main : AbstractMain
{
  @Opt { help = "http port" }
  Int port := 8001

  override Int run()
  {
    wisp := WispService
    {
      it.httpPort = this.port
      it.root = RxTesttMod {}
    }
    return runServices([wisp])
  }
}

*************************************************************************
** RxTesttMod
*************************************************************************

const class RxTesttMod : WebMod
{
  new make(|This| f)
  {
    f(this)
    pods := [typeof.pod]
    css  := FilePack.toAppCssFiles(pods)
    this.jsPack  = FilePack(FilePack.toAppJsFiles(pods))
    this.cssPack = FilePack(css)
  }

  const FilePack jsPack

  const FilePack cssPack

  override Void onService()
  {
    n := req.modRel.path.first
    switch (n)
    {
      case null:      onIndex
      case "app.js":  jsPack.onService
      case "app.css": cssPack.onService
      default:        res.sendErr(404)
    }
  }

  Void onIndex()
  {
    if (req.method != "GET") { res.sendErr(501); return }
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    onPageHeader(out, "RxTest")

    out.main
      .p.w("TODO").pEnd
      .mainEnd

    onPageFooter(out)
  }

  ** Write page header.
  private Void onPageHeader(WebOutStream out, Str title)
  {
    out.docType
    out.html
    out.head
      .title.w(title).titleEnd
      .includeCss(`/app.css`)
      .style.w(
       """html { height: 100%; }
          body {
            padding: 0;
            margin: 0;
            font: 14px "Helvetic Neue", sans-serif;
            color: #333;
            height: 100%;
            overflow: hidden;
          }
          header {
            font-size: 16px;
            font-weight: 600;
            padding: 6px 12px;
          }
          header div {
            padding-bottom: 6px;
            border-bottom: 1px solid #ccc;
          }
          main {
            padding: 12px;
            box-sizing: border-box;
            height: calc(100% - 39px);
          }
          """).styleEnd
        .includeJs(`/app.js`)
      .headEnd
    out.body
      .header
        .div.esc(title).divEnd
        .headerEnd
  }

  ** Write page footer.
  private Void onPageFooter(WebOutStream out)
  {
    out.bodyEnd
    out.htmlEnd
  }
}