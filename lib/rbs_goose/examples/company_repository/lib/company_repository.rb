class CompanyRepository
  def find
    Company.find_by(id: params[:id])
  end
end
