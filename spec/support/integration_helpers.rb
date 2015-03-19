module Integration
  module Operations
    def insert_contacts
      client.insert(
        "Contact", [
          {
            "FirstName" => "Leif",
            "LastName" => "Propertybase",
            "LeadSource" => "integration_test",
            "Email" => "#{SecureRandom.hex(5)}@pba.io",
          },
          {
            "FirstName" => "Peter",
            "LastName" => "Propertybase",
            "LeadSource" => "integration_test",
            "Email" => "#{SecureRandom.hex(5)}@pba.io",
          },
        ]).final_status.freeze
    end

    def upsert_contacts
      client.upsert(
        "Contact",
        [
          {
            "FirstName" => "Leif",
            external_id => "leif_pba",
            "LastName" => "Propertybase",
            "LeadSource" => "integration_test",
            "Email" => "#{SecureRandom.hex(5)}@pba.io",
          },
          {
            "FirstName" => "Peter",
            external_id => "peter_pba",
            "LastName" => "Propertybase",
            "LeadSource" => "integration_test",
            "Email" => "#{SecureRandom.hex(5)}@pba.io",
          },
        ],
        external_id,
        ).final_status.freeze
    end

    def update_contacts
      insert_contacts
      all_contacts = query_all_test_contacts.map{|entry| entry.merge("FirstName" => "Updated") }
      client.update("Contact", all_contacts).final_status.freeze
    end

    def delete_contacts
      insert_contacts
      all_contacts = query_all_test_contacts
      client.delete("Contact", all_contacts).final_status.freeze
    end

    def query_all_test_contacts
      client.query("Contact", "select Id from Contact where LeadSource = 'integration_test'")[:results]
    end

    def external_id
      "pba__SystemExternalId__c"
    end
  end
end
