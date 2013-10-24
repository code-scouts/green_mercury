class CreatePublicEvents < ActiveRecord::Migration
  def change
    create_table :public_events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end
end
