#! /usr/bin/env fan

using build

class Build : BuildGroup
{
  new make()
  {
    childrenScripts =
    [
      `rx/build.fan`,
      `rxTest/build.fan`,
    ]
  }
}
