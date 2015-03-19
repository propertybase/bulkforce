#encoding: utf-8
require "spec_helper"

describe "Bulk Insert", type: :integration do
  before(:context) do
    @result = insert_contacts
  end

  it "returns a Hash" do
    expect(@result).to be_a(Hash)
  end

  it "sets state to 'Completed'" do
    expect(@result[:state]).to eq("Completed")
  end

  it "sets correct number of records processed" do
    expect(@result[:number_records_processed]).to eq("2")
  end

  it "has no failed records" do
    expect(@result[:number_records_failed]).to eq("0")
  end
end
