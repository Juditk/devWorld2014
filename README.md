This is sample code that was written for a presentation titled 'Making Devices Talk with Peer to Peer Networking' at AUC's /dev/world/2014 conference in Melbourne, Australia. The presentation can be found by visiting: http://auc.edu.au/2014/08/making-devices-talk-with-peer-to-peer-networking/

This Xcode workspace contains three separate projects titled WindChat, WaterChat and HeartChat and they're each examples of how to implement a basic chat app using different approaches to nearby peer to peer networking. 

###WindChat###
This app uses the simplest implementation of Apple's MultipeerConnectivity framework. This framework is great because it abstracts a lot of the difficulties in creating a networked app. It allows you to create a session with up to 8 peers to exchange data over infrastructure wifi, ad-hoc wifi and bluetooth. This implementation gives you a boilerplate viewController and simple delegate methods for handling networking functionality.

###WaterChat###
This app uses a more custom implementation of Apple's MultipeerConnectivity framework. It implements a custom UI and logic for automatically sending and receiving invitations. It still abstracts out a lot of the complicated networking code, but at a more customisable level. I worked a lot with this implementation but unfortunately in the end, the limitations of the simplified abstraction restricted what I wanted to do, and so I built...

###HeartChat###
This app is a completely custom implementation of peer to peer networking capabilities. I offer this to the world an alternative to MultipeerConnectivity if you find yourself in the same situation I was in. This app is an implementation of a custom peer to peer networking framework built using socket level connections and abstracted out into MultipeerConnectivity-like calls. The chat app shows an example of how it can be used to connect to nearby peers and send text and images. 

This framework, which I came to call JKPeerConnectivity, is built on the work of Peter Bakhirev and does a lot of the heavy lifting and would not have been possible without his contributions to the open source world, for which I am incredibly grateful. See - https://github.com/pbkhrv and http://mobileorchard.com/tutorial-networking-and-bonjour-on-iphone/ . His licence has been kept in tact on the appropriate files.

This project also includes the start of a companion Android project. Yes - with this custom implementation you can get iOS and Android devices to talk to each other. I'm not an Android or Java developer so that component only has the bare minimum functionality to create the connection between the devices. Sending text or images between them has not been implemented.

So, why now, 1.5 years after the actual conference have I only just now released this code? I had every intention to tidy it up, make it functional and release it. I was building an iOS app on it myself (http://juditklein.com/syncrasy.html) but this work was part of my masters degree and I cannot commit to releasing and maintaining it. However - I wrote about this on my website and I had about one query a month from someone who found it and contacted me asking to use it, usually with similar stories to mine. It seems no one else has publicly released an alternative so here it is.

It's not the most beautiful code I've written - I only had a couple of years of programming experience under my belt and I'm a self taught programmer. I never tidied it up properly and there's issues I won't get around to ironing out (I've documented the major ones I'm aware of in the issue tracking), but if you think it will be of use to you, please, by all means use it and enjoy. 