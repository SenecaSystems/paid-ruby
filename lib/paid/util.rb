module Paid
  module Util

    def self.query_string(params)
      if params && params.any?
        return query_array(params).join('&')
      else
        return ""
      end
    end

    # Three major use cases (and nesting of them needs to be supported):
    #   { :a => { :b => "bvalue" } }  => ["a[b]=bvalue"]
    #   { :a => [1, 2] }           => ["a[]=1", "a[]=2"]
    #   { :a => "value" }          => ["a=value"]
    def self.query_array(params, key_prefix=nil)
      ret = []
      params.each do |key, value|
        if params.is_a?(Array)
          value = key
          key = ''
        end
        key_suffix = escape(key)
        full_key = key_prefix ? "#{key_prefix}[#{key_suffix}]" : key_suffix

        if value.is_a?(Hash) || value.is_a?(Array)
          # Handles the following cases:
          #   { :a => { :b => "bvalue" } }  => ["a[b]=bvalue"]
          #   { :a => [1, 2] }           => ["a[]=1", "a[]=2"]
          ret += query_array(value, full_key)
        else
          # Handles the base case with just key and value:
          #   { :a => "value" } => ["a=value"]
          ret << "#{full_key}=#{escape(value)}"
        end
      end
      ret
    end

    def self.escape(val)
      URI.escape(val.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.symbolize_keys(obj)
      if obj.is_a?(Hash)
        ret = {}
        obj.each do |key, value|
          ret[(key.to_sym rescue key) || key] = symbolize_keys(value)
        end
        return ret
      elsif obj.is_a?(Array)
        return obj.map{ |value| symbolize_keys(value) }
      else
        return obj
      end
    end

    def self.sorta_deep_clone(json)
      if json.is_a?(Hash)
        ret = {}
        json.each do |k, v|
          ret[k] = sorta_deep_clone(v)
        end
        ret
      elsif json.is_a?(Array)
        json.map{ |j| sorta_deep_clone(j) }
      else
        begin
          json.dup
        rescue
          json
        end
      end
    end

  end
end
