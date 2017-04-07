# Kudan-1.5.1-iOS-Example

This repo contains two projects intended to be identical, yet one is coded in ObjC (from Kudan's sample app) and the other in Swift.

In order to run them, simply paste your Kudan API Key into the AppDelegate file.

## Why I created this
While the Objective-C version works perfectly, the Swift version doesn't. Upon the ARCameraViewController loading on my device, all I get is a black screen!


I've spent a lot of time trying to figure out what could be causing it and I think it may be a framework related issue.


---

I saw [this japanese post](http://dev.classmethod.jp/smartphone/iphone/ios_swift_ar_kudan/) where a user created a Kudan app with Swift. I tried to replicate his code and it also didn't work.

In his tutorial, [this photo](http://cdn.dev.classmethod.jp/wp-content/uploads/2017/03/3.png) shows that he's using Kudan v1.4 so I can only assume the issue arose with in the updates between 1.4 and 1.5.1 (the version in the repo).


**If anyone knows  how to resolve this issue, please let me know!**

---

Note: I came across [otaviokz's Kudan-Slam](https://github.com/otaviokz/Kudan-Slam) which uses Swift but ultimately is still an ObjC project (AppDelegate is in ObjC + project has the required main.m file). Being the case, my problem stands... :stuck_out_tongue: