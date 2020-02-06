title "Grafana notifiers configuration integration tests"

describe file('/opt/grafana/conf/provisioning/notifiers/test-example.yml') do
  it { should exist }
  its('owner') { should eq('grafana') }
  its('group') { should eq('grafana') }
  its('content') { should match('name: test-slack') }
  its('content') { should match('uploadImage: true') }
  its('content') { should match('name: test-email') }
  its('content') { should match('addresses: example1234@example.com') }
end
