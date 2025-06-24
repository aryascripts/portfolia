class ImportsController < ApplicationController
  def index
  end

  def create
    if params[:file].blank?
      redirect_to imports_path, alert: "Please select a CSV file to import."
      return
    end
    result = AccountCsvImporter.new(params[:file]).import
    redirect_to imports_path, notice: "#{result[:imported]} rows imported. #{result[:failed]} failed." # Optionally, show errors
  end
end
