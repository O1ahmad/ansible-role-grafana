title "Grafana plugins installation integration tests"

describe directory('/mnt/data/grafana/plugins') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }
  its('mode') { should cmp '0755' }
end

describe directory('/mnt/data/grafana/plugins/petrslavotinek-carpetplot-panel') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }
  its('mode') { should cmp '0755' }
end

describe directory('/mnt/data/grafana/plugins/briangann-gauge-panel') do
  it { should exist }
  its('owner') { should eq 'grafana' }
  its('group') { should eq 'grafana' }
  its('mode') { should cmp '0755' }
end
