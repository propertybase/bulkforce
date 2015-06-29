shared_examples "configuration settings" do |name:, expected_default:|
  it "has default for #{name} set to #{expected_default}" do
    expect(subject.send(name.to_sym)).to eq(expected_default)
  end

  it "can set #{name} to custom value" do
    subject.send("#{name}=".to_sym, "custom value")
    expect(subject.send(name.to_sym)).to eq("custom value")
  end
end
