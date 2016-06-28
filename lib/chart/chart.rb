require 'ffi'
module Chart
  extend FFI::Library
  ffi_lib 'lib/chart/chart.so'
  attach_function :CompressChart, [:pointer, :uint, :double], :pointer
end
