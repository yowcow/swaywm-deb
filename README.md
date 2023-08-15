swaywm-deb
==========

SwayWM ubuntu deb package builder

HOW TO USE
----------

build docker image:

    make all

checkout wlroots and sway:

    make checkout

tweak wlroots and sway revisions/tags to the ones you want...

build deb packages:

    make build

and now you have

* `wlroots/yowcow-wlroots.deb`
* `sway/yowcow-sway.deb`
