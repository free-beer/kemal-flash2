module Kemal::Flash2
  # This is the entity that the end user will interact with when they are using
  # the flash entity on a HTTP::Server::Context.
  class FlashStore
    @current : Hash(String, String) = Hash(String, String).new
    getter following : Hash(String, String) = Hash(String, String).new

    def initialize
    end

    def initialize(entries : Hash(String, String))
      @current = entries
    end

    def has_key?(key : String) : Bool
      @following.has_key?(key) || @current.has_key?(key)
    end

    def fetch(key : String, alternative : String = "") : String
      has_key?(key) ? self[key] : alternative
    end

    def size
      @current.merge(@following).size
    end

    def to_s : String
      Hash(String, String).new.merge(@current).merge(@following).to_s
    end

    def [](key : String)
      raise "A flash entry under the key '#{key}' could not be found." if !has_key?(key)
      @following.has_key?(key) ? @following[key] : @current[key]
    end

    def []?(key : String)
      has_key?(key) ? self[key] : nil
    end

    def []=(key : String, value : String)
      @following[key] = value
    end

    def self.from(root : JSON::Any) : FlashStore
      raise "Flash data corrupted." if root.as_h?.nil?
      data = Hash(String, String).new
      root.as_h.each do |entry|
        data[entry[0]] = entry[1].as_s
      end
      FlashStore.new(data)
    end
  end
end
