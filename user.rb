require_relative 'validation.rb'

class User
  include Validation

  attr_reader :name
  attr_accessor :player

  NAME_FORMAT = /^[a-z0-9_]+$/i

  validate :name, :type, String
  validate :name, :min_length, 3
  validate :name, :max_length, 15
  validate :name, :format, NAME_FORMAT, message: 'Имя может включать только a-z, 0-9 и _'

  def initialize(name)
    @name = name
    validate!
  end
end
