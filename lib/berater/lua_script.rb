require 'digest'

module Berater
  class LuaScript

    attr_reader :source

    def initialize(source)
      @source = source
    end

    def sha
      @sha ||= Digest::SHA1.hexdigest(minify)
    end

    def eval(redis, *args)
      redis.evalsha(sha, *args)
    rescue Redis::CommandError => e
      raise unless e.message.include?('NOSCRIPT')

      # fall back to regular eval, which will trigger
      # script to be cached for next time
      redis.eval(minify, *args)
    end

    def load(redis)
      redis.script('LOAD', minify).tap do |sha|
        unless sha == self.sha
          raise "unexpected script SHA: expected #{self.sha}, got #{sha}"
        end
      end
    end

    def loaded?(redis)
      redis.script('EXISTS', sha)
    end

    def to_s
      source
    end

    private

    def minify
      # trim comments (whole line and partial)
      # and whitespace (prefix, suffix, and empty lines)
      @minify ||= source.gsub(/^\s*--.*\n|\s*--.*|^\s*|\s*$|^$\n/, '')
    end

  end

  def LuaScript(source)
    LuaScript.new(source)
  end
end
