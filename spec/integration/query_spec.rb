#encoding: utf-8
require "spec_helper"

describe "Bulk Query", type: :integration do
  let!(:result) { client.query("Contact", "select Id from Contact limit 10").freeze }

  let(:size) { 10 }

  it "returns a hash" do
    expect(result).to be_a(Hash)
  end

  it "state is 'Completed'" do
    expect(result[:state]).to eq("Completed")
  end


  it "returns an array of results" do
    expect(result[:results]).to be_a(Array)
  end

  it "has correct size of results" do
    expect(result[:results].count).to eq(size)
  end
end
