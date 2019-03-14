# frozen_string_literal: true

 # This migration creates the `versions` table, the only schema PT requires.
# All other migrations PT provides are optional.
class CreateVersions < ActiveRecord::Migration

   # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

   def change
    create_table :versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object,    limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :versions, %i(item_type item_id)
  end
end
