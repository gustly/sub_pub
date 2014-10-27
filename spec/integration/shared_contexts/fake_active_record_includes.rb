shared_context "a fake active record user" do
  with_model :FakeActiveRecordUser do
    table do |t|
      t.string :title
      t.string :body
      t.string :pizza
    end

    model do
      has_many :fake_active_record_results
    end
  end
end

shared_context "a fake active record result" do
  with_model :FakeActiveRecordResult do
    table do |t|
      t.string :title
      t.string :body
      t.string :pizza
      t.integer :fake_active_record_user_id
    end
  end
end


