control 'V-73307' do
  title 'The time service must synchronize with an appropriate DoD time source.'
  desc  "The Windows Time Service controls time synchronization settings. Time
  synchronization is essential for authentication and auditing purposes. If the
  Windows Time Service is used, it must synchronize with a secure, authorized
  time source. Domain-joined systems are automatically configured to synchronize
  with domain controllers. If an NTP server is configured, it must synchronize
  with a secure, authorized time source."
  impact 0.3
  tag "gtitle": 'SRG-OS-000355-GPOS-00143'
  tag "gid": 'V-73307'
  tag "rid": 'SV-87959r1_rule'
  tag "stig_id": 'WN16-00-000450'
  tag "fix_id": 'F-79749r1_fix'
  tag "cci": ['CCI-001891']
  tag "nist": ['AU-8 (1) (a)', 'Rev_4']
  tag "documentable": false
  desc "check", "Review the Windows time service configuration.

  Open an elevated Command Prompt (run as administrator).

  Enter W32tm /query /configuration.

  Domain-joined systems (excluding the domain controller with the PDC emulator
  role):

  If the value for Type under NTP Client is not NT5DS, this is a
  finding.

  Other systems:

  If systems are configured with a Type of NTP, including standalone
  systems and the domain controller with the PDC Emulator role, and do not have a
  DoD time server defined for NTPServer, this is a finding.

  To determine the domain controller with the PDC Emulator role:

  Open PowerShell.

  Enter Get-ADDomain | FT PDCEmulator."
  desc "fix", "Configure the system to synchronize time with an appropriate DoD
  time source.

  Domain-joined systems use NT5DS to synchronize time from other systems in the
  domain by default.

  If the system needs to be configured to an NTP server, configure the system to
  point to an authorized time server by setting the policy value for Computer
  Configuration >> Administrative Templates >> System >> Windows Time Service >>
  Time Providers >> Configure Windows NTP Client to Enabled, and
  configure the NtpServer field to point to an appropriate DoD time server.

  The US Naval Observatory operates stratum 1 time servers, identified at
  http://tycho.usno.navy.mil/ntp.html. Time synchronization will occur through a
  hierarchy of time servers down to the local level. Clients and lower-level
  servers will synchronize with an authorized time server in the hierarchy."
  is_domain = command('wmic computersystem get domain | FINDSTR /V Domain').stdout.strip

  describe command(' W32tm /query /configuration | Findstr Type') do
    its('stdout') { should eq "Type: NT5DS (Local)\r\n" }
  end if is_domain != 'WORKGROUP'

  get_type = command('W32tm /query /configuration | Findstr Type').stdout.strip

  describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32time\Parameters') do
    its('NTPServer') { should_not cmp 'time.windows.com,0x9' }
  end if is_domain == 'WORKGROUP'
end
