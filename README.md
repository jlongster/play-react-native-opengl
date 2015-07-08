
I never open-sourced the code for [my post](http://jlongster.com/First-Impressions-using-React-Native) about React Native, where I use it to control a view on top of an OpenGL layer.

I didn't do it because the code is terrible.

I found an old, buggy 3d engine and hacked up one of its examples. So there's a lot of files in here that aren't even used. Also there are hard-coded paths everywhere, I think, so you probably won't even be able to build it. You'd have to update all the paths to react-native, etc.

However, for those who are interested, look in the following files:

* TeapotAppDelegate.m
* Everything in the `js` folder
