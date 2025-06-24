require 'csv'

class AccountCsvImporter
  REQUIRED_HEADERS = %w[
    account_name account_type currency institution external_id balance_direction balance book_value fx_rate_to_cad recorded_at
  ].freeze

  attr_reader :file, :imported, :failed, :errors

  def initialize(file)
    @file = file.respond_to?(:path) ? file.path : file
    @imported = 0
    @failed = 0
    @errors = []
  end

  def import
    CSV.foreach(@file, headers: true) do |row|
      result = import_row(row.to_h)
      if result[:success]
        @imported += 1
      else
        @failed += 1
        @errors << result[:error]
      end
    end
    Rails.logger.info("Imported #{@imported} accounts, failed #{@failed} accounts, errors: #{@errors}")
    { imported: @imported, failed: @failed, errors: @errors }
  end

  private

  def import_row(row)
    # Validate required fields
    missing = REQUIRED_HEADERS.select { |h| row[h].blank? }
    unless missing.empty?
      return { success: false, error: "Missing required fields: #{missing.join(', ')} in row: #{row.inspect}" }
    end

    unless %w[positive negative].include?(row['balance_direction'])
      return { success: false, error: "Invalid balance_direction: #{row['balance_direction']} in row: #{row.inspect}" }
    end

    begin
      account = Account.find_or_initialize_by(
        name: row['account_name'],
        institution: row['institution'],
        external_id: row['external_id']
      )
      account.assign_attributes(
        account_type: row['account_type'],
        currency: row['currency'],
        balance_direction: row['balance_direction'],
        book_value: row['book_value'] || 0
      )
      unless account.save
        return { success: false, error: "Account error: #{account.errors.full_messages.join(', ')} for row: #{row.inspect}" }
      end

      balance = account.account_balances.build(
        balance: row['balance'],
        book_value: row['book_value'],
        fx_rate_to_cad: row['fx_rate_to_cad'],
        recorded_at: row['recorded_at']
      )
      unless balance.save
        return { success: false, error: "AccountBalance error: #{balance.errors.full_messages.join(', ')} for row: #{row.inspect}" }
      end
    rescue => e
      return { success: false, error: "Exception: #{e.message} for row: #{row.inspect}" }
    end
    { success: true }
  end
end
