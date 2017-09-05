MRuby::Build.new do |conf|
  toolchain :clang
  conf.gembox 'default'
end

def crossbuild_for(name, platform, sysroot, cc_defines = [])
  MRuby::CrossBuild.new(name) do |conf|
    toolchain :clang

    conf.gembox 'default'
    conf.bins = []

    conf.cc do |cc|
      cc.command = 'xcrun'
      cc.defines = cc_defines
      cc.flags = %W(-sdk iphoneos clang -miphoneos-version-min=7.0 -arch #{platform} -isysroot #{sysroot} -g -Ofast -Wall -Werror-implicit-function-declaration -fembed-bitcode)
    end
    conf.linker do |linker|
      linker.command = 'xcrun'
      linker.flags = %W(-sdk iphoneos clang -miphoneos-version-min=7.0 -arch #{platform} -isysroot #{sysroot})
    end
  end
end

SIM_SYSROOT = %x[xcrun --sdk iphonesimulator --show-sdk-path].strip
DEVICE_SYSROOT = %x[xcrun --sdk iphoneos --show-sdk-path].strip
crossbuild_for('ios-arm64', 'arm64', DEVICE_SYSROOT, %w(MRB_INT64))
crossbuild_for('ios-armv7', 'armv7', DEVICE_SYSROOT, %w(MRB_INT64))
crossbuild_for('ios-armv7s', 'armv7s', DEVICE_SYSROOT, %w(MRB_INT64))
crossbuild_for('ios-simulator-x86_64', 'x86_64', SIM_SYSROOT, %w(MRB_INT64))
crossbuild_for('ios-simulator-i386', 'i386', SIM_SYSROOT, %w(MRB_INT64))
