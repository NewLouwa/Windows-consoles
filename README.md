# Windows Console Manager (PowerShell)

A modern graphical interface in PowerShell to manage and launch Windows consoles (MMC tools and system utilities). This program is designed for system administrators and divides the consoles into two categories:
- **Server Consoles**: For managing Windows server tools.
- **Client Consoles**: For managing workstation/user tools.

## Features

- **Comprehensive Console List**: Includes a wide range of built-in server and client consoles, including Active Directory, DNS, DHCP, Firewall, Task Scheduler, Resource Monitor, and more.
- **Table View**: Consoles are displayed in a searchable, sortable table with Name, Command, and Description columns.
- **Search/Filter**: Quickly filter consoles by name or description.
- **Add/Edit/Delete**: Add your own consoles, edit or remove user-added entries (built-ins are protected).
- **Persistent Storage**: User-added consoles are saved and reloaded automatically.
- **Color Coding**: Server and client consoles are visually distinguished.
- **Robust Validation**: Prevents duplicates, checks if commands exist, and provides clear error messages.

---

## Installation & Prerequisites

- **Windows 10/11** (or Server equivalent)
- **PowerShell 5.1 or later** (Windows PowerShell, not PowerShell Core)
- No external dependencies; uses built-in Windows Forms

---

## Usage

1. Download or clone this repository.
2. Open a PowerShell prompt in the project directory.
3. Run the script:
   ```powershell
   .\WindowsConsoleManager.ps1
   ```
   (If you get an execution policy error, run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` in the same session.)

4. The GUI will open with two sections:
   - **Server Consoles**: Tools for server management
   - **Client Consoles**: Tools for workstation/user management

5. Use the search boxes to filter, select a console to view details, and click **Launch** to open it.
6. Add new consoles using the form at the bottom. Edit or delete your own entries as needed.

---

## Customization
- To add more built-in consoles, edit the `$serverConsoles` or `$clientConsoles` lists at the top of `WindowsConsoleManager.ps1`.
- User-added consoles are saved in JSON files and persist across sessions.

---

## License
This project is licensed under the MIT license. You are free to use, modify, and distribute it under the terms of the license.

---

## Credits
Originally inspired by a Python version, now fully implemented and enhanced in PowerShell for a native Windows sysadmin experience.

