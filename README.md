# Shell-Scripts

A collection of practical Bash shell scripts designed to automate common Linux system administration, monitoring, backup, log analysis, and user management tasks.

This repository focuses on real-world scenarios encountered in Linux administration, AWS DevOps, and production support environments.

## 📂 Scripts Overview

| Script | Description |
|---|---|
| `backup.sh` | Creates compressed backups with timestamped filenames and retention-based cleanup. |
| `log_analyzer.sh` | Analyzes application logs, counts errors, identifies critical events, and generates summary reports. |
| `system_health.sh` | Monitors CPU, memory, disk usage, uptime, and system resource utilization. |
| `user_management.sh` | Automates Linux user management tasks, such as creating users and managing accounts. |

## 🚀 Features

- **System Monitoring:** Check CPU utilization, memory consumption, disk space, and system uptime.
- **Automated Backups:** Create timestamped archives and manage old backups according to a retention policy.
- **Log Analysis:** Identify errors and critical events, count occurrences, and generate readable reports.
- **User Management:** Simplify routine Linux user administration tasks.
- **Operational Automation:** Reduce repetitive manual work using reusable Bash scripts.
- **Production-Oriented Learning:** Practice scripting techniques useful for Linux administration and DevOps workflows.

## 🛠️ Prerequisites

- Ubuntu or another compatible Linux distribution.
- Bash shell.
- Appropriate permissions for the files, directories, and system resources being managed.
- Required utilities, depending on the script:
  - `zip` for ZIP-based backups.
  - `tar` for compressed TAR archives.
  - Standard Linux utilities such as `grep`, `awk`, `sed`, `df`, `free`, `ps`, and `find`.

Install commonly used utilities on Ubuntu:

```bash
sudo apt update
sudo apt install zip
```

## ⚙️ Getting Started

Clone the repository:

```bash
git clone https://github.com/rahulkadam09/Shell-Scripts.git
```

Navigate to the project directory:

```bash
cd Shell-Scripts
```

Grant execute permissions:

```bash
chmod +x *.sh
```

Run the required script using its documented arguments.

## 💻 Usage Examples

### 1. Backup Automation

Create a backup of a file or directory:

```bash
./backup.sh /path/to/source /path/to/backup
```

**Purpose:** Automates backup creation and cleanup of older backup files according to the configured retention policy.

### 2. Log Analysis

Analyze an application log:

```bash
./log_analyzer.sh /var/log/syslog
```

**Purpose:** Counts error messages, identifies critical events, and generates a summary report to help troubleshoot application or system issues.

### 3. System Health Monitoring

Generate a system health report:

```bash
./system_health.sh
```

**Purpose:** Displays system resource utilization, including CPU, memory, disk space, uptime, and running processes.

### 4. Linux User Management

Run the user management script:

```bash
./user_management.sh
```

**Purpose:** Automates supported user administration tasks. Review the script before execution to understand its required inputs and operations.

## 🔒 Best Practices

- Review scripts before running them on production servers.
- Validate input arguments and check command exit statuses.
- Use `sudo` only when elevated privileges are required.
- Avoid hardcoding passwords, tokens, or other sensitive information.
- Keep backups on separate storage and periodically test restoration.
- Test scripts in a development environment before production use.
- Use logging, monitoring, and appropriate file permissions for automated jobs.

## 🎯 Learning Objectives

This repository demonstrates practical experience with:

- Bash scripting and functions.
- Linux file and directory operations.
- Text processing with `grep`, `awk`, and `sed`.
- Process and resource monitoring.
- Backup automation and retention.
- Log analysis and troubleshooting.
- Linux user administration.
- Command-line automation and error handling.

## 🔮 Future Enhancements

Planned improvements include:

- Automated alerting for high CPU, memory, and disk utilization.
- Scheduled backups using cron.
- Backup integrity verification and restoration testing.
- Docker container health monitoring.
- HTTP endpoint availability checks.
- Improved error handling, logging, and configurable thresholds.

## 👨‍💻 Author

**Rahul Kadam**

GitHub: [@rahulkadam09](https://github.com/rahulkadam09)

---

If you find these scripts useful, feel free to explore the repository, suggest improvements, or contribute additional automation scripts.

**Disclaimer:** These scripts are intended for learning and operational automation. Review and test them in a non-production environment before using them on critical systems.
