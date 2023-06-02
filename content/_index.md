---
title: "HB - Hugo Bootstrap Framework"
date: 2022-09-24T18:24:31+08:00
draft: false
layout: landing
# menu:
#   main:
#     name: Home
#     weight: 1
#     params:
#       icon:
#         vendor: bootstrap
#         name: house
---

{{< hero >}}
{{< hero-img "images/logo.png" >}}
{{< hero-heading "Innovation meets inspiration." >}}
{{< hero-lead >}}
Embark on an exciting journey into the vast world of me, where you can explore and contribute your creativity and imagination. Discover valuable insights and inspiration to enhance your pursuits.
{{< /hero-lead >}}

<div class="mt-4 d-flex align-items-center justify-content-center flex-wrap">
  <a class="btn btn-sm btn-primary fw-semibold mb-2 py-3 mx-2" href="{{< relref `achievements` >}}">
    {{< icons/icon vendor=bootstrap name=person-badge className="me-1" >}} About
  </a>
  <a class="btn btn-sm btn-primary fw-semibold mb-2 py-3 mx-2" href="{{< relref `achievements` >}}">
    {{< icons/icon vendor=bootstrap name=patch-check className="me-1" >}} Achievements
  </a>
  <a class="btn btn-sm btn-primary fw-semibold mb-2 py-3 mx-2" href="projects">
    {{< icons/icon vendor=bootstrap name= archive-fill className="me-1" >}} Projects
  </a>
 
</div>
{{< /hero >}}


