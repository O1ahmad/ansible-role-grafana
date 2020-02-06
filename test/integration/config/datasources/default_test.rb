title "Grafana datasources configuration integration tests"

describe file('/opt/grafana/conf/provisioning/datasources/test-example.yml') do
  it { should exist }
  its('owner') { should eq('grafana') }
  its('group') { should eq('grafana') }

  its('content') { should match('apiVersion: 1') }
  its('content') { should match('url: http://localhost:9090') }
  its('content') { should match('url: http://localhost:9200') }
  its('content') { should match('deleteDatasources:') }
end
