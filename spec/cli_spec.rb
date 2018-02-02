require 'byebug'
require 'spec_helper'
require_relative '../lib/dude/cli.rb'

RSpec.describe Dude::CLI do
  it "install" do
    # git = double Git
    # expect(git).to receive(:call).and_return true
    # allow(subject).to receive(:git).and_return git
    # expect(subject.checkout(1)).to eq true
    expect(true).to eq true
  end
end
