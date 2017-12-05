class Card
  attr_reader :name, :value, :rank

  def initialize(card)
    @name = "#{card[:suit]} #{card[:rank][:name]}"
    @value = card[:rank][:value]
    @rank = card[:rank][:name]
  end

  def to_s
    name.to_s
  end
end
