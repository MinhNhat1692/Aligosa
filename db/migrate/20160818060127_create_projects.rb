class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :station, foreign_key: true
      t.text :project_name
      t.text :contractor
      t.text :basic_info
      t.text :address
      t.date :day_start
      t.date :day_end
      t.string :logo

      t.timestamps
    end
  end
end
