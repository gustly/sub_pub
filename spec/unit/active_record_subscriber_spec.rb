require 'spec_helper'

describe SubPub::ActiveRecord::Subscriber do
  with_model :FooBar do
    table do |t|
      t.string :title
    end
  end

  before do
    class Fooz < SubPub::ActiveRecord::Subscriber
      subscribe_to(FooBar, 'after_create')
    end

    class Blooz < SubPub::ActiveRecord::Subscriber
      subscribe_to(FooBar, 'after_create', :title)
    end
  end

  describe ".model_name" do
    specify { expect(Fooz.model_name).to eq('FooBar') }
  end

  describe ".callback_name" do
    specify { expect(Fooz.callback_name).to eq('after_create') }
  end

  describe ".table_attributes" do
    context "with table attributes" do
      specify { expect(Blooz.table_attributes).to eq([:title]) }
    end

    context "without table attributes" do
      specify { expect(Fooz.table_attributes).to eq([]) }
    end
  end

  describe 'matchers' do
    specify { expect(Fooz).to subscribe_to_model(FooBar) }
    specify { expect(Fooz).to subscribe_to_callback("after_create") }

    specify { expect(Blooz).to subscribe_to_model(FooBar) }
    specify { expect(Blooz).to subscribe_to_callback("after_create", :title) }
  end
end

