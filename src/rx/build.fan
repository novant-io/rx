#! /usr/bin/env fan

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "rx"
    summary = "Reactive Data Framework"
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
    depends = ["sys 1.0", "util 1.0", "concurrent 1.0"]
    srcDirs = [`fan/`, `test/`]
    docApi  = true
    docSrc  = true
  }
}
