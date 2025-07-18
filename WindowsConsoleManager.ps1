# Windows Console Manager in PowerShell with DataGridView
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define initial server and client consoles
$serverConsoles = @(
    @{ Name = 'Active Directory Users and Computers'; Command = 'dsa.msc'; Description = 'Manage AD users and computers.' },
    @{ Name = 'Active Directory Domains and Trusts'; Command = 'domain.msc'; Description = 'Manage AD domain trusts.' },
    @{ Name = 'Active Directory Sites and Services'; Command = 'dssite.msc'; Description = 'Manage AD replication and topology.' },
    @{ Name = 'Group Policy Management Console'; Command = 'gpmc.msc'; Description = 'Manage group policies.' },
    @{ Name = 'DNS Manager'; Command = 'dnsmgmt.msc'; Description = 'Manage DNS zones and records.' },
    @{ Name = 'DHCP Management'; Command = 'dhcpmgmt.msc'; Description = 'Manage DHCP leases and options.' },
    @{ Name = 'AD Federation Services Console'; Command = 'adfs.msc'; Description = 'Manage identity federation.' },
    @{ Name = 'ADSI Edit'; Command = 'adsiedit.msc'; Description = 'Edit AD schema and objects.' },
    @{ Name = 'Failover Cluster Manager'; Command = 'cluadmin.msc'; Description = 'Manage failover clusters.' },
    @{ Name = 'Active Directory Schema'; Command = 'schmmgmt.msc'; Description = 'Manage and extend the AD schema.' },
    @{ Name = 'Resultant Set of Policy (RSoP)'; Command = 'rsop.msc'; Description = 'Analyze and report applied group policies.' },
    @{ Name = 'Print Management'; Command = 'printmanagement.msc'; Description = 'Manage printers and print queues.' },
    @{ Name = 'Windows Server Backup'; Command = 'wbadmin.msc'; Description = 'Manage server backup and restore.' },
    @{ Name = 'Windows Firewall with Advanced Security'; Command = 'wf.msc'; Description = 'Configure advanced firewall rules.' },
    @{ Name = 'Remote Desktop Services Manager'; Command = 'tsadmin.msc'; Description = 'Manage RDS sessions (legacy).' },
    @{ Name = 'Network Policy Server'; Command = 'nps.msc'; Description = 'Manage network policies and access services.' }
)

$clientConsoles = @(
    @{ Name = 'Computer Management'; Command = 'compmgmt.msc'; Description = 'Multiple admin tools.' },
    @{ Name = 'Group Policy Management Editor'; Command = 'gpedit.msc'; Description = 'Edit local group policies.' },
    @{ Name = 'Local Users and Groups'; Command = 'lusrmgr.msc'; Description = 'Manage local users and groups.' },
    @{ Name = 'Device Manager'; Command = 'devmgmt.msc'; Description = 'Manage devices and drivers.' },
    @{ Name = 'Disk Management'; Command = 'diskmgmt.msc'; Description = 'Manage disks and partitions.' },
    @{ Name = 'Performance Monitor'; Command = 'perfmon.msc'; Description = 'Monitor system performance.' },
    @{ Name = 'Services'; Command = 'services.msc'; Description = 'Manage Windows services.' },
    @{ Name = 'Event Viewer'; Command = 'eventvwr.msc'; Description = 'View event logs.' },
    @{ Name = 'Certificates'; Command = 'certmgr.msc'; Description = 'Manage certificates.' },
    @{ Name = 'Shared Folders'; Command = 'fsmgmt.msc'; Description = 'Manage shared folders.' },
    @{ Name = 'Hyper-V Manager'; Command = 'virtmgmt.msc'; Description = 'Manage Hyper-V VMs.' },
    @{ Name = 'Task Scheduler'; Command = 'taskschd.msc'; Description = 'Manage scheduled tasks.' },
    @{ Name = 'Local Security Policy'; Command = 'secpol.msc'; Description = 'Manage local security policies.' },
    @{ Name = 'Component Services'; Command = 'comexp.msc'; Description = 'Manage COM+ and DCOM config.' },
    @{ Name = 'Windows Memory Diagnostic'; Command = 'mdsched.exe'; Description = 'Schedule a memory test on reboot.' },
    @{ Name = 'System Configuration'; Command = 'msconfig.exe'; Description = 'Manage startup, boot, and services.' },
    @{ Name = 'Resource Monitor'; Command = 'resmon.exe'; Description = 'Real-time resource monitoring.' },
    @{ Name = 'System Information'; Command = 'msinfo32.exe'; Description = 'View detailed system information.' },
    @{ Name = 'Registry Editor'; Command = 'regedit.exe'; Description = 'Edit the Windows registry.' },
    @{ Name = 'Network Connections'; Command = 'ncpa.cpl'; Description = 'Manage network connections.' }
)

