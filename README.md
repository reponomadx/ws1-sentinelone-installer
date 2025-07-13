<p align="center">
  <img src="https://raw.githubusercontent.com/reponomadx/ws1-sentinelone-installer/main/reponomadx-logo.jpg" alt="reponomadx logo" width="350"/>
</p>

<h1 align="center">WS1 SentinelOne Installer for macOS</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS-black?logo=apple&logoColor=white" />
  <img src="https://img.shields.io/badge/MDM-WorkspaceONE-blue?logo=vmware" />
  <img src="https://img.shields.io/badge/Deployment-SentinelOne-purple" />
  <img src="https://img.shields.io/badge/License-MIT-brightgreen" />
</p>

---

Automated macOS installation and upgrade of SentinelOne using Workspace ONE UEM and Munki.  
This toolset was developed to address cases where standard app deployment methods fail to install or update the SentinelOne agent reliably.

---

## 📦 What It Does

### `s1_install.sh`
- ✅ Checks if SentinelOne is already installed  
- 📁 Verifies the PKG exists in the Munki cache  
- 🔐 Writes a registration token to disk  
- 📥 Copies payloads to a local managed user's Downloads folder  
- 🚀 Installs the SentinelOne agent using `installer`  
- 🧹 Cleans up all temporary files  

### `s1_upgrade.sh`
- 🔍 Checks current installed SentinelOne version  
- 🔁 Compares against expected version  
- 📦 Copies upgrade PKG if out of date  
- ⬆️ Performs in-place upgrade using `sentinelctl upgrade-pkg`  
- 🧹 Cleans up staging files  

---

## 🧰 Requirements

To use these scripts successfully in a Workspace ONE environment:

- SentinelOne `.pkg` must be present in Munki’s local cache  
- A base64-encoded **registration token** must be provided by your SentinelOne console  
- Workspace ONE UEM must inject a secure `password` variable into the script  
- A managed local macOS account must exist with a writable `/Users/username/Downloads` directory  
  → Need to elevate that account temporarily? Check out [macOS Elevated Admin Rights with Workspace ONE](https://github.com/reponomadx/macos-elevated-admin-ws1)

---

## 🚀 Deployment Method

1. Add the script(s) to Workspace ONE UEM under **Resources > Scripts**  
2. Use **System context**  
3. Run `s1_install.sh` on devices that need initial deployment  
4. Schedule `s1_upgrade.sh` to run periodically (e.g., every 4 hours)  
5. Add a **Secure String** variable named `password`  
6. Assign the script to your desired Smart Group (e.g., all macOS Workstations)

---

## ✍️ Customization

Before deployment, update the following values in the scripts:

```bash
TARGET_USER="Your_macOS_Service_Account"
echo "<Base64_SentinelOne_Token>" > "$TOKEN_FILE"
```

Replace:
- `Your_macOS_Service_Account` with the correct local user account  
- `<Base64_SentinelOne_Token>` with your actual SentinelOne token (in base64 format)

---

## 🛑 Security Notice

These scripts rely on Workspace ONE’s secure variable injection for authentication.  
**Do not hardcode credentials or tokens.** Always use UEM variables for secrets.

---

## 💬 Discussions

Have questions or feedback?  
Visit the [Discussions](../../discussions) tab to share tips, suggest features, or ask for help.

---

## 📄 License

This project is licensed under the terms of the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2025 Brian Irish

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in  
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS  
IN THE SOFTWARE.
```
