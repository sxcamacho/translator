class CreateCommits < ActiveRecord::Migration[6.0]
  def change
    create_table :commits do |t|
      t.string    :sha,           null: false,  unique: true
      t.string    :parent_sha,    null: true,   unique: true
      t.datetime  :date,          null: false
      t.string    :message,       null: false
      t.string    :author_name,   null: false
      t.string    :author_email,  null: false

      t.timestamps
    end
  end
end
