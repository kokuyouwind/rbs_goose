module List
  def self.cons(item, rest = nil)
    [item, rest]
  end

  def self.sum(list)
    list.nil? ? 0 : list[0] + sum(list[1])
  end
end
