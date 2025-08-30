# frozen_string_literal: true

require "rails_helper"

describe Questionize do
  subject { Evaluation::Criterion.new.questionize(label) }

  let(:label) { "foobar" }

  it { is_expected.to eq "Est-ce que foobar ?" }

  context "when the title start with a vowel" do
    let(:label) { "ubar" }

    it { is_expected.to start_with "Est-ce qu'ubar ?" }
  end

  context "when the title ends with a dot" do
    let(:label) { "foobar." }

    it { is_expected.to end_with "bar ?" }
  end
end
