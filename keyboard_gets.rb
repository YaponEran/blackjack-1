module KeyboardGets
  def gets_string(msg = nil)
    print "#{msg}" unless msg.nil?
    gets.chomp.strip
  end

  def gets_integer(msg = nil)
    print "#{msg}" unless msg.nil?
    value = gets.chomp
    raise TypeError, "Не является числом: #{value}" if /[\D]/.match(value)

    value.to_i
  end
end