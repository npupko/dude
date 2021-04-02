# frozen_string_literal: true

RSpec.describe Dude::Commands::Track do
  subject { described_class.new }

  let(:start) { instance_double('Dude::Toggl::StartTimeEntry', call: true) }
  let(:client) { double('Dude::ProjectManagement::Client', get_task_name_by_id: true) }
  let(:format) { '[id] title' }

  before do
    allow(Dude::Toggl::StartTimeEntry).to receive(:new).and_return(start)
    allow(Dude::ProjectManagement::Client).to receive(:new).and_return(client)
    allow(client).to receive(:get_task_name_by_id).with('DMD-123').and_return('Issue title')
    allow(subject).to receive(:settings).and_return({
                                                      'TOGGL_PROJECT_NAME' => 'ProjectName',
                                                      'TOGGL_TASK_FORMAT' => format
                                                    })
  end

  it 'applies title format and calls start with formatted issue' do
    expect(start).to receive(:call).with(task_title: '[DMD-123] Issue title', project: 'ProjectName')
    subject.call(id: 'DMD-123')
  end

  context 'with custom format' do
    let(:format) { 'title (id)' }
    specify do
      expect(start).to receive(:call).with(task_title: 'Issue title (DMD-123)', project: 'ProjectName')
      subject.call(id: 'DMD-123')
    end
  end
end
