#! /usr/bin/env fan

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "rxTest"
    summary = "Rx Unit Tests"
    version = Version("0.1")
    meta = [
      "org.name":     "Novant",
      "org.uri":      "https://novant.io/",
      "license.name": "MIT",
      "vcs.name":     "Git",
      "vcs.uri":      "https://github.com/novant-io/rx",
      "repo.public":  "true",
      "repo.tags":    "web",
    ]
    depends = [
      "sys 1.0",
      "util 1.0",
      "concurrent 1.0",
      "dom 1.0",
      "dx 0+",
      "cam 0+",
      "rx 0+",
      "web 1.0",
      "wisp 1.0",
      "domkit 1.0",
    ]
    srcDirs = [
      `test/`
    ]
    docApi  = true
    docSrc  = true
  }
}