# Persistent storage file paths
$serverFile = Join-Path $PSScriptRoot 'server_consoles.json'
$clientFile = Join-Path $PSScriptRoot 'client_consoles.json'

# Load user consoles from file if present
function Load-UserConsoles {
    param($file)
    if (Test-Path $file) {
        try {
            $json = Get-Content $file -Raw | ConvertFrom-Json
            return @($json | ForEach-Object { $_ })
        } catch { return @() }
    } else {
        return @()
    }
}

# Save user consoles to file
function Save-UserConsoles {
    param($file, $consoles)
    $consoles | ConvertTo-Json -Depth 3 | Set-Content $file
}

# Helper: Check if command exists (in PATH or as .msc in system32)
function Test-ConsoleCommand {
    param($cmd)
    if ($cmd -match '\.msc$') {
        $mscPath = Join-Path $env:WINDIR "System32\$cmd"
        return (Test-Path $mscPath)
    } else {
        $found = Get-Command $cmd -ErrorAction SilentlyContinue
        return ($null -ne $found)
    }
}

# Built-in consoles
$builtinServerConsoles = $serverConsoles
$builtinClientConsoles = $clientConsoles

# User consoles (loaded from file)
$userServerConsoles = Load-UserConsoles $serverFile
$userClientConsoles = Load-UserConsoles $clientFile

# Merge for display
function Get-ServerConsoles { return $builtinServerConsoles + $userServerConsoles }
function Get-ClientConsoles { return $builtinClientConsoles + $userClientConsoles }

# Update DataGridViews
function Refresh-All {
    Refresh-DataGridView $dgvServer (Get-ServerConsoles) $true
    Refresh-DataGridView $dgvClient (Get-ClientConsoles) $false
}

# Helper to refresh a DataGridView
function Refresh-DataGridView {
    param($DGV, $Data, $isServer)
    $DGV.Rows.Clear()
    foreach ($item in $Data) {
        $idx = $DGV.Rows.Add($item.Name, $item.Command, $item.Description)
        if ($isServer -eq $true) {
            $DGV.Rows[$idx].DefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(230,245,255) # light blue
        } elseif ($isServer -eq $false) {
            $DGV.Rows[$idx].DefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(230,255,230) # light green
        }
    }
}

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Console Manager'
$form.Size = New-Object System.Drawing.Size(1100,600)
$form.StartPosition = 'CenterScreen'

# Add search/filter boxes above each DataGridView
$lblSearchServer = New-Object System.Windows.Forms.Label
$lblSearchServer.Text = 'Search:'
$lblSearchServer.Location = '20,0'
$lblSearchServer.Size = '50,20'
$form.Controls.Add($lblSearchServer)
$txtSearchServer = New-Object System.Windows.Forms.TextBox
$txtSearchServer.Location = '70,0'
$txtSearchServer.Size = '300,20'
$form.Controls.Add($txtSearchServer)

$lblSearchClient = New-Object System.Windows.Forms.Label
$lblSearchClient.Text = 'Search:'
$lblSearchClient.Location = '400,0'
$lblSearchClient.Size = '50,20'
$form.Controls.Add($lblSearchClient)
$txtSearchClient = New-Object System.Windows.Forms.TextBox
$txtSearchClient.Location = '450,0'
$txtSearchClient.Size = '300,20'
$form.Controls.Add($txtSearchClient)

