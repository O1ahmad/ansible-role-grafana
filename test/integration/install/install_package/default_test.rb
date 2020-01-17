title "Default role integrated test file"

describe user('grafana') do
  it { should exist }
end

describe group('grafana') do
  it { should exist }
end

describe package('grafana') do
  it { should be_installed }
end
