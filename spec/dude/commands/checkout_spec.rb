# frozen_string_literal: true

RSpec.describe Dude::Commands::Checkout do
  subject { described_class.new }

  let(:client) { instance_double('ProjectManagement::Client', get_task_name_by_id: 'Task name') }
  let(:checkout) { instance_double('Dude::Git::Checkout', call: true) }

  before do
    allow(Dude::ProjectManagement::Client).to receive(:new).and_return(client)
    expect(Dude::Git::Checkout).to receive(:new).and_return(checkout)
  end

  it "calls git checkout with correct branch name" do
    expect(checkout).to receive(:call).with('DMD-123-task-name')
    subject.call(id: 'DMD-123')
  end
end
