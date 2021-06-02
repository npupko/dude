# frozen_string_literal: true

RSpec.describe Dude::Commands::Install do
  subject { described_class.new }

  xcontext 'when no config in Home folder' do
    let(:mocked_file) { double('Mocked file') }

    before do
      allow(File).to receive(:exist?).and_return(false)
    end

    it 'returns message about creating file' do
      allow(File).to receive(:open).and_yield(mocked_file)
      allow(mocked_file).to receive(:write).with(subject.send(:duderc_file_content))

      expect($stdout).to receive(:puts).with('.duderc created in your HOME directory')
      subject.call
    end

    it 'calls git checkout with correct branch name' do
      expect(File).to receive(:open).and_yield(mocked_file)
      expect(mocked_file).to receive(:write).with(subject.send(:duderc_file_content))
      subject.call
    end
  end

  xcontext 'with existing config in Home folder' do
    before do
      allow(File).to receive(:exist?).and_return(true)
    end

    it 'returns message about existing file' do
      expect($stdout).to receive(:puts).with('Config file already exists')
      subject.call
    end

    it 'skips file creating' do
      expect(File).to_not receive(:open)
      subject.call
    end
  end
end
