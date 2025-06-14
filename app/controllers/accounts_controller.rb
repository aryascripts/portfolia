class AccountsController < ApplicationController
  def index
    @accounts = Account.includes(:account_balances)
                      .order(created_at: :desc)
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
    params.require(:account).permit(:name, :account_type, :currency)
  end
end
