module KeyboardGets
  def gets_string(msg = nil)
    print msg.to_s unless msg.nil?
    gets.chomp.strip
  end

  def gets_integer(msg = nil)
    print msg.to_s unless msg.nil?
    value = gets.chomp
    raise StandardError, "Не является числом (#{value})" if /[\D]/ =~ value || value.empty?

    value.to_i
  end
end