# Filtering logic
function Filter-Consoles {
    param($allConsoles, $filter)
    if ([string]::IsNullOrWhiteSpace($filter)) { return $allConsoles }
    $f = $filter.ToLower()
    return $allConsoles | Where-Object { $_.Name.ToLower().Contains($f) -or $_.Description.ToLower().Contains($f) }
}

# Server Consoles DataGridView
$lblServer = New-Object System.Windows.Forms.Label
$lblServer.Text = 'Server Consoles'
$lblServer.Location = '20,30'
$lblServer.Size = '250,20'
$form.Controls.Add($lblServer)

$dgvServer = New-Object System.Windows.Forms.DataGridView
$dgvServer.Location = '20,60'
$dgvServer.Size = '350,300'
$dgvServer.ColumnCount = 3
$dgvServer.Columns[0].Name = 'Name'
$dgvServer.Columns[1].Name = 'Command'
$dgvServer.Columns[2].Name = 'Description'
$dgvServer.SelectionMode = 'FullRowSelect'
$dgvServer.MultiSelect = $false
$dgvServer.ReadOnly = $true
$dgvServer.AllowUserToAddRows = $false
$dgvServer.RowHeadersVisible = $false
$dgvServer.AutoSizeColumnsMode = 'AllCells'
foreach ($col in $dgvServer.Columns) { $col.DefaultCellStyle.WrapMode = [System.Windows.Forms.DataGridViewTriState]::True }
$dgvServer.DefaultCellStyle.Font = New-Object System.Drawing.Font('Segoe UI',10)
$form.Controls.Add($dgvServer)
Refresh-DataGridView $dgvServer $serverConsoles $true

# Client Consoles DataGridView
$lblClient = New-Object System.Windows.Forms.Label
$lblClient.Text = 'Client Consoles'
$lblClient.Location = '400,30'
$lblClient.Size = '250,20'
$form.Controls.Add($lblClient)

$dgvClient = New-Object System.Windows.Forms.DataGridView
$dgvClient.Location = '400,60'
$dgvClient.Size = '350,300'
$dgvClient.ColumnCount = 3
$dgvClient.Columns[0].Name = 'Name'
$dgvClient.Columns[1].Name = 'Command'
$dgvClient.Columns[2].Name = 'Description'
$dgvClient.SelectionMode = 'FullRowSelect'
$dgvClient.MultiSelect = $false
$dgvClient.ReadOnly = $true
$dgvClient.AllowUserToAddRows = $false
$dgvClient.RowHeadersVisible = $false
$dgvClient.AutoSizeColumnsMode = 'AllCells'
foreach ($col in $dgvClient.Columns) { $col.DefaultCellStyle.WrapMode = [System.Windows.Forms.DataGridViewTriState]::True }
$dgvClient.DefaultCellStyle.Font = New-Object System.Drawing.Font('Segoe UI',10)
$form.Controls.Add($dgvClient)
Refresh-DataGridView $dgvClient $clientConsoles $false

# Details Label
$lblDetails = New-Object System.Windows.Forms.Label
$lblDetails.Text = 'Details:'
$lblDetails.Location = '800,30'
$lblDetails.Size = '250,20'
$form.Controls.Add($lblDetails)

$txtDetails = New-Object System.Windows.Forms.TextBox
$txtDetails.Location = '800,60'
$txtDetails.Size = '250,100'
$txtDetails.Multiline = $true
$txtDetails.ReadOnly = $true
$form.Controls.Add($txtDetails)

