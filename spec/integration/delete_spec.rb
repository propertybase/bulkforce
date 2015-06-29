#encoding: utf-8
require "spec_helper"

describe "Bulk Delete", type: :integration do
  let!(:result) { delete_contacts }

  it "returns a Hash" do
    expect(result).to be_a(Hash)
  end

  it "sets state to 'Completed'" do
    expect(result[:state]).to eq("Completed")
  end

  it "has no failed records" do
    expect(result[:number_records_failed]).to eq("0")
  end
end
