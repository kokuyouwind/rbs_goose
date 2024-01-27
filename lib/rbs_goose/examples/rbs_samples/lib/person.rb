class Person
  # @dynamic name, contacts
  attr_reader :name
  attr_reader :contacts

  def initialize(name:)
    @name = name
    @contacts = []
  end

  def guess_country()
    contacts.map do |contact|
      case contact
      when Phone
        contact.country
      end
    end.compact.first
  end
end
