#!/usr/bin/env ruby
require "FileUtils"

BUILD_PATH = File.dirname(__FILE__)

def build_framework(name, lib_files, header_dir)
  path = "#{BUILD_PATH}/#{name}.framework"

  FileUtils.rm_rf path

  FileUtils.mkdir_p "#{path}/Headers"
  FileUtils.cp_r "#{header_dir}/.", "#{path}/Headers"

  File.open "#{path}/Headers/mruby-umbrella.h", "w" do |file|
    file.puts '#define MRB_INT64'
    file.puts '#include "mruby.h"'
    Dir.chdir "#{path}/Headers" do
      Dir["mruby/*.h"].each do |f|
        next if f == "mruby/debug.h"
        next if f =~ /mruby\/boxing/
        file.puts "#include \"#{f}\""
      end
    end
  end

  Dir.mkdir "#{path}/Modules"
  File.open "#{path}/Modules/module.modulemap", "w" do |file|
    file.write <<EOF
framework module MRuby {
  umbrella header "mruby-umbrella.h"

  exclude header "mruby/boxing_nan.h"
  exclude header "mruby/boxing_no.h"
  exclude header "mruby/boxing_word.h"
  exclude header "mruby/debug.h"

  export *
  module * { export * }
}
EOF
  end

  system "lipo #{lib_files.join " "} -create -output #{path}/#{name}"
end

lib_files = %w(arm64 armv7 armv7s simulator-x86_64 simulator-i386).map do |arch|
  "#{BUILD_PATH}/ios-#{arch}/lib/libmruby.a"
end
header_dir = "#{BUILD_PATH}/../include"

build_framework "MRuby", lib_files, header_dir
