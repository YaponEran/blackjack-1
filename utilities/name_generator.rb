module NameGenerator
  PREFIXES = %w[jo mo kra zido angu fro qwe bora stee tai woo foo].freeze
  POSTFIXES = %w[rty shin pod sty zai vic nov rain wee bro man son baz].freeze

  def generate_name
    "#{PREFIXES.sample.capitalize}#{POSTFIXES.sample}"
  end
end
