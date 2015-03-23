# for use with json_spec path
module CukeExt
  module FlatHash
    def self.flat_hash(arg, keys=[])
      new_hash = {}
      case
      when arg.is_a?(Hash) then arg.each {|k,v| new_hash.merge!(self.flat_hash(v, keys + [k]))}
      when arg.is_a?(Array) then arg.each_with_index {|v,i| new_hash.merge!(self.flat_hash(v, keys + [i]))}
      else; new_hash[keys] = arg
      end
      new_hash
    end
  end
end
