module Search
  extend ActiveSupport::Concern

  module ClassMethods
    def search_id(targets:, id:)
      targets.where(id: id)
    end
  end
end
