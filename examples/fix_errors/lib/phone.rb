class Phone
  # @dynamic country, number
  attr_reader :country, :number

  def initialize(country:, number:)
    @country = country
    @number = number
  end

  def ==(other)
    if other.is_a?(Phone)
      # @type var other: Phone
      other.country == country && other.number == number
    else
      false
    end
  end

  def hash
    self.class.hash ^ country.hash ^ number.hash
  end
end
