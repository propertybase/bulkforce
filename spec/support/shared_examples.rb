shared_examples "configuration settings" do |name:, expected_default:, env_variable:|
  it "has default for #{name} set to #{expected_default}" do
    expect(subject.send(name.to_sym)).to eq(expected_default)
  end

  it "can set #{name} to custom value" do
    subject.send("#{name}=".to_sym, "custom value")
    expect(subject.send(name.to_sym)).to eq("custom value")
  end

  it "can overwrite the default value by ENV variable" do
    ENV[env_variable] = "value by env"
    expect(subject.send(name.to_sym)).to eq("value by env")
  end

  it "can overwrite env variable by custom value" do
    ENV[env_variable] = "value by env"
    subject.send("#{name}=".to_sym, "custom value overwrites env")
    expect(subject.send(name.to_sym)).to eq("custom value overwrites env")
  end
end
