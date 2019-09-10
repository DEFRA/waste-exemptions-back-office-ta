class CreateAdRenewalLettersExports < ActiveRecord::Migration
  def change
    create_table :ad_renewal_letters_exports do |t|
      t.date :expires_on
      t.string :file_name
      t.integer :number_of_letters
      t.string :printed_by
      t.date :printed_on

      t.timestamps null: false
    end
  end
end
