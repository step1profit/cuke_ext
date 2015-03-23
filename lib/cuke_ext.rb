module CukeExt
  ##
  # Base CukeExt error class
  class Error < RuntimeError
  end
end

require "cuke_ext/flat_hash"
require "cuke_ext/railtie"
require "cuke_ext/version"
