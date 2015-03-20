#encoding: utf-8
require "spec_helper"

describe Bulkforce::Connection do
  let(:subject) do
    described_class.new(
      session_id: session_id,
      instance: instance,
      api_version: api_version,
    )
  end

  let(:session_id) { "org_id!session_id" }
  let(:instance) { "eu2" }
  let(:api_version) { "33.0" }

  {
    login: 0,
    create_job: 4,
    close_job: 1,
    query_batch: 2,
    query_batch_result_id: 2,
    query_batch_result_data: 3,
  }.each do |method_name, num_of_params|
    describe "##{method_name}" do
      it "delegates correctly to Http class" do
        allow(Bulkforce::Helper).to receive(:parse_csv).and_return([])
        expect(Bulkforce::Http)
          .to receive(method_name)
          .and_return({})
        subject.send(method_name, *Array.new(num_of_params))
      end
    end
  end

  describe "#add_query" do
    it "delegates correctly to Http class" do
      expect(Bulkforce::Http).to receive(:add_batch)
          .and_return({})
      subject.add_query(nil, nil)
    end
  end

  describe "#org_id" do
    let(:org_id) { "00D50000000IehZ" }
    let(:session_id) { "#{org_id}!AQcAQH0dMHZfz972Szmpkb58urFRkgeBGsxL_QJWwYMfAbUeeG7c1E6LYUfiDUkWe6H34r1AAwOR8B8fLEz6n04NPGRrq0FM" }

    it "returns correct OrgId" do
      expect(subject.org_id).to eq(org_id)
    end
  end

  describe "#add_batch" do
    it "delegates correctly to underlying classes" do
      expect(Bulkforce::Http).to receive(:add_batch)
          .and_return({})
      expect(Bulkforce::Helper).to receive(:records_to_csv)
        .and_return("My,Awesome,CSV")
      subject.add_batch(nil, [{"non_emtpy" => "records"}])
    end

    it "returns -1 for nil input" do
      return_code = subject.add_batch(nil, nil)
      expect(return_code).to eq(-1)
    end

    it "returns -1 for empty input" do
      return_code = subject.add_batch(nil, [])
      expect(return_code).to eq(-1)
    end
  end

  describe "#query_batch_result_id" do
    let(:job_id) {"12345"}
    let(:batch_id) {"67890"}

    context "with a single page of results" do
      let(:single_result) {{:result=>"M75200000001Vgt", :@xmlns=>"http://www.force.com/2009/06/asyncapi/dataload"}}
      it "returns the result_id as a string" do
        expect(Bulkforce::Http).to receive(:query_batch_result_id).
          with(instance, session_id, job_id, batch_id, api_version).
          and_return(single_result)

        expect(subject.query_batch_result_id(job_id, batch_id)).to eq(single_result)
      end
    end

    context "with an array of page of results" do
      let(:multiple_result) {{:result=>["752M00000001Vgt", "752M00000001Vgy"], :@xmlns=>"http://www.force.com/2009/06/asyncapi/dataload"}}
      it "returns the result_id as a string" do
        expect(Bulkforce::Http).to receive(:query_batch_result_id).
          with(instance, session_id, job_id, batch_id, api_version).
          and_return(multiple_result)

        expect(subject.query_batch_result_id(job_id, batch_id)).to eq(multiple_result)
      end
    end
  end
end
