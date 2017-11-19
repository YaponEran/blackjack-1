module NameGenerator
  PREFIXES = %W[jo mo kra zido angu fro qwe].freeze
  POSTFIXES = %W[rty pod sty zai vic nov rain].freeze

  def generate_name
    "#{PREFIXES.shuffle.first.capitalize}#{POSTFIXES.shuffle.last}"
  end
end