# Show details when selection changes
$dgvServer.add_SelectionChanged({
    if ($dgvServer.SelectedRows.Count -gt 0) {
        $row = $dgvServer.SelectedRows[0]
        $txtDetails.Text = "Name: $($row.Cells[0].Value)`r`nCommand: $($row.Cells[1].Value)`r`nDescription: $($row.Cells[2].Value)"
    }
})
$dgvClient.add_SelectionChanged({
    if ($dgvClient.SelectedRows.Count -gt 0) {
        $row = $dgvClient.SelectedRows[0]
        $txtDetails.Text = "Name: $($row.Cells[0].Value)`r`nCommand: $($row.Cells[1].Value)`r`nDescription: $($row.Cells[2].Value)"
    }
})

# Launch buttons
$btnLaunchServer = New-Object System.Windows.Forms.Button
$btnLaunchServer.Text = 'Launch Server Console'
$btnLaunchServer.Location = '20,380'
$btnLaunchServer.Size = '350,30'
$btnLaunchServer.Add_Click({
    if ($dgvServer.SelectedRows.Count -gt 0) {
        $cmd = $dgvServer.SelectedRows[0].Cells[1].Value
        try { Start-Process $cmd } catch { [System.Windows.Forms.MessageBox]::Show("Failed to launch: $cmd`n$($_.Exception.Message)", 'Error') }
    }
})
$form.Controls.Add($btnLaunchServer)

$btnLaunchClient = New-Object System.Windows.Forms.Button
$btnLaunchClient.Text = 'Launch Client Console'
$btnLaunchClient.Location = '400,380'
$btnLaunchClient.Size = '350,30'
$btnLaunchClient.Add_Click({
    if ($dgvClient.SelectedRows.Count -gt 0) {
        $cmd = $dgvClient.SelectedRows[0].Cells[1].Value
        try { Start-Process $cmd } catch { [System.Windows.Forms.MessageBox]::Show("Failed to launch: $cmd`n$($_.Exception.Message)", 'Error') }
    }
})
$form.Controls.Add($btnLaunchClient)

# Add Console Section
$lblAdd = New-Object System.Windows.Forms.Label
$lblAdd.Text = 'Add New Console'
$lblAdd.Location = '20,470'
$lblAdd.Size = '200,20'
$form.Controls.Add($lblAdd)

$lblName = New-Object System.Windows.Forms.Label
$lblName.Text = 'Name:'
$lblName.Location = '20,500'
$lblName.Size = '60,20'
$form.Controls.Add($lblName)
$txtName = New-Object System.Windows.Forms.TextBox
$txtName.Location = '80,500'
$txtName.Size = '150,20'
$form.Controls.Add($txtName)

$lblCmd = New-Object System.Windows.Forms.Label
$lblCmd.Text = 'Command:'
$lblCmd.Location = '20,530'
$lblCmd.Size = '60,20'
$form.Controls.Add($lblCmd)
$txtCmd = New-Object System.Windows.Forms.TextBox
$txtCmd.Location = '80,530'
$txtCmd.Size = '150,20'
$form.Controls.Add($txtCmd)

$lblDesc = New-Object System.Windows.Forms.Label
$lblDesc.Text = 'Description:'
$lblDesc.Location = '20,560'
$lblDesc.Size = '70,20'
$form.Controls.Add($lblDesc)
$txtDesc = New-Object System.Windows.Forms.TextBox
$txtDesc.Location = '90,560'
$txtDesc.Size = '140,20'
$form.Controls.Add($txtDesc)

$btnAddServer = New-Object System.Windows.Forms.Button
$btnAddServer.Text = 'Add to Server'
$btnAddServer.Location = '250,500'
$btnAddServer.Size = '120,30'
$btnAddServer.Add_Click({
    if ($txtName.Text -and $txtCmd.Text) {
        # Prevent duplicates
        $exists = ($userServerConsoles + $builtinServerConsoles) | Where-Object { $_.Name -eq $txtName.Text -and $_.Command -eq $txtCmd.Text }
        if ($exists) {
            [System.Windows.Forms.MessageBox]::Show('A console with this name and command already exists.','Warning')
            return
        }
        # Validate command
        if (-not (Test-ConsoleCommand $txtCmd.Text)) {
            [System.Windows.Forms.MessageBox]::Show('The command does not exist or is not found in System32.','Warning')
            return
        }
        $userServerConsoles += @{ Name = $txtName.Text; Command = $txtCmd.Text; Description = $txtDesc.Text }
        Save-UserConsoles $serverFile $userServerConsoles
        Refresh-All
        $txtName.Clear(); $txtCmd.Clear(); $txtDesc.Clear()
    } else {
        [System.Windows.Forms.MessageBox]::Show('Please enter Name and Command.','Warning')
    }
})
$form.Controls.Add($btnAddServer)

