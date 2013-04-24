# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'rubygems'
require 'motion/project'
require 'bundler'
require 'motion-cocoapods'
require 'bubble-wrap'
require 'formotion'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'edX Videos'
  app.device_family = [:iphone, :ipad]
  app.icons = ["29.png", "50.png", "57.png", "58.png", "72.png", "100.png", "114.png", "144.png", "1024.png"]
  app.frameworks += %w(AudioToolbox CFNetwork SystemConfiguration MobileCoreServices Security QuartzCore StoreKit MediaPlayer)

  app.pods do
    pod "HCYoutubeParser"
    pod "SDWebImage"
    pod "SVProgressHUD"
  end
end