# frozen_string_literal: true

RSpec.describe Dude::Commands::Stop do
  subject { described_class.new }

  let(:stop) { instance_double('Dude::Toggl::StopTimeEntry', call: true) }

  before do
    allow(Dude::Toggl::StopTimeEntry).to receive(:new).and_return(stop)
  end

  it 'calls Commands::Move with correct arguments' do
    expect(stop).to receive(:call)
    subject.call
  end
end
