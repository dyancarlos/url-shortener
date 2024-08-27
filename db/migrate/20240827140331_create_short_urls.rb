class CreateShortUrls < ActiveRecord::Migration[7.2]
  def change
    create_table :short_urls do |t|
      t.string :original_url, null: false
      t.string :short_url_code, null: false
      t.integer :access_count, null: false, default: 0
      t.timestamps
    end
  end
end
