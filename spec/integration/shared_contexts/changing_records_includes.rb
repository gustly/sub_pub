
shared_context "a record with changes" do
  let(:changes) do
    {
      zzzattribute: ["words", "blerbs"],
      aaaattribute: ["spaghetti", "metallica"],
    }
  end

  let(:expected_message) { "active_record::#{record.class.to_s.underscore}::#{callback}::aaaattribute::zzzattribute" }

  before do
    allow(record).to receive(:changes) { changes }
  end
end

shared_context "a record with previous changes" do
  let(:previous_changes) do
    {
      zzzattribute: ["words", "blerbs"],
      aaaattribute: ["spaghetti", "metallica"],
    }
  end

  let(:expected_message) { "active_record::#{record.class.to_s.underscore}::#{callback}::aaaattribute::zzzattribute" }

  before do
    allow(record).to receive(:previous_changes) { previous_changes }
  end
end

