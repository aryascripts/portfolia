class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @total_balance = @accounts.sum(&:signed_cad_balance)
  end

  def show
    @account = Account.find(params[:id])
    @balances = @account.account_balances.order(recorded_at: :desc).page(params[:page]).per(20)
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to accounts_path, notice: 'Account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def import
    if request.post?
      if params[:file].blank?
        redirect_to accounts_import_path, alert: "Please select a CSV file to import."
        return
      end
      result = AccountCsvImporter.new(params[:file]).import
      redirect_to accounts_path, notice: "#{result[:imported]} rows imported. #{result[:failed]} failed."
    else
      render :import
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :account_type, :currency, :institution, :external_id, :book_value)
  end
end
