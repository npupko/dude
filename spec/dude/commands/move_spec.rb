# frozen_string_literal: true

RSpec.describe Dude::Commands::Move do
  subject { described_class.new }

  let(:client) { instance_double('ProjectManagement::Client', move_task_to_list: 'List name') }

  before do
    allow(Dude::ProjectManagement::Client).to receive(:new).and_return(client)
  end

  context 'without list argument' do
    it "calls ProjectManagement::Client#move_task_to_list" do
      expect(client).to receive(:move_task_to_list).with('DMD-123', nil)
      subject.call(id: 'DMD-123')
    end
  end

  context 'with list argument' do
    it "calls ProjectManagement::Client#move_task_to_list" do
      expect(client).to receive(:move_task_to_list).with('DMD-123', 'To Do')
      subject.call(id: 'DMD-123', list: 'To Do')
    end
  end
end
