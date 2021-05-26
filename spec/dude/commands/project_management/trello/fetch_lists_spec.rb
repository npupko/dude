# frozen_string_literal: true

RSpec.describe Dude::ProjectManagement::Trello::FetchCurrentTasks do
  subject { described_class.new(client, fetch_lists: fetch_lists) }

  let(:list_response) do
    [
      { 'id' => 'column_id', 'name' => 'Backlog' }
    ]
  end

  let(:fetch_lists) { instance_double('FetchLists', call: list_response) }
  let(:client) { double('Dude::ProjectManagement::Trello') }
  let(:member) { { fullName: 'Nikita' } }
  let(:issue) do
    [{ idShort: 1, name: 'Title', desc: 'Desc', idMembers: ['member_id'] }]
  end

  let(:issue_attributes) do
    {
      id: 1,
      title: 'Title',
      description: 'Desc',
      status: 'Backlog',
      assignee: 'Nikita'
    }
  end

  it '#call' do
    expect(client).to receive(:get)
      .with('/1/lists/column_id/cards')
      .and_return(OpenStruct.new(body: issue.to_json))

    expect(client).to receive(:get)
      .with('/1/members/member_id', fields: 'fullName')
      .and_return(OpenStruct.new(body: member.to_json))

    expect(subject.call.first).to have_attributes(issue_attributes)
  end
end
