class Bank
  attr_accessor :bet_rate, :sum

  def initialize(bet_rate, sum = 0)
    @bet_rate = bet_rate
    @sum = sum
  end

  def give_full_sum
    give_sum(sum)
  end

  def give_sum(sum)
    raise StandardError, 'В банке недостаточно средств' if self.sum - sum < 0
    sum_before = self.sum
    self.sum -= sum
    
    sum_before
  end
   
  def to_s
    "#{sum}$"
  end
end
