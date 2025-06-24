class AccountsController < ApplicationController
  before_action :authenticate_user!, unless: -> { doorkeeper_token.present? }
  before_action :doorkeeper_authorize!, if: -> { doorkeeper_token.present? }

  def index
    @accounts = current_user.accounts
    @total_balance = @accounts.sum(&:signed_cad_balance)
  end

  def show
    @account = current_user.accounts.find(params[:id])
    @balances = @account.account_balances.order(recorded_at: :desc).page(params[:page]).per(20)
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = current_user.accounts.new(account_params)

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
      result = AccountCsvImporter.new(params[:file], user: current_user).import
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
