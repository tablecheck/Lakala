# frozen_string_literal: true

require 'securerandom'

module Lakala
module Utils
  def self.nonce_str
    SecureRandom.hex(7)[0, 12]
  end

  def self.stringify_keys(hash)
    new_hash = {}
    hash.each do |key, value|
      new_hash[(key.to_s rescue key) || key] = value
    end
    new_hash
  end
end
end
