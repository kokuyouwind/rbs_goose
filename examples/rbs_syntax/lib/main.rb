LITERAL_TYPES = [123, "str", :sym, true, false]

$GLOBAL_PROC = proc { |subject| "formatted: #{subject}" }

module Formattable
  def format(formatter)
    formatter.call(self.to_s)
  end
end

class FormattableString < String
  include Formattable

  def format(formatter)
    formatter.call(to_s)
  end
end