$btnAddClient = New-Object System.Windows.Forms.Button
$btnAddClient.Text = 'Add to Client'
$btnAddClient.Location = '250,540'
$btnAddClient.Size = '120,30'
$btnAddClient.Add_Click({
    if ($txtName.Text -and $txtCmd.Text) {
        $exists = ($userClientConsoles + $builtinClientConsoles) | Where-Object { $_.Name -eq $txtName.Text -and $_.Command -eq $txtCmd.Text }
        if ($exists) {
            [System.Windows.Forms.MessageBox]::Show('A console with this name and command already exists.','Warning')
            return
        }
        if (-not (Test-ConsoleCommand $txtCmd.Text)) {
            [System.Windows.Forms.MessageBox]::Show('The command does not exist or is not found in System32.','Warning')
            return
        }
        $userClientConsoles += @{ Name = $txtName.Text; Command = $txtCmd.Text; Description = $txtDesc.Text }
        Save-UserConsoles $clientFile $userClientConsoles
        Refresh-All
        $txtName.Clear(); $txtCmd.Clear(); $txtDesc.Clear()
    } else {
        [System.Windows.Forms.MessageBox]::Show('Please enter Name and Command.','Warning')
    }
})
$form.Controls.Add($btnAddClient)

# Add Edit and Delete buttons for Server
$btnEditServer = New-Object System.Windows.Forms.Button
$btnEditServer.Text = 'Edit Server Console'
$btnEditServer.Location = '20,420'
$btnEditServer.Size = '170,30'
$btnEditServer.Add_Click({
    if ($dgvServer.SelectedRows.Count -gt 0) {
        $row = $dgvServer.SelectedRows[0]
        $name = $row.Cells[0].Value
        $cmd = $row.Cells[1].Value
        $desc = $row.Cells[2].Value
        # Only allow editing user consoles
        $idx = $userServerConsoles.FindIndex({ $_.Name -eq $name -and $_.Command -eq $cmd -and $_.Description -eq $desc })
        if ($idx -ge 0) {
            $txtName.Text = $name
            $txtCmd.Text = $cmd
            $txtDesc.Text = $desc
            # On save, update the user console
            $btnAddServer.Text = 'Save Edit'
            $btnAddServer.Add_Click({
                if ($txtName.Text -and $txtCmd.Text) {
                    $userServerConsoles[$idx] = @{ Name = $txtName.Text; Command = $txtCmd.Text; Description = $txtDesc.Text }
                    Save-UserConsoles $serverFile $userServerConsoles
                    Refresh-All
                    $txtName.Clear(); $txtCmd.Clear(); $txtDesc.Clear()
                    $btnAddServer.Text = 'Add to Server'
                    $btnAddServer.Remove_Click($null)
                }
            })
        } else {
            [System.Windows.Forms.MessageBox]::Show('Only user-added consoles can be edited.','Info')
        }
    }
})
$form.Controls.Add($btnEditServer)

