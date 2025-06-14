require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe "GET #index" do
    let!(:accounts) { create_list(:account, 3, :with_balances) }

    it "assigns all accounts to @accounts" do
      get :index
      expect(assigns(:accounts)).to match_array(accounts)
    end

    it "calculates total balance correctly" do
      total = accounts.sum { |account| account.latest_balance.balance }
      get :index
      expect(assigns(:total_balance)).to eq(total)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let(:account) { create(:account, :with_balances) }
    let!(:balances) { create_list(:account_balance, 25, account: account) }

    it "assigns the requested account to @account" do
      get :show, params: { id: account.id }
      expect(assigns(:account)).to eq(account)
    end

    it "assigns paginated balances to @balances" do
      get :show, params: { id: account.id }
      expect(assigns(:balances).count).to eq(20) # First page
    end

    it "renders the show template" do
      get :show, params: { id: account.id }
      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:account) }

      it "creates a new account" do
        expect {
          post :create, params: { account: valid_attributes }
        }.to change(Account, :count).by(1)
      end

      it "redirects to the accounts index" do
        post :create, params: { account: valid_attributes }
        expect(response).to redirect_to(accounts_path)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) { { name: nil } }

      it "does not create a new account" do
        expect {
          post :create, params: { account: invalid_attributes }
        }.not_to change(Account, :count)
      end

      it "re-renders the new template" do
        post :create, params: { account: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
