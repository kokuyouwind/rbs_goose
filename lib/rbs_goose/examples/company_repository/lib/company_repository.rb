# frozen_string_literal: true

class CompanyRepository
  def find
    Company.find_by(id: params[:id])
  end
end