$btnDeleteServer = New-Object System.Windows.Forms.Button
$btnDeleteServer.Text = 'Delete Server Console'
$btnDeleteServer.Location = '200,420'
$btnDeleteServer.Size = '170,30'
$btnDeleteServer.Add_Click({
    if ($dgvServer.SelectedRows.Count -gt 0) {
        $row = $dgvServer.SelectedRows[0]
        $name = $row.Cells[0].Value
        $cmd = $row.Cells[1].Value
        $desc = $row.Cells[2].Value
        $idx = $userServerConsoles.FindIndex({ $_.Name -eq $name -and $_.Command -eq $cmd -and $_.Description -eq $desc })
        if ($idx -ge 0) {
            $userServerConsoles = $userServerConsoles[0..($idx-1)] + $userServerConsoles[($idx+1)..($userServerConsoles.Count-1)]
            Save-UserConsoles $serverFile $userServerConsoles
            Refresh-All
        } else {
            [System.Windows.Forms.MessageBox]::Show('Only user-added consoles can be deleted.','Info')
        }
    }
})
$form.Controls.Add($btnDeleteServer)

# Add Edit and Delete buttons for Client
$btnEditClient = New-Object System.Windows.Forms.Button
$btnEditClient.Text = 'Edit Client Console'
$btnEditClient.Location = '400,420'
$btnEditClient.Size = '170,30'
$btnEditClient.Add_Click({
    if ($dgvClient.SelectedRows.Count -gt 0) {
        $row = $dgvClient.SelectedRows[0]
        $name = $row.Cells[0].Value
        $cmd = $row.Cells[1].Value
        $desc = $row.Cells[2].Value
        $idx = $userClientConsoles.FindIndex({ $_.Name -eq $name -and $_.Command -eq $cmd -and $_.Description -eq $desc })
        if ($idx -ge 0) {
            $txtName.Text = $name
            $txtCmd.Text = $cmd
            $txtDesc.Text = $desc
            $btnAddClient.Text = 'Save Edit'
            $btnAddClient.Add_Click({
                if ($txtName.Text -and $txtCmd.Text) {
                    $userClientConsoles[$idx] = @{ Name = $txtName.Text; Command = $txtCmd.Text; Description = $txtDesc.Text }
                    Save-UserConsoles $clientFile $userClientConsoles
                    Refresh-All
                    $txtName.Clear(); $txtCmd.Clear(); $txtDesc.Clear()
                    $btnAddClient.Text = 'Add to Client'
                    $btnAddClient.Remove_Click($null)
                }
            })
        } else {
            [System.Windows.Forms.MessageBox]::Show('Only user-added consoles can be edited.','Info')
        }
    }
})
$form.Controls.Add($btnEditClient)

$btnDeleteClient = New-Object System.Windows.Forms.Button
$btnDeleteClient.Text = 'Delete Client Console'
$btnDeleteClient.Location = '580,420'
$btnDeleteClient.Size = '170,30'
$btnDeleteClient.Add_Click({
    if ($dgvClient.SelectedRows.Count -gt 0) {
        $row = $dgvClient.SelectedRows[0]
        $name = $row.Cells[0].Value
        $cmd = $row.Cells[1].Value
        $desc = $row.Cells[2].Value
        $idx = $userClientConsoles.FindIndex({ $_.Name -eq $name -and $_.Command -eq $cmd -and $_.Description -eq $desc })
        if ($idx -ge 0) {
            $userClientConsoles = $userClientConsoles[0..($idx-1)] + $userClientConsoles[($idx+1)..($userClientConsoles.Count-1)]
            Save-UserConsoles $clientFile $userClientConsoles
            Refresh-All
        } else {
            [System.Windows.Forms.MessageBox]::Show('Only user-added consoles can be deleted.','Info')
        }
    }
})
$form.Controls.Add($btnDeleteClient)

# Now set up search/filter event handlers
$txtSearchServer.Add_TextChanged({
    $filtered = Filter-Consoles (Get-ServerConsoles) $txtSearchServer.Text
    Refresh-DataGridView $dgvServer $filtered $true
})
$txtSearchClient.Add_TextChanged({
    $filtered = Filter-Consoles (Get-ClientConsoles) $txtSearchClient.Text
    Refresh-DataGridView $dgvClient $filtered $false
})

# Now it's safe to clear filters and refresh all
$txtSearchServer.Text = ''
$txtSearchClient.Text = ''
Refresh-All

# Show the form
[void]$form.ShowDialog() 