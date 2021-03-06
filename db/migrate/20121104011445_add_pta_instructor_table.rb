class AddPtaInstructorTable < ActiveRecord::Migration
  def up
    create_table 'ptainstructors' do |t|
      t.text       'first_name'
      t.text       'last_name'
      t.text       'email'
      t.text       'phone'
      t.text       'address'
      t.text       'bio'
      t.references 'semester'
    end
  end

  def down
    drop_table 'ptainstructors'
  end
end
