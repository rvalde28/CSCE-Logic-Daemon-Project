class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :key_number
      t.text :content
      t.boolean :set_difficulty

      t.timestamps
    end
  end
end
