class AddStatusToAdRenewalLettersExport < ActiveRecord::Migration
  def change
    add_column :ad_renewal_letters_exports, :status, :integer, default: 0
  end
end
