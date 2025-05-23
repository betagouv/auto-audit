require 'rails_helper'

RSpec.describe FeatureHelper, type: :helper do
  before do
    ENV["BETA_STANDARDS_ENABLES_FOO"] = "one"
    ENV["BETA_STANDARDS_ENABLES_BAR"] = "two"
  end

  it "gathers the features based on their name" do
    expect(helper.enabled_features).to eq({
      foo: "one",
      bar: "two"
    })
  end

  it "can tell whether a single feature is activated" do
    expect(helper).to have_enabled_feature(:foo)
  end

  context "with something that looks falsy" do
    before { ENV["BETA_STANDARDS_ENABLES_FOO"] = "false" }

    it "does not coerce the value" do
      expect(helper).to have_enabled_feature(:foo)
    end
  end

  context "with a missing feature" do
    before { ENV.delete("BETA_STANDARDS_ENABLES_FOO") }

    it "returns false" do
      expect(helper).not_to have_enabled_feature(:foo)
    end
  end

  context "with a blank value" do
    before { ENV["BETA_STANDARDS_ENABLES_FOO"] = "" }

    it "returns false" do
      expect(helper).not_to have_enabled_feature(:foo)
    end
  end
end
