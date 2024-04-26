class Email
  # @dynamic address
  attr_reader :address

  def initialize(address:)
    @address = address
  end

  def ==(other)
    other.is_a?(self.class) && other.address == address
  end

  def hash
    self.class.hash ^ address.hash
  end
end
