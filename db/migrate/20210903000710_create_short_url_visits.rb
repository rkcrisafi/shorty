class CreateShortUrlVisits < ActiveRecord::Migration[6.1]
  def change
    create_table :short_url_visits do |t|
      t.string :short_url

      t.timestamps
    end
  end
end
