class AddProcessingToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :processing, :boolean, default: false, null: false
  end
end
