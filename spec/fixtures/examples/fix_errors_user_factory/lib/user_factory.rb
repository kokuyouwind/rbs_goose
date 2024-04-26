class UserFactory
  def name(name)
    @name = name
    self
  end

  def build
    User.new(name: @name)
  end
end
