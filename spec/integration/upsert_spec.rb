#encoding: utf-8
require "spec_helper"

describe "Bulk Upsert", type: :integration do
  before(:context) do
    upsert_contacts
    @upserted_result = upsert_contacts
  end

  it "returns a Hash" do
    expect(@upserted_result).to be_a(Hash)
  end

  it "sets state to 'Completed'" do
    expect(@upserted_result[:state]).to eq("Completed")
  end

  it "sets correct number of records processed" do
    expect(@upserted_result[:number_records_processed]).to eq("2")
  end

  it "has no failed records" do
    expect(@upserted_result[:number_records_failed]).to eq("0")
  end
end
