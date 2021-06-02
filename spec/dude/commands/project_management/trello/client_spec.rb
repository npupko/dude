# frozen_string_literal: true

RSpec.describe Dude::ProjectManagement::Trello::Client do
  subject { described_class.new }

  let(:fetch_current_tasks) { instance_double('Dude::ProjectManagement::Trello::FetchCurrentTasks', call: true) }
  let(:move_task_to_list) { instance_double('Dude::ProjectManagement::Trello::MoveTaskToList', call: true) }
  let(:get_task_name_by_id) { instance_double('Dude::ProjectManagement::Trello::GetTaskNameById', call: true) }

  before do
    stub_const('Dude::SETTINGS', { trello: { key: 'key', token: 'token' } })
  end

  it '#client' do
    expect(Faraday).to receive(:new).with('https://api.trello.com/', { params: { key: 'key', token: 'token' } })
    subject.client
  end

  it '#fetch_current_tasks' do
    expect(Dude::ProjectManagement::Trello::FetchCurrentTasks)
      .to(receive(:new))
      .with(subject.client).and_return(fetch_current_tasks)
    expect(fetch_current_tasks).to receive(:call)

    subject.fetch_current_tasks
  end

  it '#move_task_to_list' do
    expect(Dude::ProjectManagement::Trello::MoveTaskToList)
      .to(receive(:new))
      .with(subject.client, id: 'id', list_name: 'list').and_return(move_task_to_list)
    expect(move_task_to_list).to receive(:call)

    subject.move_task_to_list('id', 'list')
  end

  it '#get_task_name_by_id' do
    expect(Dude::ProjectManagement::Trello::GetTaskNameById)
      .to(receive(:new))
      .with(subject.client, id: 'id').and_return(get_task_name_by_id)
    expect(get_task_name_by_id).to receive(:call)

    subject.get_task_name_by_id('id')
  end
end
