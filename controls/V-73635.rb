control 'V-73635' do
  title "The setting Domain member: Digitally encrypt secure channel data (when
  possible) must be configured to enabled."
  desc "Requests sent on the secure channel are authenticated, and sensitive
  information (such as passwords) is encrypted, but not all information is
  encrypted. If this policy is enabled, outgoing secure channel traffic will be
  encrypted.
  "
  impact 0.5
  tag "gtitle": 'SRG-OS-000423-GPOS-00187'
  tag "satisfies": ['SRG-OS-000423-GPOS-00187', 'SRG-OS-000424-GPOS-00188']
  tag "gid": 'V-73635'
  tag "rid": 'SV-88299r1_rule'
  tag "stig_id": 'WN16-SO-000090'
  tag "fix_id": 'F-80085r1_fix'
  tag "cci": ['CCI-002418', 'CCI-002421']
  tag "nist": ['SC-8', 'SC-8 (1)', 'Rev_4']
  tag "documentable": false
  desc "check", "If the following registry value does not exist or is not
  configured as specified, this is a finding.

  Registry Hive: HKEY_LOCAL_MACHINE
  Registry Path: \\SYSTEM\\CurrentControlSet\\Services\\Netlogon\\Parameters\\

  Value Name: SealSecureChannel

  Value Type: REG_DWORD
  Value: 0x00000001 (1)"
  desc "fix", "Configure the policy value for Computer Configuration >> Windows
  Settings >> Security Settings >> Local Policies >> Security Options >> Domain
  member: Digitally encrypt secure channel data (when possible) to Enabled."
  describe registry_key('HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Netlogon\\Parameters') do
    it { should have_property 'SealSecureChannel' }
    its('SealSecureChannel') { should cmp 1 }
  end
end
