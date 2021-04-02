# frozen_string_literal: true

RSpec.describe Dude::Commands::Tasks do
  subject { described_class.new }

  let(:client) { double('Dude::ProjectManagement::Client', fetch_current_tasks: tasks) }
  let(:tasks) do
    [
      Dude::ProjectManagement::Entities::Issue.new(
        assignee: 'Author',
        description: 'description',
        id: 'DMD-2',
        status: 'In Progress',
        title: 'Buy Mustang'
      ),

      Dude::ProjectManagement::Entities::Issue.new(
        assignee: 'Another author',
        description: 'description',
        id: 'DMD-1',
        status: 'In Progress',
        title: 'Remove project from github'
      ),

      Dude::ProjectManagement::Entities::Issue.new(
        assignee: 'Another author',
        description: 'description',
        id: 'DMD-3',
        status: 'To Do',
        title: 'Blow up the internet'
      )
    ]
  end

  before do
    allow(Dude::ProjectManagement::Client).to receive(:new).and_return(client)
  end

  let(:lines) do
    [
      "\e[1;32;49mIn Progress:\e[0m",
      "\e[1;39;49mDMD-2\e[0m: Buy Mustang\e[0;34;49m (Author)\e[0m",
      "\e[1;39;49mDMD-1\e[0m: Remove project from github\e[0;34;49m (Another author)\e[0m",
      "\n",
      "\e[1;32;49mTo Do:\e[0m",
      "\e[1;39;49mDMD-3\e[0m: Blow up the internet\e[0;34;49m (Another author)\e[0m",
      "\n"
    ]
  end

  it 'prints list of tasks' do
    lines.each do |line|
      expect($stdout).to receive(:puts).with(line).ordered
    end

    subject.call
  end
end
