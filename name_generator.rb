module NameGenerator
  PREFIXES = %w[jo mo kra zido angu fro qwe].freeze
  POSTFIXES = %w[rty pod sty zai vic nov rain].freeze

  def generate_name
    "#{PREFIXES.sample.capitalize}#{POSTFIXES.sample}"
  end
end
