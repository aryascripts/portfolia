class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @total_balance = Account.joins(:account_balances)
                           .select('accounts.*, account_balances.balance, account_balances.recorded_at')
                           .where('account_balances.recorded_at = (SELECT MAX(recorded_at) FROM account_balances WHERE account_id = accounts.id)')
                           .sum('account_balances.balance')
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
    params.require(:account).permit(:name, :account_type, :currency)
  end
end
