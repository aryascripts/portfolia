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

  private

  def account_params
    params.require(:account).permit(:name, :account_type, :currency, :institution, :external_id, :book_value)
  end
end
