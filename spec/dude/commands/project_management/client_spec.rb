# frozen_string_literal: true

RSpec.describe Dude::ProjectManagement::Client do
  subject { described_class.new }

  let(:project_management_tool) { 'jira' }
  let(:jira) { instance_double('Dude::ProjectManagement::Jira::Client') }
  let(:trello) { instance_double('Dude::ProjectManagement::Trello::Client') }

  before do
    stub_const('Dude::SETTINGS', { project_management_tool: project_management_tool })

    allow_any_instance_of(described_class).to receive(:setup_client)
      .and_return(send(project_management_tool))
  end

  it 'returns expected client tool' do
    expect(subject.client).to eq jira
  end

  context 'with trello client' do
    let(:project_management_tool) { 'trello' }

    specify do
      expect(subject.client).to eq trello
    end
  end
end
