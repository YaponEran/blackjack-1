class Card < Struct.new(:name, :value)
  def view
    name.encode('UTF-8')
  end

  def rank
    value
  end
end
