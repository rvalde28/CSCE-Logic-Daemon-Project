class UpdateQuestionAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :subquestions do |t|
      t.string :content
      t.string :input_type # needs radio button, text field, etc.
    end
    
    change_column :questions, :key_number, :integer
    rename_column :questions, :key_number, :chapter_num
    add_column :questions, :section_num, :decimal
    
  end
end
